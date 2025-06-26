-- Regions
INSERT INTO Region VALUES (1, 'North'), (2, 'South')

-- Territories
INSERT INTO Territories VALUES 
(101, 'North Zone 1', 1), 
(102, 'North Zone 2', 1), 
(201, 'South Zone 1', 2)

-- Employees
INSERT INTO Employees VALUES 
(1, 'John', 'Doe'),
(2, 'Alice', 'Smith')

-- EmployeeTerritories
INSERT INTO EmployeeTerritories VALUES 
(1, 101),
(1, 102),
(2, 201)

-- Customers
INSERT INTO Customers VALUES 
(1, 'Alpha Inc'), 
(2, 'Beta Ltd')

-- Products
INSERT INTO Products VALUES 
(1, 'Chai', 10.00),
(2, 'Alice Mutton', 39.00)

-- Orders
INSERT INTO Orders VALUES
(1001, 1, 1, '2023-01-10', 'Dhaka', 'Bangladesh'),
(1002, 2, 2, '2023-02-15', 'Chittagong', 'Bangladesh')

-- Order Details
INSERT INTO [Order Details] VALUES
(1001, 1, 5, 10.00),
(1001, 2, 3, 39.00),
(1002, 1, 4, 10.00)
