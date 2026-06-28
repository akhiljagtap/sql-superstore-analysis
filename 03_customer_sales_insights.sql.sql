/*
------------------------------------------------------------
Mini Project: Customer Sales Insights
Dataset  : Superstore
------------------------------------------------------------
*/

USE store;

-- ==========================================================
-- Question 1: Who are the Top 5 Customers?
-- Technique Used:
-- CTE + JOIN + ORDER BY + LIMIT
-- ==========================================================

WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)

SELECT
    customers.customer_name,
    customer_sales.total_sales
FROM customer_sales
JOIN customers
    ON customer_sales.customer_id = customers.customer_id
ORDER BY customer_sales.total_sales DESC
LIMIT 5;

-- Explanation:
-- 1. Calculate the total sales for each customer using a CTE.
-- 2. Join the CTE with the customers table to retrieve customer names.
-- 3. Sort customers by total sales in descending order.
-- 4. Display the top five customers.


-- ==========================================================
-- Question 2: Who are the Bottom 5 Customers?
-- Technique Used:
-- CTE + JOIN + ORDER BY + LIMIT
-- ==========================================================

WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)

SELECT
    customers.customer_name,
    customer_sales.total_sales
FROM customer_sales
JOIN customers
    ON customer_sales.customer_id = customers.customer_id
ORDER BY customer_sales.total_sales ASC
LIMIT 5;

-- Explanation:
-- 1. Calculate the total sales for each customer.
-- 2. Join with the customers table to display customer names.
-- 3. Sort the customers by total sales in ascending order.
-- 4. Return the five customers with the lowest sales.


-- ==========================================================
-- Question 3: Which Customers Made Only One Order?
-- Technique Used:
-- CTE + JOIN
-- ==========================================================

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(*) AS total_orders
    FROM orders
    GROUP BY customer_id
)

SELECT
    customers.customer_name,
    customer_orders.total_orders
FROM customer_orders
JOIN customers
    ON customer_orders.customer_id = customers.customer_id
WHERE customer_orders.total_orders = 1;

-- Explanation:
-- 1. Count the number of orders placed by each customer.
-- 2. Join with the customers table to retrieve customer names.
-- 3. Filter customers who placed exactly one order.


-- ==========================================================
-- Question 4: Which Customers Have Above-Average Sales?
-- Technique Used:
-- CTE + JOIN + Subquery
-- ==========================================================

WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)

SELECT
    customers.customer_name,
    customer_sales.total_sales
FROM customer_sales
JOIN customers
    ON customer_sales.customer_id = customers.customer_id
WHERE customer_sales.total_sales >
(
    SELECT AVG(total_sales)
    FROM customer_sales
);

-- Explanation:
-- 1. Calculate the total sales for each customer.
-- 2. Calculate the average of all customer total sales using a subquery.
-- 3. Return only customers whose total sales are greater than the average.
-- 4. Join with the customers table to display customer names.


-- ==========================================================
-- Question 5: What is the Highest Order Value Per Customer?
-- Technique Used:
-- CTE + Window Function + JOIN
-- ==========================================================

WITH ranked_orders AS (
    SELECT
        customer_id,
        order_id,
        sales,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY sales DESC
        ) AS rn
    FROM orders
)

SELECT
    c.customer_name,
    ro.order_id,
    ro.sales AS highest_order_value
FROM ranked_orders ro
JOIN customers c
    ON ro.customer_id = c.customer_id
WHERE ro.rn = 1;

-- Explanation:
-- 1. Partition the orders by customer.
-- 2. Rank each customer's orders based on sales in descending order.
-- 3. Assign the highest sales order a rank of 1.
-- 4. Join with the customers table to retrieve customer names.
-- 5. Return the highest order value for each customer.