# 📊 Superstore SQL Data Analysis Project

## 🧾 Project Overview

This project performs SQL analysis on the **Superstore dataset**.  
It includes:

- table creation (Step 1)
- Advanced SQL queries using Subqueries, CTEs, and Window Functions (Step 2)
- Business insights through a Mini Project (Customer Sales Insights)

The goal is to demonstrate real-world SQL skills used in data analytics roles.

---

## 🗂️ Dataset

- Dataset: Superstore Sales Dataset
- Database: `store`
- Raw Table: `superstore_raw`

### Final Tables Created:
- `customers`
- `products`
- `orders`

---

# 🏗️ STEP 1: DATA SETUP (DATA MODELING)

## Objective

Normalize raw dataset into structured relational tables.

## Process

- Created structured tables using `CREATE TABLE`
- Inserted cleaned data using `SELECT DISTINCT`, `GROUP BY`
- Converted data types using `CAST()` and `STR_TO_DATE()`
- Built a relational schema using Customer ID and Product ID

---

## Key Transformations

- Converted date strings → DATE format
- Converted numeric fields → DECIMAL/INT
- Removed duplicates using GROUP BY / DISTINCT
- Separated data into dimension and fact tables

---

# 📊 STEP 2: ADVANCED SQL QUERIES

## Objective

Perform analytical queries using advanced SQL concepts.

## SQL Concepts Used

- Subqueries
- Correlated Subqueries
- CTE (Common Table Expressions)
- Window Functions (ROW_NUMBER, RANK, DENSE_RANK)
- Aggregations (SUM, AVG, COUNT)
- Joins

---

## Sample Analyses

- Orders above average sales
- Highest sales order per customer
- Total sales per customer
- Customers above average performance
- Customer ranking based on total sales

---

## Example Query (Window Function)

```sql
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
