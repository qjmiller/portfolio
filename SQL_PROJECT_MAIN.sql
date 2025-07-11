- Identify columns in dbo.Sales$ that could serve as unique keys by 
	  --checking for duplicates.

SELECT DISTINCT * 
FROM dbo.Sales$;


-  Calculate monthly revenue and identify months where the revenue 
	  --crossed $50 million. Round the revenue to 2 decimal places. 

select SUM(Price) as monthly_revenue, MONTH(TransactionDate) as month_number
from dbo.Sales$
GROUP BY MONTH(TransactionDate)
HAVING SUM(Price) > 50000000
order by monthly_revenue DESC


- Top Stores by Sales (2006 & 2007)

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
----------------------------------
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


- Determine the product with the highest number of sales in the US.

SELECT TOP 5 COUNT(s.Invoice) AS total_invoices,  p.ProductDescription, s2.CountryName
FROM dbo.Sales$ s
JOIN dbo.Stores$ s2 ON s.StoreID =s2.StoreID
JOIN dbo.Products$ p ON s.ProductKey = p.ProductKey
WHERE s2.CountryName = 'US'
GROUP BY  p.ProductDescription,  
         s2.CountryName
ORDER BY total_invoices DESC


- Retrieve product details from the dbo.Products$ table. 

SELECT 
	p.ProductKey, 
	p.ProductDescription, 
	p.Brand, 
	p.Type, 
	COUNT(s.Invoice) AS total_sales
FROM dbo.Sales$ s
LEFT JOIN Products$ p ON s.ProductKey=p.ProductKey
GROUP BY
	p.ProductKey, 
	p.ProductDescription, 
	p.Brand, 
	p.Type
ORDER BY total_sales DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;


- Most Profitable Year and Product

WITH YearlySales AS (
    SELECT 
        YEAR(sa.TransactionDate) AS SalesYear,
        SUM(sa.Price) AS TotalSales
    FROM dbo.Sales$ sa
    GROUP BY YEAR(sa.TransactionDate)),
TopYear AS (
    SELECT TOP 1 
        SalesYear
    FROM YearlySales
    ORDER BY TotalSales DESC)
SELECT TOP 1
    (SELECT SalesYear FROM TopYear) AS MostProfitableYear,
    p.ProductDescription,
    SUM(sa.Price) AS TotalProductSales
FROM dbo.Sales$ sa
JOIN dbo.Products$ p ON sa.ProductKey = p.ProductKey
WHERE YEAR(sa.TransactionDate) = (SELECT SalesYear FROM TopYear)
GROUP BY p.ProductDescription
ORDER BY TotalProductSales DESC;


- Use the dbo.Customers$ and dbo.Sales$ tables to calculate yearly spending for each country.

SELECT c.Country, SUM(s.Price) AS total_spending, YEAR(s.TransactionDate) as year_of_spending
FROM dbo.Sales$ s
LEFT JOIN dbo.Customers$ c ON s.CustomerKey = c.CustomerKey
GROUP BY 
    c.Country, 
    YEAR(s.TransactionDate)
ORDER BY 
    total_spending DESC;


- Calculate the total revenue generated by each employee in 2011.

SELECT
EmpKey, 
YEAR(TransactionDate) AS Year, 
SUM(Price) AS employee_revenue
FROM dbo.Sales$
WHERE YEAR(TransactionDate) = 2011
GROUP BY 
EmpKey,
YEAR(TransactionDate)
ORDER BY employee_revenue DESC;

