-- Ledger unique includes vendor_id; sales CHECKs; settlement paid_at CHECK;
-- commission_value (14,2). Return-allocation trigger applied via mysql (BEGIN/END).

-- 1) Multi-vendor sale_credit on same sale ref
ALTER TABLE `vendor_ledger_entries`
  DROP INDEX `vendor_ledger_entries_tenant_id_entry_type_ref_type_ref_id_key`,
  ADD UNIQUE KEY `vendor_ledger_entries_uniq_ref`
    (`tenant_id`, `vendor_id`, `entry_type`, `ref_type`, `ref_id`);

-- 2) sales totals + void consistency (pre-checked: 0 bad rows)
ALTER TABLE `sales`
  ADD CONSTRAINT `chk_sales_totals` CHECK (
    `total_amount` >= 0
    AND `store_commission_total` >= 0
    AND `vendor_payable_total` >= 0
    AND `store_commission_total` + `vendor_payable_total` = `total_amount`
  ),
  ADD CONSTRAINT `chk_sales_void` CHECK (
    (`status` = 'voided') = (`voided_at` IS NOT NULL)
  );

-- Settlement: paid ↔ paid_at
ALTER TABLE `vendor_settlements`
  ADD CONSTRAINT `chk_settle_paid` CHECK (
    (`status` = 'paid') = (`paid_at` IS NOT NULL)
  );

-- Commission consistency with large SYP amounts
ALTER TABLE `products`
  MODIFY `commission_value` DECIMAL(14, 2) NOT NULL;

ALTER TABLE `sale_items`
  MODIFY `commission_value` DECIMAL(14, 2) NOT NULL;
