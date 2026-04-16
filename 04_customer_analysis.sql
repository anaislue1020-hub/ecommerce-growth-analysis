/*
=========================================================
Customer Analysis Table
Project: E-commerce Growth Analysis

Purpose:
- Construct a customer-level analytical table
- Enrich customer data with behavioral flags and cohort features

Key features:
- First successful order date
- Conversion flag (has_order)
- Join age and age group
- Analysis eligibility flags
=========================================================
*/

USE 03ecommerce;

-- =========================================================
-- 1. Customer Analysis Table
-- =========================================================

-- Drop existing table
DROP TABLE IF EXISTS customer_analysis;

-- Create customer analysis table
CREATE TABLE customer_analysis AS

-- First successful order date (Success Only)
WITH first_order AS (
    SELECT
        customer_id,
        MIN(order_created_at) AS first_order_date
    FROM orders_clean
    WHERE payment_status = 'Success'
    GROUP BY customer_id
)

SELECT
    c.customer_id,

    -- Standardized gender
    CASE 
        WHEN c.gender = 'F' THEN 'Female'
        WHEN c.gender = 'M' THEN 'Male'
    END AS gender,

    c.birthdate,
    c.first_join_date,
    c.device_type,

    -- First successful order date
    f.first_order_date,

    -- Conversion flag
    CASE
        WHEN f.customer_id IS NOT NULL THEN 1
        ELSE 0
    END AS has_order,

    -- Join age (core analysis variable)
    TIMESTAMPDIFF(YEAR, c.birthdate, c.first_join_date) AS join_age,

    -- Age grouping
    CASE
        WHEN TIMESTAMPDIFF(YEAR, c.birthdate, c.first_join_date) < 16 THEN 'Under 16'
        WHEN TIMESTAMPDIFF(YEAR, c.birthdate, c.first_join_date) BETWEEN 16 AND 17 THEN '16-17 Minors'
        WHEN TIMESTAMPDIFF(YEAR, c.birthdate, c.first_join_date) BETWEEN 18 AND 24 THEN '18-24 Young'
        WHEN TIMESTAMPDIFF(YEAR, c.birthdate, c.first_join_date) BETWEEN 25 AND 34 THEN '25-34 Early Career'
        WHEN TIMESTAMPDIFF(YEAR, c.birthdate, c.first_join_date) BETWEEN 35 AND 44 THEN '35-44 Mid Career'
        WHEN TIMESTAMPDIFF(YEAR, c.birthdate, c.first_join_date) BETWEEN 45 AND 54 THEN '45-54 Mature'
        ELSE '55+ Senior'
    END AS join_age_group,

    -- Eligible for behavior analysis
    CASE
        WHEN f.customer_id IS NOT NULL
             AND TIMESTAMPDIFF(YEAR, c.birthdate, c.first_join_date) >= 16
        THEN 1
        ELSE 0
    END AS valid_behavior_customer,

    -- Eligible for cohort base
    CASE
        WHEN TIMESTAMPDIFF(YEAR, c.birthdate, c.first_join_date) >= 16
        THEN 1
        ELSE 0
    END AS valid_cohort_customer

FROM customer_clean c
LEFT JOIN first_order f
    ON c.customer_id = f.customer_id;

-- =========================================================
-- 2. Validation
-- =========================================================

SELECT COUNT(*) AS total_rows FROM customer_analysis;

SELECT has_order, COUNT(*) 
FROM customer_analysis
GROUP BY has_order;

SELECT valid_behavior_customer, COUNT(*)
FROM customer_analysis
GROUP BY valid_behavior_customer;

SELECT valid_cohort_customer, COUNT(*)
FROM customer_analysis
GROUP BY valid_cohort_customer;

SELECT join_age_group, COUNT(*)
FROM customer_analysis
GROUP BY join_age_group
ORDER BY join_age_group;