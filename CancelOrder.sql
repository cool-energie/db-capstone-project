DELIMITER //
CREATE PROCEDURE CancelOrder(IN id INT)
BEGIN
DELETE FROM orders WHERE OrderID = id;
SELECT CONCAT("Order ", id, " is cancelled") AS Confirmation;
END //
DELIMITER ;
