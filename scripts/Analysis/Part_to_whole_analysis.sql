/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
-- Which categories contribute the most to overall sales?
WITH CTE AS (
SELECT
    P.CATEGORY,
    SUM(SALES_AMOUNT) AS TOTAL_SALES
FROM GOLD.FACT_SALES S
LEFT JOIN GOLD.DIM_PRODUCTS P
    ON S.PRODUCT_KEY = P.PRODUCT_KEY
GROUP BY P.CATEGORY
)

SELECT 
    CATEGORY,
    TOTAL_SALES,
    SUM(TOTAL_SALES) OVER () AS OVERALL_SALES,
    ROUND(100 * CAST(TOTAL_SALES AS float) / SUM(TOTAL_SALES) OVER (),2) AS PERCENT_OF_TOTAL
FROM CTE
ORDER BY PERCENT_OF_TOTAL DESC
