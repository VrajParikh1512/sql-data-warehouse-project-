/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */
WITH YEARLY_PRODUCT_SALES AS (
SELECT 
    PRODUCT_NAME,
    FORMAT(ORDER_DATE,'yyyy') AS ORDER_YEAR,
    SUM(SALES_AMOUNT) AS TOTAL_SALES
FROM GOLD.FACT_SALES S
LEFT JOIN GOLD.DIM_PRODUCTS P
    ON  S.PRODUCT_KEY = P.PRODUCT_KEY
WHERE ORDER_DATE IS NOT NULL
GROUP BY FORMAT(ORDER_DATE,'yyyy'), PRODUCT_NAME
)

SELECT 
    PRODUCT_NAME,
    ORDER_YEAR,
    TOTAL_SALES,
    AVG(TOTAL_SALES) OVER (PARTITION BY PRODUCT_NAME) AS AVG_SALES,
    CASE 
        WHEN TOTAL_SALES > AVG(TOTAL_SALES) OVER (PARTITION BY PRODUCT_NAME) THEN 'ABOVE AVG'
        WHEN TOTAL_SALES < AVG(TOTAL_SALES) OVER (PARTITION BY PRODUCT_NAME) THEN 'BELOW AVG'
        ELSE 'AVG'
    END AS COMPARE_WITH_AVG,
    LAG(TOTAL_SALES) OVER (PARTITION BY PRODUCT_NAME ORDER BY ORDER_YEAR) AS PREV_SALES,
    CASE 
        WHEN TOTAL_SALES > LAG(TOTAL_SALES) OVER (PARTITION BY PRODUCT_NAME ORDER BY ORDER_YEAR) THEN 'INCREASE'
        WHEN TOTAL_SALES < LAG(TOTAL_SALES) OVER (PARTITION BY PRODUCT_NAME ORDER BY ORDER_YEAR) THEN 'DECREASE'
        ELSE 'NO CHANGE'
    END AS COMPARE_WITH_PREV_YEAR
FROM YEARLY_PRODUCT_SALES
ORDER BY PRODUCT_NAME, ORDER_YEAR
