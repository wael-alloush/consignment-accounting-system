-- Applied via mysql client (Prisma migrate cannot parse DELIMITER / BEGIN-END).
DROP TRIGGER IF EXISTS `sra_bi_check`;
DROP TRIGGER IF EXISTS `sra_bu_check`;

DELIMITER $$

CREATE TRIGGER `sra_bi_check` BEFORE INSERT ON `sale_return_allocations`
FOR EACH ROW
BEGIN
  IF NEW.`product_intake_item_id` <> (
    SELECT `product_intake_item_id` FROM `sale_item_allocations`
    WHERE `id` = NEW.`sale_item_allocation_id` AND `tenant_id` = NEW.`tenant_id`
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'return allocation intake mismatch';
  END IF;
END$$

CREATE TRIGGER `sra_bu_check` BEFORE UPDATE ON `sale_return_allocations`
FOR EACH ROW
BEGIN
  IF NEW.`product_intake_item_id` <> (
    SELECT `product_intake_item_id` FROM `sale_item_allocations`
    WHERE `id` = NEW.`sale_item_allocation_id` AND `tenant_id` = NEW.`tenant_id`
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'return allocation intake mismatch';
  END IF;
END$$

DELIMITER ;
