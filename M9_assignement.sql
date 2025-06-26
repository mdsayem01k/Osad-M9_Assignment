-- =====================================================================
-- ASSIGNMENT: Simple Query with Subqueries and Views
-- Database: NorthwindDB
-- Author: Md Abu Sayem
-- =====================================================================

-- =====================================================================
-- PART 1: SUBQUERIES
-- =====================================================================

-- 1.1 Regional Order Count
SELECT r.RegionDescription,
       (SELECT COUNT(*) 
        FROM Orders o
        INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
        INNER JOIN EmployeeTerritories et ON e.EmployeeID = et.EmployeeID
        INNER JOIN Territories t ON et.TerritoryID = t.TerritoryID
        WHERE t.RegionID = r.RegionID
       ) AS TotalOrders
FROM Region r;

-- 1.2 Territory-Level Order Count
SELECT r.RegionDescription,
       t.TerritoryDescription,
       (SELECT COUNT(*) 
        FROM Orders o
        INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
        INNER JOIN EmployeeTerritories et ON e.EmployeeID = et.EmployeeID
        WHERE et.TerritoryID = t.TerritoryID
       ) AS OrdersInTerritory
FROM Region r
INNER JOIN Territories t ON r.RegionID = t.RegionID;

-- =====================================================================
-- PART 2: VIEWS
-- =====================================================================

-- 2.1 Create Order Details View (with CREATE OR ALTER)
CREATE OR ALTER VIEW OrderDetailInfo
AS
SELECT 
    o.OrderID,
    c.CompanyName AS CustomerName,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    p.ProductName,
    od.Quantity,
    od.UnitPrice,
    (od.Quantity * od.UnitPrice) AS Total,
    o.OrderDate,
    o.ShipCity,
    o.ShipCountry
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

-- 3.1 Products with price comparison
SELECT ProductName,
       UnitPrice,
       (SELECT AVG(UnitPrice) FROM Products) AS AvgPrice
FROM Products;

-- 3.2 Customers who bought specific product
SELECT CustomerID, CompanyName
FROM Customers
WHERE CustomerID IN (
    SELECT o.CustomerID
    FROM Orders o
    INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
    INNER JOIN Products p ON od.ProductID = p.ProductID
    WHERE p.ProductName = 'Chai'
);

-- 3.3 Regional Sales Summary View (with CREATE OR ALTER)
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

SELECT * from RegionalSales

-- =====================================================================
-- PART 4: ALTERNATIVE METHODS FOR VIEW CREATION
-- =====================================================================


-- Method 1: Using ALTER VIEW (modify existing view)
-- Modify existing view using ALTER VIEW
-- Add Average Order Value
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

SELECT * FROM RegionalSales;