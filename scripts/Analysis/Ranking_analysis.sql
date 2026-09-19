/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Which 5 products Generating the Highest Revenue?
-- Simple Ranking
SELECT TOP 5
    PRODUCT_NAME,
    SUM(SALES_AMOUNT) AS TOTAL_SALES
FROM GOLD.FACT_SALES S
LEFT JOIN GOLD.DIM_PRODUCTS P
    ON S.PRODUCT_KEY = P.PRODUCT_KEY
GROUP BY PRODUCT_NAME
ORDER BY TOTAL_SALES DESC

-- Complex but Flexibly Ranking Using Window Functions
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE rank_products <= 5;

-- What are the 5 worst-performing products in terms of sales?
SELECT TOP 5
    PRODUCT_NAME,
    SUM(SALES_AMOUNT) AS TOTAL_SALES
FROM GOLD.FACT_SALES S
LEFT JOIN GOLD.DIM_PRODUCTS P
    ON S.PRODUCT_KEY = P.PRODUCT_KEY
GROUP BY PRODUCT_NAME
ORDER BY TOTAL_SALES 

-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10
    FIRST_NAME,
    LAST_NAME,
    SUM(SALES_AMOUNT) AS TOTAL_SALES
FROM GOLD.FACT_SALES S
LEFT JOIN GOLD.DIM_CUSTOMERS C
    ON S.CUSTOMER_KEY = C.CUSTOMER_KEY
GROUP BY FIRST_NAME, LAST_NAME
ORDER BY TOTAL_SALES DESC

-- The 3 customers with the fewest orders placed
SELECT TOP 3 
    FIRST_NAME,
    LAST_NAME,
    COUNT(ORDER_NUMBER) AS TOTAL_ORDERS
FROM GOLD.FACT_SALES S
LEFT JOIN GOLD.DIM_CUSTOMERS C
    ON S.CUSTOMER_KEY = C.CUSTOMER_KEY
GROUP BY FIRST_NAME, LAST_NAME
ORDER BY TOTAL_ORDERS
