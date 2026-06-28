-- =========================================
-- STEP 1 - SETUP DATA (SUPERSTORE PROJECT)
-- Goal: Normalize raw dataset into 3 tables
-- =========================================
 
-- Select the working database
use store;

select * from superstore_raw;

-- 1. CUSTOMERS TABLE
CREATE TABLE IF NOT EXISTS customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    region VARCHAR(50)
);

-- Insert unique customers using GROUP BY
INSERT INTO customers
SELECT
    `Customer ID`,
    MAX(`Customer Name`),
    MAX(`Segment`),
    MAX(`Country`),
    MAX(`City`),
    MAX(`State`),
    MAX(`Postal Code`),
    MAX(`Region`)
FROM superstore_raw
GROUP BY `Customer ID`;

-- 2. PRODUCTS TABLE
CREATE TABLE IF NOT EXISTS products (
    product_id VARCHAR(100) PRIMARY KEY,
    category VARCHAR(100),
    sub_category VARCHAR(100),
    product_name TEXT
);

-- Insert unique products using GROUP BY
INSERT INTO products
SELECT 
    `Product ID`,
    MAX(`Category`),
    MAX(`Sub-Category`),
    MAX(`Product Name`)
FROM superstore_raw
group by `Product ID`;

-- select * from products;

-- 3. ORDERS TABLE
CREATE TABLE IF NOT EXISTS orders (
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    product_id VARCHAR(100),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(10,2)
);

-- Insert ALL transaction records (no grouping needed)
INSERT INTO orders
SELECT
    `Order ID`,
    STR_TO_DATE(`Order Date`, '%m/%d/%Y'),
    STR_TO_DATE(`Ship Date`, '%m/%d/%Y'),
    `Ship Mode`,
    `Customer ID`,
    `Product ID`,
    CAST(`Sales` AS DECIMAL(10,2)),
    CAST(`Quantity` AS UNSIGNED), -- Quantity always be positive, (-2 is invalid for qty.) 
    CAST(`Discount` AS DECIMAL(5,2)),
    CAST(`Profit` AS DECIMAL(10,2))
FROM superstore_raw;

-- =========================================
-- DATA IS NOW NORMALIZED INTO 3 TABLES (customers, prducts, orders)
-- =========================================