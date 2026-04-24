CREATE VIEW CostomersOrdersView AS
SELECT c.CustomerID, CONCAT(c.FirstName, ' ', c.LastName) as FullName,
o.OrderID, o.TotalCost, m.Name as MenuName, mi.CourseName
FROM orders o
INNER JOIN customers c ON c.CustomerID = o.CustomerID
INNER JOIN menus m on m.MenuID = o.MenuID
INNER JOIN menuitems mi on mi.MenuItemID = m.MenuItemID
WHERE o.TotalCost > 150;