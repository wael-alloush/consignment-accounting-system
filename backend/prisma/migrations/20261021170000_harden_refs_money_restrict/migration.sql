-- Harden: role/tenant CHECK, ledger refs, money precision, composite user FKs,
-- INVOKER view, small CHECKs, soft-delete varchar(255), CASCADE→RESTRICT, trim indexes.
-- Vendor-match trigger is applied via mysql client after deploy (BEGIN/END not Prisma-safe).

-- 1) users role ↔ tenant
ALTER TABLE `users`
  ADD CONSTRAINT `chk_users_role_tenant` CHECK (
    (`role` = 'super_admin' AND `tenant_id` IS NULL)
    OR (`role` <> 'super_admin' AND `tenant_id` IS NOT NULL)
  );

-- 2) ledger ref_type / ref_id nullable + paired CHECK
ALTER TABLE `vendor_ledger_entries`
  MODIFY `ref_type` VARCHAR(191) NULL DEFAULT NULL,
  MODIFY `ref_id` INT(11) NULL DEFAULT NULL;

UPDATE `vendor_ledger_entries`
SET `ref_type` = NULL, `ref_id` = NULL
WHERE `ref_type` = '' AND `ref_id` = 0;

ALTER TABLE `vendor_ledger_entries`
  ADD CONSTRAINT `chk_ledger_ref` CHECK ((`ref_type` IS NULL) = (`ref_id` IS NULL));

-- 3) money precision + tenant/subscription currency
ALTER TABLE `tenants`
  ADD COLUMN `currency` VARCHAR(3) NOT NULL DEFAULT 'SYP' AFTER `owner_phone`;

ALTER TABLE `plans`
  MODIFY `price` DECIMAL(14, 2) NOT NULL;

ALTER TABLE `subscriptions`
  ADD COLUMN `currency_snapshot` VARCHAR(3) NOT NULL DEFAULT 'SYP' AFTER `price_snapshot`,
  MODIFY `price_snapshot` DECIMAL(14, 2) NOT NULL,
  MODIFY `amount_paid` DECIMAL(14, 2) NULL;

ALTER TABLE `sales`
  MODIFY `total_amount` DECIMAL(14, 2) NOT NULL,
  MODIFY `store_commission_total` DECIMAL(14, 2) NOT NULL,
  MODIFY `vendor_payable_total` DECIMAL(14, 2) NOT NULL;

ALTER TABLE `sale_items`
  MODIFY `unit_price` DECIMAL(14, 2) NOT NULL,
  MODIFY `line_total` DECIMAL(14, 2) NOT NULL,
  MODIFY `store_amount` DECIMAL(14, 2) NOT NULL,
  MODIFY `vendor_amount` DECIMAL(14, 2) NOT NULL;

ALTER TABLE `sale_return_items`
  MODIFY `store_amount` DECIMAL(14, 2) NOT NULL,
  MODIFY `vendor_amount` DECIMAL(14, 2) NOT NULL;

ALTER TABLE `vendor_settlements`
  MODIFY `gross_amount` DECIMAL(14, 2) NOT NULL,
  MODIFY `deductions_amount` DECIMAL(14, 2) NOT NULL DEFAULT 0,
  MODIFY `net_amount` DECIMAL(14, 2) NOT NULL;

ALTER TABLE `vendor_settlement_items`
  MODIFY `amount` DECIMAL(14, 2) NOT NULL;

ALTER TABLE `vendor_ledger_entries`
  MODIFY `amount` DECIMAL(14, 2) NOT NULL;

-- 4) composite FKs for voided_by / ledger created_by (RESTRICT — SET NULL would null tenant_id)
ALTER TABLE `sales` DROP FOREIGN KEY `sales_voided_by_fkey`;
ALTER TABLE `sales`
  ADD CONSTRAINT `sales_voided_by_tenant_id_fkey`
  FOREIGN KEY (`voided_by`, `tenant_id`) REFERENCES `users` (`id`, `tenant_scope`)
  ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE `vendor_ledger_entries` DROP FOREIGN KEY `vendor_ledger_entries_created_by_fkey`;
