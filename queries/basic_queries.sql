USE [E-Commerce-Sales-Analytics];
GO

-- 1. Total Customers
SELECT COUNT(*) AS TotalCustomers
FROM dbo.Customers;

-- 2. Total Products
SELECT COUNT(*) AS TotalProducts
FROM dbo.Products;

-- 3. Total Orders
SELECT COUNT(*) AS TotalOrders
FROM dbo.Orders;

-- 4. Total Order Items
SELECT COUNT(*) AS TotalOrderItems
FROM dbo.order_items;

-- 5. Top 10 Customers
SELECT TOP 10
CustomerID,
FirstName,
LastName
FROM dbo.Customers;

-- 6. Top 10 Products
SELECT TOP 10
ProductID,
ProductName,
Category,
Price
FROM dbo.Products;

-- 7. Latest 10 Orders
SELECT TOP 10 *
FROM dbo.Orders
ORDER BY OrderDate DESC;

-- 8. Most Expensive Products
SELECT TOP 10
ProductName,
Price
FROM dbo.Products
ORDER BY Price DESC;

-- 9. Cheapest Products
SELECT TOP 10
ProductName,
Price
FROM dbo.Products
ORDER BY Price;

-- 10. Total Revenue
SELECT
SUM(Quantity * UnitPrice) AS TotalRevenue
FROM dbo.order_items;