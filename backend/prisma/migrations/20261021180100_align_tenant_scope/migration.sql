-- Align tenant_scope with Prisma: plain INT maintained by triggers (not GENERATED / not expression DEFAULT).

ALTER TABLE `vendor_profiles` DROP FOREIGN KEY `vendor_profiles_user_id_tenant_id_fkey`;
ALTER TABLE `product_intakes` DROP FOREIGN KEY `product_intakes_received_by_tenant_id_fkey`;
ALTER TABLE `sales` DROP FOREIGN KEY `sales_cashier_id_tenant_id_fkey`;
ALTER TABLE `sales` DROP FOREIGN KEY `sales_voided_by_tenant_id_fkey`;
ALTER TABLE `vendor_settlements` DROP FOREIGN KEY `vendor_settlements_created_by_tenant_id_fkey`;
ALTER TABLE `stock_adjustments` DROP FOREIGN KEY `stock_adjustments_created_by_tenant_id_fkey`;
ALTER TABLE `sale_returns` DROP FOREIGN KEY `sale_returns_created_by_tenant_id_fkey`;
ALTER TABLE `vendor_ledger_entries` DROP FOREIGN KEY `vendor_ledger_entries_created_by_tenant_id_fkey`;

ALTER TABLE `users` MODIFY `tenant_scope` INTEGER NOT NULL;

ALTER TABLE `vendor_profiles` ADD CONSTRAINT `vendor_profiles_user_id_tenant_id_fkey` FOREIGN KEY (`user_id`, `tenant_id`) REFERENCES `users` (`id`, `tenant_scope`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `product_intakes` ADD CONSTRAINT `product_intakes_received_by_tenant_id_fkey` FOREIGN KEY (`received_by`, `tenant_id`) REFERENCES `users` (`id`, `tenant_scope`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `sales` ADD CONSTRAINT `sales_cashier_id_tenant_id_fkey` FOREIGN KEY (`cashier_id`, `tenant_id`) REFERENCES `users` (`id`, `tenant_scope`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `sales` ADD CONSTRAINT `sales_voided_by_tenant_id_fkey` FOREIGN KEY (`voided_by`, `tenant_id`) REFERENCES `users` (`id`, `tenant_scope`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `vendor_settlements` ADD CONSTRAINT `vendor_settlements_created_by_tenant_id_fkey` FOREIGN KEY (`created_by`, `tenant_id`) REFERENCES `users` (`id`, `tenant_scope`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `stock_adjustments` ADD CONSTRAINT `stock_adjustments_created_by_tenant_id_fkey` FOREIGN KEY (`created_by`, `tenant_id`) REFERENCES `users` (`id`, `tenant_scope`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `sale_returns` ADD CONSTRAINT `sale_returns_created_by_tenant_id_fkey` FOREIGN KEY (`created_by`, `tenant_id`) REFERENCES `users` (`id`, `tenant_scope`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `vendor_ledger_entries` ADD CONSTRAINT `vendor_ledger_entries_created_by_tenant_id_fkey` FOREIGN KEY (`created_by`, `tenant_id`) REFERENCES `users` (`id`, `tenant_scope`) ON DELETE RESTRICT ON UPDATE RESTRICT;