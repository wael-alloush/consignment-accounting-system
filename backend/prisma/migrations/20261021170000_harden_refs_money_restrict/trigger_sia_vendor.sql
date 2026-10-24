-- Applied via mysql client (Prisma migrate cannot parse DELIMITER / BEGIN-END blocks).
DROP TRIGGER IF EXISTS `sia_bi_vendor_check`;
DROP TRIGGER IF EXISTS `sia_bu_vendor_check`;

DELIMITER $$

CREATE TRIGGER `sia_bi_vendor_check` BEFORE INSERT ON `sale_item_allocations`
FOR EACH ROW
BEGIN
  IF (
    SELECT `vendor_id` FROM `sale_items`
    WHERE `id` = NEW.`sale_item_id` AND `tenant_id` = NEW.`tenant_id`
  ) <> (
    SELECT `pi`.`vendor_id`
    FROM `product_intake_items` `pii`
    JOIN `product_intakes` `pi`
      ON `pi`.`id` = `pii`.`product_intake_id` AND `pi`.`tenant_id` = `pii`.`tenant_id`
    WHERE `pii`.`id` = NEW.`product_intake_item_id` AND `pii`.`tenant_id` = NEW.`tenant_id`
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'vendor mismatch in allocation';
  END IF;
END$$

CREATE TRIGGER `sia_bu_vendor_check` BEFORE UPDATE ON `sale_item_allocations`
FOR EACH ROW
BEGIN
  IF (
    SELECT `vendor_id` FROM `sale_items`
    WHERE `id` = NEW.`sale_item_id` AND `tenant_id` = NEW.`tenant_id`
  ) <> (
    SELECT `pi`.`vendor_id`
    FROM `product_intake_items` `pii`
    JOIN `product_intakes` `pi`
      ON `pi`.`id` = `pii`.`product_intake_id` AND `pi`.`tenant_id` = `pii`.`tenant_id`
    WHERE `pii`.`id` = NEW.`product_intake_item_id` AND `pii`.`tenant_id` = NEW.`tenant_id`
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'vendor mismatch in allocation';
  END IF;
END$$

DELIMITER ;
