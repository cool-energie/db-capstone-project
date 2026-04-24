CREATE PROCEDURE GetMaxQuantity()
SELECT MAX(Quantity) AS "MAX Quantity in Order" FROM orders;