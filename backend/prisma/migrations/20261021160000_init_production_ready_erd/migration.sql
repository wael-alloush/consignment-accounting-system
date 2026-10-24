-- CreateTable
CREATE TABLE `tenants` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `store_name` VARCHAR(191) NOT NULL,
    `owner_name` VARCHAR(191) NOT NULL,
    `owner_phone` VARCHAR(191) NOT NULL,
    `status` ENUM('trial', 'active', 'suspended', 'expired') NOT NULL DEFAULT 'trial',
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `plans` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `price` DECIMAL(10, 2) NOT NULL,
    `currency` VARCHAR(3) NOT NULL DEFAULT 'SYP',
    `billing_period` ENUM('weekly', 'monthly', 'yearly') NOT NULL,
    `features` JSON NULL,
    `is_active` BOOLEAN NOT NULL DEFAULT true,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `subscriptions` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `tenant_id` INTEGER NOT NULL,
    `plan_id` INTEGER NOT NULL,
    `starts_at` DATETIME(3) NOT NULL,
    `ends_at` DATETIME(3) NOT NULL,
    `payment_status` ENUM('paid', 'pending', 'failed') NOT NULL DEFAULT 'pending',
    `price_snapshot` DECIMAL(10, 2) NOT NULL,
    `billing_period_snapshot` ENUM('weekly', 'monthly', 'yearly') NOT NULL,
    `amount_paid` DECIMAL(10, 2) NULL,
    `payment_method` VARCHAR(191) NULL,
    `transaction_ref` VARCHAR(191) NULL,
    `canceled_at` DATETIME(3) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `subscriptions_transaction_ref_key`(`transaction_ref`),
    INDEX `subscriptions_tenant_id_starts_at_ends_at_idx`(`tenant_id`, `starts_at`, `ends_at`),
    INDEX `subscriptions_plan_id_idx`(`plan_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `users` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `tenant_id` INTEGER NULL,
    `tenant_scope` INTEGER GENERATED ALWAYS AS (IFNULL(`tenant_id`, 0)) STORED,
    `name` VARCHAR(191) NOT NULL,
    `email` VARCHAR(191) NOT NULL,
    `password` VARCHAR(191) NOT NULL,
    `phone` VARCHAR(191) NOT NULL,
    `role` ENUM('super_admin', 'store_admin', 'cashier', 'vendor') NOT NULL,
    `status` ENUM('active', 'inactive') NOT NULL DEFAULT 'active',
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `users_email_key`(`email`),
    INDEX `users_tenant_id_idx`(`tenant_id`),
    UNIQUE INDEX `users_id_tenant_scope_key`(`id`, `tenant_scope`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `vendor_profiles` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `user_id` INTEGER NULL,
    `tenant_id` INTEGER NOT NULL,
    `farm_name` VARCHAR(191) NULL,
    `bank_name` VARCHAR(191) NULL,
    `bank_account_number` VARCHAR(191) NULL,
    `deleted_at` DATETIME(3) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `vendor_profiles_tenant_id_idx`(`tenant_id`),
    UNIQUE INDEX `vendor_profiles_id_tenant_id_key`(`id`, `tenant_id`),
    UNIQUE INDEX `vendor_profiles_user_id_key`(`user_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `categories` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `tenant_id` INTEGER NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `slug` VARCHAR(191) NOT NULL,
    `deleted_at` DATETIME(3) NULL,
    -- Maintained by triggers (MariaDB forbids AUTO_INCREMENT `id` in GENERATED columns)
    `slug_unique` VARCHAR(191) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `categories_id_tenant_id_key`(`id`, `tenant_id`),
    UNIQUE INDEX `categories_tenant_id_slug_unique_key`(`tenant_id`, `slug_unique`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `products` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `tenant_id` INTEGER NOT NULL,
    `category_id` INTEGER NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `commission_type` ENUM('percentage', 'fixed') NOT NULL,
    `commission_value` DECIMAL(10, 2) NOT NULL,
    `commission_basis` ENUM('per_unit', 'per_line') NOT NULL DEFAULT 'per_unit',
    `deleted_at` DATETIME(3) NULL,
    -- Maintained by triggers (MariaDB forbids AUTO_INCREMENT `id` in GENERATED columns)
    `name_unique` VARCHAR(191) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `products_tenant_id_idx`(`tenant_id`),
    INDEX `products_category_id_tenant_id_idx`(`category_id`, `tenant_id`),
    UNIQUE INDEX `products_id_tenant_id_key`(`id`, `tenant_id`),
    UNIQUE INDEX `products_tenant_id_name_unique_key`(`tenant_id`, `name_unique`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `units` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `tenant_id` INTEGER NOT NULL,
    `name_ar` VARCHAR(191) NOT NULL,
    `name_en` VARCHAR(191) NOT NULL,
    `slug` VARCHAR(191) NOT NULL,
    `is_system` BOOLEAN NOT NULL DEFAULT false,
    `deleted_at` DATETIME(3) NULL,
    -- Maintained by triggers (MariaDB forbids AUTO_INCREMENT `id` in GENERATED columns)
    `slug_unique` VARCHAR(191) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `units_id_tenant_id_key`(`id`, `tenant_id`),
    UNIQUE INDEX `units_tenant_id_slug_unique_key`(`tenant_id`, `slug_unique`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `product_intakes` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `tenant_id` INTEGER NOT NULL,
    `vendor_id` INTEGER NOT NULL,
    `received_by` INTEGER NOT NULL,
    `intake_date` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `status` ENUM('active', 'completed', 'archived') NOT NULL DEFAULT 'active',
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `product_intakes_tenant_id_idx`(`tenant_id`),
    INDEX `product_intakes_vendor_id_tenant_id_idx`(`vendor_id`, `tenant_id`),
    INDEX `product_intakes_received_by_tenant_id_idx`(`received_by`, `tenant_id`),
    UNIQUE INDEX `product_intakes_id_tenant_id_key`(`id`, `tenant_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `product_intake_items` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `tenant_id` INTEGER NOT NULL,
    `product_intake_id` INTEGER NOT NULL,
    `product_id` INTEGER NOT NULL,
    `unit_id` INTEGER NOT NULL,
    `quantity_received` DECIMAL(12, 3) NOT NULL,
    `quantity_remaining` DECIMAL(12, 3) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `idx_intake_items_fifo`(`tenant_id`, `product_id`, `quantity_remaining`, `created_at`),
    INDEX `product_intake_items_product_intake_id_tenant_id_idx`(`product_intake_id`, `tenant_id`),
    INDEX `product_intake_items_unit_id_tenant_id_idx`(`unit_id`, `tenant_id`),
    UNIQUE INDEX `product_intake_items_id_tenant_id_key`(`id`, `tenant_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sales` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `tenant_id` INTEGER NOT NULL,
    `cashier_id` INTEGER NOT NULL,
    `invoice_number` VARCHAR(191) NOT NULL,
    `sold_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `total_amount` DECIMAL(10, 2) NOT NULL,
    `store_commission_total` DECIMAL(10, 2) NOT NULL,
    `vendor_payable_total` DECIMAL(10, 2) NOT NULL,
    `status` ENUM('completed', 'voided') NOT NULL DEFAULT 'completed',
    `voided_at` DATETIME(3) NULL,
    `voided_by` INTEGER NULL,
    `void_reason` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `idx_sales_tenant_sold`(`tenant_id`, `status`, `sold_at`),
    INDEX `sales_cashier_id_tenant_id_idx`(`cashier_id`, `tenant_id`),
    UNIQUE INDEX `sales_id_tenant_id_key`(`id`, `tenant_id`),
    UNIQUE INDEX `sales_tenant_id_invoice_number_key`(`tenant_id`, `invoice_number`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sale_items` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `tenant_id` INTEGER NOT NULL,
    `sale_id` INTEGER NOT NULL,
    `product_id` INTEGER NOT NULL,
    `vendor_id` INTEGER NOT NULL,
    `unit_id` INTEGER NOT NULL,
    `quantity` DECIMAL(12, 3) NOT NULL,
    `unit_price` DECIMAL(10, 2) NOT NULL,
    `commission_type` ENUM('percentage', 'fixed') NOT NULL,
    `commission_value` DECIMAL(10, 2) NOT NULL,
    `commission_basis` ENUM('per_unit', 'per_line') NOT NULL DEFAULT 'per_unit',
    `line_total` DECIMAL(10, 2) NOT NULL,
    `store_amount` DECIMAL(10, 2) NOT NULL,
    `vendor_amount` DECIMAL(10, 2) NOT NULL,
    `settlement_status` ENUM('unsettled', 'settled') NOT NULL DEFAULT 'unsettled',
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `idx_si_vendor_settle`(`tenant_id`, `vendor_id`, `settlement_status`),
    INDEX `sale_items_sale_id_tenant_id_idx`(`sale_id`, `tenant_id`),
    INDEX `sale_items_product_id_tenant_id_idx`(`product_id`, `tenant_id`),
    UNIQUE INDEX `sale_items_id_tenant_id_key`(`id`, `tenant_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sale_item_allocations` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `tenant_id` INTEGER NOT NULL,
    `sale_item_id` INTEGER NOT NULL,
    `product_intake_item_id` INTEGER NOT NULL,
    `quantity` DECIMAL(12, 3) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `sale_item_allocations_tenant_id_idx`(`tenant_id`),
    INDEX `sale_item_allocations_sale_item_id_tenant_id_idx`(`sale_item_id`, `tenant_id`),
    INDEX `sale_item_allocations_product_intake_item_id_tenant_id_idx`(`product_intake_item_id`, `tenant_id`),
    UNIQUE INDEX `sale_item_allocations_id_tenant_id_key`(`id`, `tenant_id`),
    UNIQUE INDEX `sale_item_allocations_sale_item_id_product_intake_item_id_key`(`sale_item_id`, `product_intake_item_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `vendor_settlements` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `tenant_id` INTEGER NOT NULL,
    `vendor_id` INTEGER NOT NULL,
    `created_by` INTEGER NOT NULL,
    `period_start` DATETIME(3) NULL,
    `period_end` DATETIME(3) NULL,
    `gross_amount` DECIMAL(10, 2) NOT NULL,
    `deductions_amount` DECIMAL(10, 2) NOT NULL DEFAULT 0,
    `net_amount` DECIMAL(10, 2) NOT NULL,
    `status` ENUM('draft', 'paid', 'cancelled') NOT NULL DEFAULT 'draft',
    `paid_at` DATETIME(3) NULL,
    `notes` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `idx_settle_vendor_status`(`tenant_id`, `vendor_id`, `status`),
    INDEX `vendor_settlements_created_by_tenant_id_idx`(`created_by`, `tenant_id`),
    UNIQUE INDEX `vendor_settlements_id_tenant_id_key`(`id`, `tenant_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `vendor_settlement_items` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `tenant_id` INTEGER NOT NULL,
    `settlement_id` INTEGER NOT NULL,
    `sale_item_id` INTEGER NOT NULL,
    `amount` DECIMAL(10, 2) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `vendor_settlement_items_sale_item_id_key`(`sale_item_id`),
    INDEX `vendor_settlement_items_tenant_id_idx`(`tenant_id`),
    INDEX `vendor_settlement_items_settlement_id_tenant_id_idx`(`settlement_id`, `tenant_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `stock_adjustments` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `tenant_id` INTEGER NOT NULL,
    `product_intake_item_id` INTEGER NOT NULL,
    `quantity` DECIMAL(12, 3) NOT NULL,
    `reason` ENUM('damaged', 'returned_to_vendor', 'expired', 'correction') NOT NULL,
    `notes` VARCHAR(191) NULL,
    `created_by` INTEGER NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `stock_adjustments_tenant_id_idx`(`tenant_id`),
    INDEX `stock_adjustments_product_intake_item_id_tenant_id_idx`(`product_intake_item_id`, `tenant_id`),
    INDEX `stock_adjustments_created_by_tenant_id_idx`(`created_by`, `tenant_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `vendor_ledger_entries` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `tenant_id` INTEGER NOT NULL,
    `vendor_id` INTEGER NOT NULL,
    `entry_type` ENUM('sale_credit', 'settlement_debit', 'advance', 'discount', 'damage', 'return_reversal', 'shipping', 'adjustment') NOT NULL,
    `amount` DECIMAL(10, 2) NOT NULL,
    `ref_type` VARCHAR(191) NOT NULL DEFAULT '',
    `ref_id` INTEGER NOT NULL DEFAULT 0,
    `notes` VARCHAR(191) NULL,
    `created_by` INTEGER NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `vendor_ledger_entries_tenant_id_vendor_id_created_at_idx`(`tenant_id`, `vendor_id`, `created_at`),
    UNIQUE INDEX `vendor_ledger_entries_tenant_id_entry_type_ref_type_ref_id_key`(`tenant_id`, `entry_type`, `ref_type`, `ref_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sale_returns` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `tenant_id` INTEGER NOT NULL,
    `sale_id` INTEGER NOT NULL,
    `created_by` INTEGER NOT NULL,
    `reason` VARCHAR(191) NULL,
    `returned_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `sale_returns_tenant_id_sale_id_idx`(`tenant_id`, `sale_id`),
    INDEX `sale_returns_created_by_tenant_id_idx`(`created_by`, `tenant_id`),
    UNIQUE INDEX `sale_returns_id_tenant_id_key`(`id`, `tenant_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sale_return_items` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `tenant_id` INTEGER NOT NULL,
    `sale_return_id` INTEGER NOT NULL,
    `sale_item_id` INTEGER NOT NULL,
    `quantity` DECIMAL(12, 3) NOT NULL,
    `store_amount` DECIMAL(10, 2) NOT NULL,
    `vendor_amount` DECIMAL(10, 2) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `sale_return_items_tenant_id_idx`(`tenant_id`),
    INDEX `sale_return_items_sale_return_id_tenant_id_idx`(`sale_return_id`, `tenant_id`),
    INDEX `sale_return_items_sale_item_id_tenant_id_idx`(`sale_item_id`, `tenant_id`),
    UNIQUE INDEX `sale_return_items_id_tenant_id_key`(`id`, `tenant_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sale_return_allocations` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `tenant_id` INTEGER NOT NULL,
    `sale_return_item_id` INTEGER NOT NULL,
    `sale_item_allocation_id` INTEGER NOT NULL,
    `product_intake_item_id` INTEGER NOT NULL,
    `quantity` DECIMAL(12, 3) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `sale_return_allocations_tenant_id_idx`(`tenant_id`),
    INDEX `sale_return_allocations_product_intake_item_id_tenant_id_idx`(`product_intake_item_id`, `tenant_id`),
    UNIQUE INDEX `sale_return_allocations_sale_return_item_id_sale_item_alloca_key`(`sale_return_item_id`, `sale_item_allocation_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tenant_sequences` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `tenant_id` INTEGER NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `next_value` INTEGER NOT NULL DEFAULT 1,

    UNIQUE INDEX `tenant_sequences_tenant_id_name_key`(`tenant_id`, `name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `audit_logs` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `tenant_id` INTEGER NULL,
    `user_id` INTEGER NULL,
    `entity` VARCHAR(191) NOT NULL,
    `entity_id` INTEGER NOT NULL,
    `action` ENUM('create', 'update', 'delete', 'void', 'settle', 'cancel') NOT NULL,
    `old_data` JSON NULL,
    `new_data` JSON NULL,
    `ip_address` VARCHAR(191) NULL,
    `request_id` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `audit_logs_tenant_id_entity_entity_id_idx`(`tenant_id`, `entity`, `entity_id`),
    INDEX `audit_logs_user_id_idx`(`user_id`),
    INDEX `audit_logs_created_at_idx`(`created_at`),
    INDEX `audit_logs_request_id_idx`(`request_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `subscriptions` ADD CONSTRAINT `subscriptions_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `subscriptions` ADD CONSTRAINT `subscriptions_plan_id_fkey` FOREIGN KEY (`plan_id`) REFERENCES `plans`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
-- ON UPDATE RESTRICT: tenant_id feeds generated tenant_scope (CASCADE not allowed on generated base cols)
ALTER TABLE `users` ADD CONSTRAINT `users_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `vendor_profiles` ADD CONSTRAINT `vendor_profiles_user_id_tenant_id_fkey` FOREIGN KEY (`user_id`, `tenant_id`) REFERENCES `users`(`id`, `tenant_scope`) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `vendor_profiles` ADD CONSTRAINT `vendor_profiles_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `categories` ADD CONSTRAINT `categories_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `products` ADD CONSTRAINT `products_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `products` ADD CONSTRAINT `products_category_id_tenant_id_fkey` FOREIGN KEY (`category_id`, `tenant_id`) REFERENCES `categories`(`id`, `tenant_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `units` ADD CONSTRAINT `units_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `product_intakes` ADD CONSTRAINT `product_intakes_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `product_intakes` ADD CONSTRAINT `product_intakes_vendor_id_tenant_id_fkey` FOREIGN KEY (`vendor_id`, `tenant_id`) REFERENCES `vendor_profiles`(`id`, `tenant_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `product_intakes` ADD CONSTRAINT `product_intakes_received_by_tenant_id_fkey` FOREIGN KEY (`received_by`, `tenant_id`) REFERENCES `users`(`id`, `tenant_scope`) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `product_intake_items` ADD CONSTRAINT `product_intake_items_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `product_intake_items` ADD CONSTRAINT `product_intake_items_product_intake_id_tenant_id_fkey` FOREIGN KEY (`product_intake_id`, `tenant_id`) REFERENCES `product_intakes`(`id`, `tenant_id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `product_intake_items` ADD CONSTRAINT `product_intake_items_product_id_tenant_id_fkey` FOREIGN KEY (`product_id`, `tenant_id`) REFERENCES `products`(`id`, `tenant_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `product_intake_items` ADD CONSTRAINT `product_intake_items_unit_id_tenant_id_fkey` FOREIGN KEY (`unit_id`, `tenant_id`) REFERENCES `units`(`id`, `tenant_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `sales` ADD CONSTRAINT `sales_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `sales` ADD CONSTRAINT `sales_cashier_id_tenant_id_fkey` FOREIGN KEY (`cashier_id`, `tenant_id`) REFERENCES `users`(`id`, `tenant_scope`) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `sales` ADD CONSTRAINT `sales_voided_by_fkey` FOREIGN KEY (`voided_by`) REFERENCES `users`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `sale_items` ADD CONSTRAINT `sale_items_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `sale_items` ADD CONSTRAINT `sale_items_sale_id_tenant_id_fkey` FOREIGN KEY (`sale_id`, `tenant_id`) REFERENCES `sales`(`id`, `tenant_id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `sale_items` ADD CONSTRAINT `sale_items_product_id_tenant_id_fkey` FOREIGN KEY (`product_id`, `tenant_id`) REFERENCES `products`(`id`, `tenant_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `sale_items` ADD CONSTRAINT `sale_items_vendor_id_tenant_id_fkey` FOREIGN KEY (`vendor_id`, `tenant_id`) REFERENCES `vendor_profiles`(`id`, `tenant_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `sale_items` ADD CONSTRAINT `sale_items_unit_id_tenant_id_fkey` FOREIGN KEY (`unit_id`, `tenant_id`) REFERENCES `units`(`id`, `tenant_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `sale_item_allocations` ADD CONSTRAINT `sale_item_allocations_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `sale_item_allocations` ADD CONSTRAINT `sale_item_allocations_sale_item_id_tenant_id_fkey` FOREIGN KEY (`sale_item_id`, `tenant_id`) REFERENCES `sale_items`(`id`, `tenant_id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `sale_item_allocations` ADD CONSTRAINT `sale_item_allocations_product_intake_item_id_tenant_id_fkey` FOREIGN KEY (`product_intake_item_id`, `tenant_id`) REFERENCES `product_intake_items`(`id`, `tenant_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `vendor_settlements` ADD CONSTRAINT `vendor_settlements_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `vendor_settlements` ADD CONSTRAINT `vendor_settlements_vendor_id_tenant_id_fkey` FOREIGN KEY (`vendor_id`, `tenant_id`) REFERENCES `vendor_profiles`(`id`, `tenant_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `vendor_settlements` ADD CONSTRAINT `vendor_settlements_created_by_tenant_id_fkey` FOREIGN KEY (`created_by`, `tenant_id`) REFERENCES `users`(`id`, `tenant_scope`) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `vendor_settlement_items` ADD CONSTRAINT `vendor_settlement_items_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `vendor_settlement_items` ADD CONSTRAINT `vendor_settlement_items_settlement_id_tenant_id_fkey` FOREIGN KEY (`settlement_id`, `tenant_id`) REFERENCES `vendor_settlements`(`id`, `tenant_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `vendor_settlement_items` ADD CONSTRAINT `vendor_settlement_items_sale_item_id_tenant_id_fkey` FOREIGN KEY (`sale_item_id`, `tenant_id`) REFERENCES `sale_items`(`id`, `tenant_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `stock_adjustments` ADD CONSTRAINT `stock_adjustments_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `stock_adjustments` ADD CONSTRAINT `stock_adjustments_product_intake_item_id_tenant_id_fkey` FOREIGN KEY (`product_intake_item_id`, `tenant_id`) REFERENCES `product_intake_items`(`id`, `tenant_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `stock_adjustments` ADD CONSTRAINT `stock_adjustments_created_by_tenant_id_fkey` FOREIGN KEY (`created_by`, `tenant_id`) REFERENCES `users`(`id`, `tenant_scope`) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `vendor_ledger_entries` ADD CONSTRAINT `vendor_ledger_entries_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `vendor_ledger_entries` ADD CONSTRAINT `vendor_ledger_entries_vendor_id_tenant_id_fkey` FOREIGN KEY (`vendor_id`, `tenant_id`) REFERENCES `vendor_profiles`(`id`, `tenant_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `vendor_ledger_entries` ADD CONSTRAINT `vendor_ledger_entries_created_by_fkey` FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `sale_returns` ADD CONSTRAINT `sale_returns_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `sale_returns` ADD CONSTRAINT `sale_returns_sale_id_tenant_id_fkey` FOREIGN KEY (`sale_id`, `tenant_id`) REFERENCES `sales`(`id`, `tenant_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `sale_returns` ADD CONSTRAINT `sale_returns_created_by_tenant_id_fkey` FOREIGN KEY (`created_by`, `tenant_id`) REFERENCES `users`(`id`, `tenant_scope`) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `sale_return_items` ADD CONSTRAINT `sale_return_items_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `sale_return_items` ADD CONSTRAINT `sale_return_items_sale_return_id_tenant_id_fkey` FOREIGN KEY (`sale_return_id`, `tenant_id`) REFERENCES `sale_returns`(`id`, `tenant_id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `sale_return_items` ADD CONSTRAINT `sale_return_items_sale_item_id_tenant_id_fkey` FOREIGN KEY (`sale_item_id`, `tenant_id`) REFERENCES `sale_items`(`id`, `tenant_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `sale_return_allocations` ADD CONSTRAINT `sale_return_allocations_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `sale_return_allocations` ADD CONSTRAINT `sale_return_allocations_sale_return_item_id_tenant_id_fkey` FOREIGN KEY (`sale_return_item_id`, `tenant_id`) REFERENCES `sale_return_items`(`id`, `tenant_id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `sale_return_allocations` ADD CONSTRAINT `sale_return_allocations_sale_item_allocation_id_tenant_id_fkey` FOREIGN KEY (`sale_item_allocation_id`, `tenant_id`) REFERENCES `sale_item_allocations`(`id`, `tenant_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `sale_return_allocations` ADD CONSTRAINT `sale_return_allocations_product_intake_item_id_tenant_id_fkey` FOREIGN KEY (`product_intake_item_id`, `tenant_id`) REFERENCES `product_intake_items`(`id`, `tenant_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tenant_sequences` ADD CONSTRAINT `tenant_sequences_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `audit_logs` ADD CONSTRAINT `audit_logs_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `audit_logs` ADD CONSTRAINT `audit_logs_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- CHECK constraints
ALTER TABLE `product_intake_items`
  ADD CONSTRAINT `chk_intake_qty` CHECK (
    `quantity_received` > 0
    AND `quantity_remaining` >= 0
    AND `quantity_remaining` <= `quantity_received`
  );

ALTER TABLE `sale_items`
  ADD CONSTRAINT `chk_sale_item_money` CHECK (
    `quantity` > 0
    AND `unit_price` >= 0
    AND `store_amount` >= 0
    AND `vendor_amount` >= 0
    AND `store_amount` + `vendor_amount` = `line_total`
  );

ALTER TABLE `products`
  ADD CONSTRAINT `chk_product_commission` CHECK (
    `commission_value` >= 0
    AND (`commission_type` <> 'percentage' OR `commission_value` <= 100)
  );

ALTER TABLE `sale_item_allocations`
  ADD CONSTRAINT `chk_alloc_qty` CHECK (`quantity` > 0);

ALTER TABLE `sale_return_allocations`
  ADD CONSTRAINT `chk_return_alloc_qty` CHECK (`quantity` > 0);

ALTER TABLE `stock_adjustments`
  ADD CONSTRAINT `chk_stock_adj_qty` CHECK (`quantity` <> 0);

ALTER TABLE `vendor_settlement_items`
  ADD CONSTRAINT `chk_settle_item_amount` CHECK (`amount` > 0);

ALTER TABLE `sale_return_items`
  ADD CONSTRAINT `chk_return_item_qty` CHECK (
    `quantity` > 0
    AND `store_amount` >= 0
    AND `vendor_amount` >= 0
  );

ALTER TABLE `vendor_settlements`
  ADD CONSTRAINT `chk_settle_net` CHECK (
    `gross_amount` >= 0
    AND `deductions_amount` >= 0
    AND `net_amount` = `gross_amount` - `deductions_amount`
  );

ALTER TABLE `vendor_ledger_entries`
  ADD CONSTRAINT `chk_ledger_sign` CHECK (
    (`entry_type` IN ('sale_credit') AND `amount` > 0)
    OR (`entry_type` IN ('settlement_debit', 'advance', 'discount', 'damage', 'shipping', 'return_reversal') AND `amount` < 0)
    OR (`entry_type` = 'adjustment' AND `amount` <> 0)
  );

-- Vendor balance view (source of truth for outstanding payable)
CREATE OR REPLACE VIEW `vendor_balances` AS
SELECT
  `tenant_id`,
  `vendor_id`,
  COALESCE(SUM(`amount`), 0) AS `balance`
FROM `vendor_ledger_entries`
GROUP BY `tenant_id`, `vendor_id`;

-- Soft-delete uniqueness: rewrite *_unique on soft-delete so slug/name can be reused
-- (single-statement triggers — Prisma migrate cannot use DELIMITER)
CREATE TRIGGER `categories_bi_slug_unique` BEFORE INSERT ON `categories`
FOR EACH ROW SET NEW.`slug_unique` = IF(NEW.`slug_unique` IS NULL OR NEW.`slug_unique` = '', NEW.`slug`, NEW.`slug_unique`);

CREATE TRIGGER `categories_bu_slug_unique` BEFORE UPDATE ON `categories`
FOR EACH ROW SET NEW.`slug_unique` = IF(
  NEW.`deleted_at` IS NOT NULL AND (OLD.`deleted_at` IS NULL OR NEW.`slug_unique` = NEW.`slug`),
  CONCAT(NEW.`slug`, '#', NEW.`id`),
  IF(NEW.`deleted_at` IS NULL, NEW.`slug`, NEW.`slug_unique`)
);

CREATE TRIGGER `products_bi_name_unique` BEFORE INSERT ON `products`
FOR EACH ROW SET NEW.`name_unique` = IF(NEW.`name_unique` IS NULL OR NEW.`name_unique` = '', NEW.`name`, NEW.`name_unique`);

CREATE TRIGGER `products_bu_name_unique` BEFORE UPDATE ON `products`
FOR EACH ROW SET NEW.`name_unique` = IF(
  NEW.`deleted_at` IS NOT NULL AND (OLD.`deleted_at` IS NULL OR NEW.`name_unique` = NEW.`name`),
  CONCAT(NEW.`name`, '#', NEW.`id`),
  IF(NEW.`deleted_at` IS NULL, NEW.`name`, NEW.`name_unique`)
);

CREATE TRIGGER `units_bi_slug_unique` BEFORE INSERT ON `units`
FOR EACH ROW SET NEW.`slug_unique` = IF(NEW.`slug_unique` IS NULL OR NEW.`slug_unique` = '', NEW.`slug`, NEW.`slug_unique`);

CREATE TRIGGER `units_bu_slug_unique` BEFORE UPDATE ON `units`
FOR EACH ROW SET NEW.`slug_unique` = IF(
  NEW.`deleted_at` IS NOT NULL AND (OLD.`deleted_at` IS NULL OR NEW.`slug_unique` = NEW.`slug`),
  CONCAT(NEW.`slug`, '#', NEW.`id`),
  IF(NEW.`deleted_at` IS NULL, NEW.`slug`, NEW.`slug_unique`)
);