ALTER TABLE `vendor_ledger_entries`
  ADD CONSTRAINT `vendor_ledger_entries_created_by_tenant_id_fkey`
  FOREIGN KEY (`created_by`, `tenant_id`) REFERENCES `users` (`id`, `tenant_scope`)
  ON DELETE RESTRICT ON UPDATE RESTRICT;

-- 5) vendor_balances view — INVOKER (not DEFINER=root)
CREATE OR REPLACE SQL SECURITY INVOKER VIEW `vendor_balances` AS
SELECT
  `tenant_id`,
  `vendor_id`,
  COALESCE(SUM(`amount`), 0) AS `balance`
FROM `vendor_ledger_entries`
GROUP BY `tenant_id`, `vendor_id`;

-- 7) small CHECKs
ALTER TABLE `subscriptions`
  ADD CONSTRAINT `chk_sub_dates` CHECK (
    `ends_at` > `starts_at`
    AND (`amount_paid` IS NULL OR `amount_paid` >= 0)
  );

ALTER TABLE `tenant_sequences`
  ADD CONSTRAINT `chk_seq` CHECK (`next_value` >= 1);

-- 8) soft-delete unique columns room for #id suffix
ALTER TABLE `categories` MODIFY `slug_unique` VARCHAR(255) NOT NULL;
ALTER TABLE `products` MODIFY `name_unique` VARCHAR(255) NOT NULL;
ALTER TABLE `units` MODIFY `slug_unique` VARCHAR(255) NOT NULL;

-- 9) CASCADE → RESTRICT on financial child tables (void/cancel in app; never hard-delete)
ALTER TABLE `sale_items` DROP FOREIGN KEY `sale_items_sale_id_tenant_id_fkey`;
ALTER TABLE `sale_items`
  ADD CONSTRAINT `sale_items_sale_id_tenant_id_fkey`
  FOREIGN KEY (`sale_id`, `tenant_id`) REFERENCES `sales` (`id`, `tenant_id`)
  ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `sale_item_allocations` DROP FOREIGN KEY `sale_item_allocations_sale_item_id_tenant_id_fkey`;
ALTER TABLE `sale_item_allocations`
  ADD CONSTRAINT `sale_item_allocations_sale_item_id_tenant_id_fkey`
  FOREIGN KEY (`sale_item_id`, `tenant_id`) REFERENCES `sale_items` (`id`, `tenant_id`)
  ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `product_intake_items` DROP FOREIGN KEY `product_intake_items_product_intake_id_tenant_id_fkey`;
ALTER TABLE `product_intake_items`
  ADD CONSTRAINT `product_intake_items_product_intake_id_tenant_id_fkey`
  FOREIGN KEY (`product_intake_id`, `tenant_id`) REFERENCES `product_intakes` (`id`, `tenant_id`)
  ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `sale_return_items` DROP FOREIGN KEY `sale_return_items_sale_return_id_tenant_id_fkey`;
ALTER TABLE `sale_return_items`
  ADD CONSTRAINT `sale_return_items_sale_return_id_tenant_id_fkey`
  FOREIGN KEY (`sale_return_id`, `tenant_id`) REFERENCES `sale_returns` (`id`, `tenant_id`)
  ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `sale_return_allocations` DROP FOREIGN KEY `sale_return_allocations_sale_return_item_id_tenant_id_fkey`;
ALTER TABLE `sale_return_allocations`
  ADD CONSTRAINT `sale_return_allocations_sale_return_item_id_tenant_id_fkey`
  FOREIGN KEY (`sale_return_item_id`, `tenant_id`) REFERENCES `sale_return_items` (`id`, `tenant_id`)
  ON DELETE RESTRICT ON UPDATE CASCADE;

-- 10) drop redundant indexes only when another index covers the FK left-prefix
-- products_tenant_id_idx covered by UNIQUE (tenant_id, name_unique)
DROP INDEX `products_tenant_id_idx` ON `products`;
-- KEEP sale_item_allocations_tenant_id_idx — required by FK sale_item_allocations_tenant_id_fkey
-- KEEP sale_item_allocations_sale_item_id_tenant_id_idx — covers FK (sale_item_id, tenant_id)
-- KEEP vendor_settlement_items_sale_item_id_tenant_id_fkey — covers FK (sale_item_id, tenant_id)
