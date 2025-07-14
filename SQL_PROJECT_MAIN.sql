-- ============================================================
-- 🧠 Project: Retail Sales Data Analysis
-- 👤 Analyst: Qayum Miller
-- 🎯 Goal: Uncover key sales trends and performance metrics
-- 📊 Tools: SQL Server, SSMS
-- 📁 Tables Used: Sales$, Stores$, Products$, Customers$
-- ============================================================


-- 💰 Monthly Revenue Analysis
-- Identify months with total revenue exceeding $50M

SELECT 
    SUM(Price) AS monthly_revenue, 
    MONTH(TransactionDate) AS month_number
FROM dbo.Sales$
GROUP BY MONTH(TransactionDate)
HAVING SUM(Price) > 50000000
ORDER BY monthly_revenue DESC;



-- 🏬 Top 10 Stores by Sales in 2006
-- Highlight the most profitable store locations for 2006

SELECT TOP 10 
    s.StoreID,
    s.CityName,
    s.CountryName,
    SUM(sa.Price) AS TotalSales
FROM dbo.Sales$ sa
JOIN dbo.Stores$ s ON sa.StoreID = s.StoreID
WHERE YEAR(sa.TransactionDate) = 2006
GROUP BY s.StoreID, s.CityName, s.CountryName
ORDER BY TotalSales DESC;



-- 🏬 Top 10 Stores by Sales in 2007
-- Highlight the most profitable store locations for 2007

SELECT TOP 10 
    s.StoreID,
    s.CityName,
    s.CountryName,
    SUM(sa.Price) AS TotalSales
FROM dbo.Sales$ sa
JOIN dbo.Stores$ s ON sa.StoreID = s.StoreID
WHERE YEAR(sa.TransactionDate) = 2007
GROUP BY s.StoreID, s.CityName, s.CountryName
ORDER BY TotalSales DESC;



-- Top 5 Selling Products in the US by Invoice Count
-- Discover the most frequently sold products in the U.S. market

SELECT TOP 5 
    COUNT(s.Invoice) AS total_invoices,  
    p.ProductDescription, 
    s2.CountryName
FROM dbo.Sales$ s
JOIN dbo.Stores$ s2 ON s.StoreID = s2.StoreID
JOIN dbo.Products$ p ON s.ProductKey = p.ProductKey
WHERE s2.CountryName = 'US'
GROUP BY p.ProductDescription, s2.CountryName
ORDER BY total_invoices DESC;



-- 📦 Top 5 Products by Total Sales Volume (Global)
-- Rank products by the number of invoices

SELECT 
    p.ProductKey, 
    p.ProductDescription, 
    p.Brand, 
    p.Type, 
    COUNT(s.Invoice) AS total_sales
FROM dbo.Sales$ s
LEFT JOIN dbo.Products$ p ON s.ProductKey = p.ProductKey
GROUP BY 
    p.ProductKey, 
    p.ProductDescription, 
    p.Brand, 
    p.Type
ORDER BY total_sales DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;



-- 🏆 Most Profitable Year + Top-Selling Product That Year
-- Use CTEs to determine the top revenue year and its leading product

WITH YearlySales AS (
    SELECT 
        YEAR(sa.TransactionDate) AS SalesYear,
        SUM(sa.Price) AS TotalSales
    FROM dbo.Sales$ sa
    GROUP BY YEAR(sa.TransactionDate)
),
TopYear AS (
    SELECT TOP 1 SalesYear
    FROM YearlySales
    ORDER BY TotalSales DESC
)
SELECT TOP 1
    (SELECT SalesYear FROM TopYear) AS MostProfitableYear,
    p.ProductDescription,
    SUM(sa.Price) AS TotalProductSales
FROM dbo.Sales$ sa
JOIN dbo.Products$ p ON sa.ProductKey = p.ProductKey
WHERE YEAR(sa.TransactionDate) = (SELECT SalesYear FROM TopYear)
GROUP BY p.ProductDescription
ORDER BY TotalProductSales DESC;



-- 🌍 Yearly Spending by Country
-- Evaluate yearly total revenue by customer country

SELECT 
    c.Country, 
    SUM(s.Price) AS total_spending, 
    YEAR(s.TransactionDate) AS year_of_spending
FROM dbo.Sales$ s
LEFT JOIN dbo.Customers$ c ON s.CustomerKey = c.CustomerKey
GROUP BY c.Country, YEAR(s.TransactionDate)
ORDER BY total_spending DESC;



-- 👨‍💼 Total Revenue by Employee in 2011
-- Identify top revenue-generating employees

SELECT
    EmpKey, 
    YEAR(TransactionDate) AS SalesYear, 
    SUM(Price) AS employee_revenue
FROM dbo.Sales$
WHERE YEAR(TransactionDate) = 2011
GROUP BY EmpKey, YEAR(TransactionDate)
ORDER BY employee_revenue DESC;
