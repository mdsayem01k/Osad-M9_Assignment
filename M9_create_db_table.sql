CREATE DATABASE NorthwindDB
GO

USE NorthwindDB
GO

-- Region Table
CREATE TABLE Region (
    RegionID INT PRIMARY KEY,
    RegionDescription NVARCHAR(50)
)

-- Territories Table
CREATE TABLE Territories (
    TerritoryID INT PRIMARY KEY,
    TerritoryDescription NVARCHAR(50),
    RegionID INT FOREIGN KEY REFERENCES Region(RegionID)
)

-- Employees Table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50)
)

-- EmployeeTerritories Table
CREATE TABLE EmployeeTerritories (
    EmployeeID INT,
    TerritoryID INT,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (TerritoryID) REFERENCES Territories(TerritoryID)
)

-- Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CompanyName NVARCHAR(100)
)

-- Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    EmployeeID INT FOREIGN KEY REFERENCES Employees(EmployeeID),
    OrderDate DATE,
    ShipCity NVARCHAR(100),
    ShipCountry NVARCHAR(100)
)

-- Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    UnitPrice DECIMAL(10,2)
)

-- Order Details Table
CREATE TABLE [Order Details] (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
)
