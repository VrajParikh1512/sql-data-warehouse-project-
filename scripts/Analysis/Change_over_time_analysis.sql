/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- Analyse sales performance over time
-- Quick Date Functions
SELECT 
    YEAR(ORDER_DATE) AS ORDER_YEAR,
    MONTH(ORDER_DATE) AS ORDER_MONTH,
    SUM(SALES_AMOUNT) AS TOTAL_SALES,
    COUNT(DISTINCT CUSTOMER_KEY) AS TOTAL_CUSTOMERS,
    SUM(QUANTITY) AS TOTAL_QUANTITY
FROM GOLD.FACT_SALES
WHERE ORDER_DATE IS NOT NULL
GROUP BY YEAR(ORDER_DATE), MONTH(ORDER_DATE)
ORDER BY YEAR(ORDER_DATE), MONTH(ORDER_DATE)

-- DATETRUNC()
SELECT 
    DATETRUNC(MONTH,ORDER_DATE) AS ORDER_MONTH,
    SUM(SALES_AMOUNT) AS TOTAL_SALES,
    COUNT(DISTINCT CUSTOMER_KEY) AS TOTAL_CUSTOMERS,
    SUM(QUANTITY) AS TOTAL_QUANTITY
FROM GOLD.FACT_SALES
WHERE ORDER_DATE IS NOT NULL
GROUP BY DATETRUNC(MONTH,ORDER_DATE)
ORDER BY DATETRUNC(MONTH,ORDER_DATE)

-- FORMAT()
SELECT
    FORMAT(order_date, 'yyyy-MMM') AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM');
