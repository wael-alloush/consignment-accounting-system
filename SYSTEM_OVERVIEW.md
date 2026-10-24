# Project Overview: Consignment Accounting System (نظام محاسبي لمتاجر الكمسيون / البيع بالعمولة)

## 1. Tech Stack (تقنيات المشروع)
- **Frontend Framework:** React.js
- **Backend Framework:** Node.js with Express.js
- **Database:** MariaDB 11.8+ (InnoDB, utf8mb4)
- **ORM:** Prisma ORM 7

---

## 2. Business Logic & Core Concepts
هذا النظام مخصص لإدارة **متاجر البيع بالعمولة**. البضاعة أمانة من موردين؛ الدفع بعد البيع بعد اقتطاع عمولة المتجر.

### أهم القواعد:
1. **العمولة على المنتج:** `commission_type` / `commission_value` / `commission_basis` (`per_unit` | `per_line`).
2. **تجميد القيم وقت البيع** على `sale_items` (`store_amount` / `vendor_amount` / snapshots).
3. **دفعات استلام حرّة الاختيار (ليست FIFO إلزامياً):** المخزون دفعات في `product_intake_items`؛ عند البيع يُخصَّص من أي دفعة فيها `quantity_remaining > 0` (الزبون قد يشتري الأحدث ويترك الأقدم). التسجيل عبر `sale_item_allocations`.
4. **بند بيع = مورد واحد:** إن خُصّصت كميات من موردين مختلفين في عملية واحدة، قسّم البنود في الـ POS. trigger `sia_*_vendor_check` يمنع تخصيص دفعة لمورد ≠ `sale_items.vendor_id`.
5. **حساب المورد اختياري:** `vendor_profiles.user_id` اختياري وunique.
6. **تسوية تفصيلية:** `gross_amount` / `deductions_amount` / `net_amount` (DECIMAL 14,2) مع CHECK؛ بنود فريدة على `sale_item_id`.
7. **إلغاء التسوية:** Transaction يحذف البنود ويعيد `unsettled`. الجداول المالية `ON DELETE RESTRICT` (إلغاء لا حذف).
8. **دفتر المورد (append-only):** `ref_type`/`ref_id` كلاهما NULL أو كلاهما معيّن (CHECK). UNIQUE `(tenant_id, vendor_id, entry_type, ref_type, ref_id)` حتى لا تفشل فاتورة متعددة الموردين. الرصيد: view `vendor_balances` بـ `SQL SECURITY INVOKER`.
9. **إشارة الدفتر:** موجب = مستحق للمورد؛ سالب = خصم/تسوية/سلف/تالف/شحن/مرتجع.
10. **عزل المستأجر:** FKs مركّبة `(id, tenant_id)`. مراجع المستخدمين بما فيها `voided_by` و`ledger.created_by`: `(..., tenant_id) → users(id, tenant_scope)` حيث `tenant_scope = IFNULL(tenant_id, 0)`. CHECK: `super_admin` بلا `tenant_id` وغيره معه.
11. **الحذف الناعم:** `deleted_at` + `slug_unique`/`name_unique` (varchar 255) تُعاد كتابتها بـ triggers إلى `value#id`.
12. **المخزون:** `stock_adjustments.quantity` دلتا موقّعة على `quantity_remaining`: **سالب يقلّل**، **موجب يزيد** (مثال: تالف `-5`، تصحيح `+2`). السبب `returned_to_vendor` ≠ مرتجع زبون. CHECK فقط `<> 0`.
13. **مرتجعات الزبون:** `sale_return_allocations` → نفس دفعة البيع؛ trigger `sra_*_check` يمنع تناقض `product_intake_item_id`. مجموع المرتجع ≤ المباع (تطبيق).
14. **إلغاء البيع:** `void_*`؛ يُمنع إلغاء فاتورة فيها بنود `settled` إلا بقيد عكسي. التسوية تُنشأ فقط لـ `sales.status='completed'`.
15. **النسخ الاحتياطي:** استخدم `mysqldump` — تصدير phpMyAdmin قد يحذف `ENGINE`/charset عند وجود CHECK.

### قيود CHECK في القاعدة:
- كميات الاستلام، هوية مبالغ بند البيع، عمولة النسبة ≤ 100، كميات التخصيص/المرتجع، صافي التسوية، إشارة قيود الدفتر، كمية التعديل ≠ 0.

### طبقة الخدمة (إلزامي):
- اختيار الدفعة: Transaction + `SELECT ... FOR UPDATE` على الدفعات المختارة (أي دفعة متاحة للمنتج، ليس بالضرورة الأقدم)؛ حدّث `quantity_remaining` داخل نفس المعاملة.
- تقريب موحّد (مثلاً ROUND HALF_UP) بحيث `store_amount + vendor_amount = line_total`.
- تطابق `unit_id` بين بند البيع ودفعة الاستلام (أو جدول `unit_conversions` لاحقاً).
- Job يحوّل `tenants.status` إلى `expired` عند انتهاء الاشتراك؛ منع تداخل اشتراكين في التطبيق؛ تشفير `bank_account_number`.

---

## 3. Core Calculations
عند بيع كمية $Q$ بسعر $P$ ونسبة عمولة $R\%$:
1. $\text{Total} = P \times Q$
2. $\text{StoreAmount} = \text{Total} \times (R/100)$
3. $\text{SupplierAmount} = \text{Total} - \text{StoreAmount}$

للعمولة الثابتة: `per_unit` → `commission_value × quantity`؛ `per_line` → مرة واحدة للسطر.

---

## 4. Data Model Layers
- **SaaS:** `tenants` (+ `currency`), `plans`, `subscriptions` (+ `currency_snapshot`)
- **Identity:** `users` (+ `tenant_scope`), `vendor_profiles`
- **Catalog:** `categories`, `products`, `units` (+ soft-delete unique keys)
- **Inventory:** `product_intakes`, `product_intake_items`, `stock_adjustments`
- **Sales:** `sales`, `sale_items`, `sale_item_allocations`, `sale_returns`, `sale_return_items`, `sale_return_allocations`
- **Settlements / Ledger:** `vendor_settlements`, `vendor_settlement_items`, `vendor_ledger_entries`, view `vendor_balances`
- **Ops:** `tenant_sequences`, `audit_logs` (`ip_address`, `request_id`)

تقرير آلية العمل: [SYSTEM_REPORT.md](SYSTEM_REPORT.md) · Word: [docs/SYSTEM_REPORT.docx](docs/SYSTEM_REPORT.docx)  
مخطط ERD: [docs/commision_system.drawio](docs/commision_system.drawio)

الهجرات: `…160000` → `…170000` → `…180000` (ledger/sales CHECKs) → `…180100` (tenant_scope عبر triggers).  
Triggers عبر mysql: `sia_*` (مورد التخصيص)، `sra_*` (مرتجع↔دفعة)، `users_*_tenant_scope`.  
`prisma migrate diff` يجب أن يبقى فارغاً. عند فشل هجرة: `--rolled-back` ثم إصلاح الملف ثم `deploy` — لا `--applied` على هجرة ناقصة.
