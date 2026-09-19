/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

/*Segment products into cost ranges and 
count how many products fall into each segment*/
WITH CTE AS (
SELECT 
    PRODUCT_KEY,
    PRODUCT_NAME,
    COST,
    CASE 
        WHEN COST<100 THEN 'BELOW 100'
        WHEN COST<500 THEN '100-500'
        WHEN COST<1000 THEN '500-1000'
        ELSE 'ABOVE 1000 '
    END AS PRODUCT_SEGMENT
FROM GOLD.DIM_PRODUCTS
)

SELECT 
    PRODUCT_SEGMENT,
    COUNT(PRODUCT_SEGMENT) AS TOTAL_PRODUCTS
FROM CTE
GROUP BY PRODUCT_SEGMENT
ORDER BY TOTAL_PRODUCTS DESC;

/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/
WITH CTE AS (
SELECT 
    CUSTOMER_KEY,
    CASE 
        WHEN DATEDIFF(MONTH, MIN(ORDER_DATE), MAX(ORDER_DATE)) >= 12 AND SUM(SALES_AMOUNT) > 5000 THEN 'VIP'
        WHEN DATEDIFF(MONTH, MIN(ORDER_DATE), MAX(ORDER_DATE)) >= 12 THEN 'Regular'
        ELSE 'New'
    END AS CUST_SEGMENT
FROM GOLD.FACT_SALES
GROUP BY CUSTOMER_KEY
)

SELECT 
    CUST_SEGMENT,
    COUNT(CUST_SEGMENT) AS TOTAL_CUSTOMERS
FROM CTE
GROUP BY CUST_SEGMENT;
