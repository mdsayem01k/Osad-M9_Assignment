-- =====================================================================
-- ASSIGNMENT: Simple Query with Subqueries and Views
-- Database: NorthwindDB
-- Author: Md Abu Sayem
-- =====================================================================

-- =====================================================================
-- PART 1: SUBQUERIES + JOIN ALTERNATIVES
-- =====================================================================

-- 1.1 Regional Order Count - Subquery
SELECT r.RegionDescription
       ,(SELECT COUNT(*) 
        FROM Orders o
        INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
        INNER JOIN EmployeeTerritories et ON e.EmployeeID = et.EmployeeID
        INNER JOIN Territories t ON et.TerritoryID = t.TerritoryID
        WHERE t.RegionID = r.RegionID
       ) AS TotalOrders
FROM Region r;

-- 1.1 Regional Order Count - JOIN Version
SELECT r.RegionDescription
	, COUNT(o.OrderID) AS TotalOrders
FROM Region r
LEFT JOIN Territories t ON r.RegionID = t.RegionID
LEFT JOIN EmployeeTerritories et ON t.TerritoryID = et.TerritoryID
LEFT JOIN Employees e ON et.EmployeeID = e.EmployeeID
LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY r.RegionDescription;

-- 1.2 Territory-Level Order Count - Subquery
SELECT r.RegionDescription
       ,t.TerritoryDescription
       ,(SELECT COUNT(*) 
        FROM Orders o
        INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
        INNER JOIN EmployeeTerritories et ON e.EmployeeID = et.EmployeeID
        WHERE et.TerritoryID = t.TerritoryID
       ) AS OrdersInTerritory
FROM Region r
INNER JOIN Territories t ON r.RegionID = t.RegionID
Order by r.RegionDescription, t.TerritoryDescription;

-- 1.2 Territory-Level Order Count - JOIN Version
SELECT r.RegionDescription 
       ,t.TerritoryDescription
       ,COUNT(o.OrderID) AS OrdersInTerritory
FROM Region r
INNER JOIN Territories t ON r.RegionID = t.RegionID
LEFT JOIN EmployeeTerritories et ON t.TerritoryID = et.TerritoryID
LEFT JOIN Employees e ON et.EmployeeID = e.EmployeeID
LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY r.RegionDescription, t.TerritoryDescription
Order by r.RegionDescription, t.TerritoryDescription;


---- mismatch found between above two query
--subquery output----
--Eastern	New York	42	                                          	
--Eastern   New York    42	

---- join output---
--Eastern	New York	84

-- so two query's output result recon is ok




--=============================================================
-- PART 2: VIEWS
-- =====================================================================

-- 2.1 Create Order Details View
CREATE OR ALTER VIEW OrderDetailInfo
AS
SELECT 
    o.OrderID
    ,c.CompanyName AS CustomerName
    ,e.FirstName + ' ' + e.LastName AS EmployeeName
    ,p.ProductName
    ,od.Quantity
    ,od.UnitPrice
    ,(od.Quantity * od.UnitPrice) AS Total
    ,o.OrderDate
    ,o.ShippedDate
    ,o.ShipCity
    ,o.ShipCountry
FROM Orders o
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID;

-- 2.2 Query the View
SELECT * FROM OrderDetailInfo;

-- =====================================================================
-- PART 3: MORE EXAMPLES
-- =====================================================================

-- 3.1 Products with price comparison (Subquery - JOIN not applicable)
SELECT ProductName,
       UnitPrice,
       (SELECT AVG(UnitPrice) FROM Products) AS AvgPrice
FROM Products;

-- 3.2 Customers who bought specific product — Subquery
SELECT CustomerID, CompanyName
FROM Customers
WHERE CustomerID IN (
    SELECT o.CustomerID
    FROM Orders o
    INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
    INNER JOIN Products p ON od.ProductID = p.ProductID
    WHERE p.ProductName = 'Chai'
);

-- 3.2 Customers who bought specific product — JOIN Version
SELECT DISTINCT c.CustomerID, c.CompanyName
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
WHERE p.ProductName = 'Chai';

-- 3.3 Regional Sales Summary View
CREATE OR ALTER VIEW RegionalSales
AS
SELECT 
    r.RegionDescription,
    COUNT(o.OrderID) AS TotalOrders,
    SUM(od.Quantity * od.UnitPrice) AS TotalSales
FROM Region r
INNER JOIN Territories t ON r.RegionID = t.RegionID
INNER JOIN EmployeeTerritories et ON t.TerritoryID = et.TerritoryID
INNER JOIN Employees e ON et.EmployeeID = e.EmployeeID
INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY r.RegionDescription;

-- Query RegionalSales View
SELECT * FROM RegionalSales;

-- =====================================================================
-- PART 4: ALTERNATIVE METHODS FOR VIEW CREATION
-- =====================================================================

-- Modify RegionalSales View to include AvgOrderValue
ALTER VIEW RegionalSales
AS
SELECT 
    r.RegionDescription,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    SUM(od.Quantity * od.UnitPrice) AS TotalSales,
    AVG(od.Quantity * od.UnitPrice) AS AvgOrderValue
FROM Region r
INNER JOIN Territories t ON r.RegionID = t.RegionID
INNER JOIN EmployeeTerritories et ON t.TerritoryID = et.TerritoryID
INNER JOIN Employees e ON et.EmployeeID = e.EmployeeID
INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY r.RegionDescription;

-- Query updated RegionalSales View
SELECT * FROM RegionalSales;
