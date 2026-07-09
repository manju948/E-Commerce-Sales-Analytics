USE [E-Commerce-Sales-Analytics];
GO

-- Check Customers
SELECT * FROM Customers;

-- Check Products
SELECT * FROM Products;

-- Check Orders
SELECT * FROM Orders;

-- Check OrderItems
SELECT * FROM order_items;

-- Check NULL values in Customers
SELECT *
FROM Customers
WHERE FirstName IS NULL
   OR LastName IS NULL
   OR Email IS NULL;

-- Duplicate Emails
SELECT Email, COUNT(*) AS Total
FROM Customers
GROUP BY Email
HAVING COUNT(*) > 1;

-- Products with Invalid Price
SELECT *
FROM Products
WHERE Price <= 0;

-- Orders without Customer
SELECT *
FROM Orders
WHERE CustomerID IS NULL;

-- Order Items with Invalid Quantity
SELECT *
FROM order_items
WHERE Quantity <= 0;

-- Order Items with Invalid Price
SELECT *
FROM order_items
WHERE UnitPrice <= 0;