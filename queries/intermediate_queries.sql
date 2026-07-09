USE [E-Commerce-Sales-Analytics];
GO

-- 1. Total Revenue by Product
SELECT
    p.ProductID,
    p.ProductName,
    SUM(oi.Quantity * oi.UnitPrice) AS TotalRevenue
FROM dbo.Products p
JOIN dbo.order_items oi
    ON p.ProductID = oi.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalRevenue DESC;

-- 2. Top 10 Best Selling Products
SELECT TOP 10
    p.ProductName,
    SUM(oi.Quantity) AS TotalQuantitySold
FROM dbo.Products p
JOIN dbo.order_items oi
    ON p.ProductID = oi.ProductID
GROUP BY p.ProductName
ORDER BY TotalQuantitySold DESC;

-- 3. Revenue by Category
SELECT
    p.Category,
    SUM(oi.Quantity * oi.UnitPrice) AS Revenue
FROM dbo.Products p
JOIN dbo.order_items oi
    ON p.ProductID = oi.ProductID
GROUP BY p.Category
ORDER BY Revenue DESC;

-- 4. Orders per Customer
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    COUNT(o.OrderID) AS TotalOrders
FROM dbo.Customers c
JOIN dbo.Orders o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY TotalOrders DESC;

-- 5. Monthly Revenue
SELECT
    YEAR(o.OrderDate) AS OrderYear,
    MONTH(o.OrderDate) AS OrderMonth,
    SUM(oi.Quantity * oi.UnitPrice) AS Revenue
FROM dbo.Orders o
JOIN dbo.orderItems oi
    ON o.OrderID = oi.OrderID
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
ORDER BY OrderYear, OrderMonth;

-- 6. Average Order Value
SELECT
    AVG(OrderTotal) AS AverageOrderValue
FROM
(
    SELECT
        o.OrderID,
        SUM(oi.Quantity * oi.UnitPrice) AS OrderTotal
    FROM dbo.Orders o
    JOIN dbo.orderItems oi
        ON o.OrderID = oi.OrderID
    GROUP BY o.OrderID
) AS OrderTotals;

-- 7. Top 10 Customers by Spending
SELECT TOP 10
    c.CustomerID,
    c.FirstName,
    c.LastName,
    SUM(oi.Quantity * oi.UnitPrice) AS TotalSpent
FROM dbo.Customers c
JOIN dbo.Orders o
    ON c.CustomerID = o.CustomerID
JOIN dbo.orderItems oi
    ON o.OrderID = oi.OrderID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY TotalSpent DESC;

-- 8. Average Product Price by Category
SELECT
    Category,
    AVG(Price) AS AveragePrice
FROM dbo.Products
GROUP BY Category
ORDER BY AveragePrice DESC;