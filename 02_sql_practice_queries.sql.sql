/*
------------------------------------------------------------
STEP 2 - SQL Practice Queries
Dataset  : Superstore
------------------------------------------------------------
*/

USE store;

-- ==========================================================
-- Question 1: Find all orders where sales are greater than
-- the average sales.
-- Technique Used:
-- Subquery
-- ==========================================================

SELECT
    order_id,
    customer_id,
    sales
FROM orders
WHERE sales >
(
    SELECT AVG(sales)
    FROM orders
);

-- Explanation:
-- 1. Calculate the average sales across all orders.
-- 2. Compare each order's sales with the calculated average.
-- 3. Return only the orders whose sales exceed the average.



-- ==========================================================
-- Question 2: Find the highest sales order for each customer.
-- Technique Used:
-- Window Function (ROW_NUMBER)
-- ==========================================================

SELECT
    order_id,
    customer_id,
    sales
FROM (
    SELECT
        order_id,
        customer_id,
        sales,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY sales DESC
        ) AS rn
    FROM orders
) t
WHERE rn = 1;


-- ==========================================================
-- Question 3: Calculate total sales for each customer.
-- Technique Used:
-- CTE
-- ==========================================================

WITH customer_sales AS
(
    SELECT
        customer_id,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)

SELECT
    customer_id,
    total_sales
FROM customer_sales;

-- Explanation:
-- 1. Group all orders by customer.
-- 2. Calculate the total sales using the SUM() function.
-- 3. Store the result inside a CTE for better readability and reuse.



-- ==========================================================
-- Question 4: Find customers whose total sales are above
-- the average total sales.
-- Technique Used:
-- CTE + JOIN + Subquery
-- ==========================================================

WITH customer_sales AS
(
    SELECT
        customer_id,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)

SELECT
    customer.customer_name,
    customer_sales.total_sales
FROM customer_sales
JOIN customers AS customer
    ON customer_sales.customer_id = customer.customer_id
WHERE customer_sales.total_sales >
(
    SELECT AVG(total_sales)
    FROM customer_sales
);

-- Explanation:
-- 1. Calculate total sales for every customer.
-- 2. Calculate the average of all customer total sales.
-- 3. Return only customers whose total sales are above average.
-- 4. Join with the customers table to display customer names.



-- ==========================================================
-- Question 5: Rank all customers based on total sales.
-- Technique Used:
-- CTE + JOIN + Window Function
-- ==========================================================

WITH customer_sales AS
(
    SELECT
        customer_id,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)

SELECT
    customer.customer_name,
    customer_sales.total_sales,
    DENSE_RANK() OVER
    (
        ORDER BY customer_sales.total_sales DESC
    ) AS sales_rank
FROM customer_sales
JOIN customers AS customer
    ON customer_sales.customer_id = customer.customer_id;

-- Explanation:
-- 1. Calculate the total sales for every customer.
-- 2. Join with the customers table to retrieve customer names.
-- 3. Rank customers based on total sales in descending order.
-- 4. Customers with the same total sales receive the same rank.



-- ==========================================================
-- Question 6: Assign row numbers to each order within
-- a customer.
-- Technique Used:
-- Window Function + PARTITION BY
-- ==========================================================

SELECT
    order_id,
    customer_id,
    sales,
    ROW_NUMBER() OVER
    (
        PARTITION BY customer_id
        ORDER BY sales DESC
    ) AS row__number
FROM orders;

-- Explanation:
-- 1. Partition the orders by customer.
-- 2. Sort each customer's orders by sales in descending order.
-- 3. Assign a unique row number within each customer group.



-- ==========================================================
-- Question 7: Display the Top 3 Customers based on
-- total sales.
-- Technique Used:
-- CTE + JOIN + Window Function
-- ==========================================================

WITH customer_sales AS
(
    SELECT
        customer_id,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
),

ranked_customers AS
(
    SELECT
        customer_id,
        total_sales,
        DENSE_RANK() OVER
        (
            ORDER BY total_sales DESC
        ) AS sales_rank
    FROM customer_sales
)

SELECT
    customer.customer_name,
    ranked_customers.total_sales,
    ranked_customers.sales_rank
FROM ranked_customers
JOIN customers AS customer
    ON ranked_customers.customer_id = customer.customer_id
WHERE ranked_customers.sales_rank <= 3;

-- Explanation:
-- 1. Calculate the total sales for each customer.
-- 2. Rank customers based on total sales.
-- 3. Join with the customers table to display customer names.
-- 4. Return customers whose rank is within the top three.



/*
------------------------------------------------------------
STEP 3 - Final Combined Query
Requirement:
Display Customer Name, Total Sales and Rank
------------------------------------------------------------
*/

-- ==========================================================
-- Final Query
-- Technique Used:
-- CTE + JOIN + Window Function
-- ==========================================================

WITH customer_sales AS
(
    SELECT
        customer_id,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)

SELECT
    customer.customer_name,
    customer_sales.total_sales,
    DENSE_RANK() OVER
    (
        ORDER BY customer_sales.total_sales DESC
    ) AS sales_rank
FROM customer_sales
JOIN customers AS customer
    ON customer_sales.customer_id = customer.customer_id;

-- Explanation:
-- 1. Calculate the total sales for each customer.
-- 2. Join with the customers table to retrieve customer names.
-- 3. Rank customers according to total sales.
-- 4. Display customer name, total sales and corresponding rank.