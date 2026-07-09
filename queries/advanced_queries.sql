USE [E-Commerce-Sales-Analytics];
GO

-- 1. Top 5 Highest Revenue Products
SELECT TOP 5
    p.ProductName,
    SUM(oi.Quantity * oi.UnitPrice) AS Revenue
FROM dbo.Products p
JOIN dbo.OrderItems oi
    ON p.ProductID = oi.ProductID
GROUP BY p.ProductName
ORDER BY Revenue DESC;

-------------------------------------------------------

-- 2. Rank Customers by Total Spending
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    SUM(oi.Quantity * oi.UnitPrice) AS TotalSpent,
    RANK() OVER (
        ORDER BY SUM(oi.Quantity * oi.UnitPrice) DESC
    ) AS CustomerRank
FROM dbo.Customers c
JOIN dbo.Orders o
    ON c.CustomerID = o.CustomerID
JOIN dbo.OrderItems oi
    ON o.OrderID = oi.OrderID
GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName;

-------------------------------------------------------

-- 3. Running Revenue
SELECT
    o.OrderDate,
    SUM(oi.Quantity * oi.UnitPrice) AS DailyRevenue,
    SUM(SUM(oi.Quantity * oi.UnitPrice))
    OVER (ORDER BY o.OrderDate) AS RunningRevenue
FROM dbo.Orders o
JOIN dbo.OrderItems oi
    ON o.OrderID = oi.OrderID
GROUP BY o.OrderDate
ORDER BY o.OrderDate;

-------------------------------------------------------

-- 4. Highest Selling Product in Each Category
WITH ProductSales AS
(
    SELECT
        p.Category,
        p.ProductName,
        SUM(oi.Quantity) AS TotalSold,
        ROW_NUMBER() OVER
        (
            PARTITION BY p.Category
            ORDER BY SUM(oi.Quantity) DESC
        ) AS rn
    FROM dbo.Products p
    JOIN dbo.OrderItems oi
        ON p.ProductID = oi.ProductID
    GROUP BY
        p.Category,
        p.ProductName
)
SELECT *
FROM ProductSales
WHERE rn = 1;

-------------------------------------------------------

-- 5. Customers Who Spent Above Average
WITH CustomerTotals AS
(
    SELECT
        c.CustomerID,
        c.FirstName,
        c.LastName,
        SUM(oi.Quantity * oi.UnitPrice) AS TotalSpent
    FROM dbo.Customers c
    JOIN dbo.Orders o
        ON c.CustomerID = o.CustomerID
    JOIN dbo.OrderItems oi
        ON o.OrderID = oi.OrderID
    GROUP BY
        c.CustomerID,
        c.FirstName,
        c.LastName
)
SELECT *
FROM CustomerTotals
WHERE TotalSpent >
(
    SELECT AVG(TotalSpent)
    FROM CustomerTotals
);

-------------------------------------------------------

-- 6. Top 3 Products in Every Category
WITH RankedProducts AS
(
    SELECT
        p.Category,
        p.ProductName,
        SUM(oi.Quantity) AS QuantitySold,
        DENSE_RANK() OVER
        (
            PARTITION BY p.Category
            ORDER BY SUM(oi.Quantity) DESC
        ) AS RankNo
    FROM dbo.Products p
    JOIN dbo.OrderItems oi
        ON p.ProductID = oi.ProductID
    GROUP BY
        p.Category,
        p.ProductName
)
SELECT *
FROM RankedProducts
WHERE RankNo <= 3;

-------------------------------------------------------

-- 7. Monthly Sales Growth
WITH MonthlySales AS
(
    SELECT
        YEAR(o.OrderDate) AS Yr,
        MONTH(o.OrderDate) AS Mn,
        SUM(oi.Quantity * oi.UnitPrice) AS Revenue
    FROM dbo.Orders o
    JOIN dbo.OrderItems oi
        ON o.OrderID = oi.OrderID
    GROUP BY
        YEAR(o.OrderDate),
        MONTH(o.OrderDate)
)
SELECT *,
LAG(Revenue) OVER
(
    ORDER BY Yr, Mn
) AS PreviousMonthRevenue
FROM MonthlySales;

-------------------------------------------------------

-- 8. Top 10 Most Ordered Products
SELECT TOP 10
    p.ProductName,
    COUNT(*) AS NumberOfOrders
FROM dbo.Products p
JOIN dbo.OrderItems oi
    ON p.ProductID = oi.ProductID
GROUP BY p.ProductName
ORDER BY NumberOfOrders DESC;