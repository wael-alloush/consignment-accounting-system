DROP TRIGGER IF EXISTS `users_bi_tenant_scope`;
DROP TRIGGER IF EXISTS `users_bu_tenant_scope`;
DELIMITER $$
CREATE TRIGGER `users_bi_tenant_scope` BEFORE INSERT ON `users`
FOR EACH ROW BEGIN
  SET NEW.`tenant_scope` = IFNULL(NEW.`tenant_id`, 0);
END$$
CREATE TRIGGER `users_bu_tenant_scope` BEFORE UPDATE ON `users`
FOR EACH ROW BEGIN
  SET NEW.`tenant_scope` = IFNULL(NEW.`tenant_id`, 0);
END$$
DELIMITER ;
