/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

-- Calculate the total and avg sales per month 
-- and the running total and avg of sales over time 
SELECT 
    FORMAT(ORDER_DATE,'yyyy') AS ORDER_DATE,
    SUM(SALES_AMOUNT) AS TOTAL_SALES,
    SUM(SUM(SALES_AMOUNT)) OVER (ORDER BY FORMAT(ORDER_DATE,'yyyy') ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RUNNING_TOTAL_SALES,
    AVG(SALES_AMOUNT) AS AVG_SALES,
    AVG(AVG(SALES_AMOUNT)) OVER (ORDER BY FORMAT(ORDER_DATE,'yyyy') ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RUNNING_AVG_SALES
FROM GOLD.FACT_SALES
WHERE ORDER_DATE IS NOT NULL
GROUP BY FORMAT(ORDER_DATE,'yyyy')
