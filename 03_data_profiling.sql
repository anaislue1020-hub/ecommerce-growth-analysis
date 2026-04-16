/*
=========================================================
Data Profiling (EDA)
Project: E-commerce Growth Analysis

Purpose:
- Understand basic data distribution and structure
- Identify time range, user demographics, and key transaction patterns
- Support downstream analysis design

Scope:
- Time range
- Age distribution (join age)
- Payment status distribution
=========================================================
*/

USE 03ecommerce;

-- =========================================================
-- 1. Time Range
-- =========================================================

-- Customer join date range
SELECT 
    MIN(first_join_date) AS min_join_date,
    MAX(first_join_date) AS max_join_date
FROM customer_clean;

-- Order timestamp range
SELECT 
    MIN(order_created_at) AS min_order_date,
    MAX(order_created_at) AS max_order_date
FROM orders_clean;

-- =========================================================
-- 2. User Age Distribution (Join Age)
-- =========================================================

-- Overall age summary
SELECT
    MIN(TIMESTAMPDIFF(YEAR, birthdate, first_join_date)) AS min_age,
    MAX(TIMESTAMPDIFF(YEAR, birthdate, first_join_date)) AS max_age,
    AVG(TIMESTAMPDIFF(YEAR, birthdate, first_join_date)) AS avg_age
FROM customer_clean;

-- Detailed age distribution
SELECT
    TIMESTAMPDIFF(YEAR, birthdate, first_join_date) AS join_age,
    COUNT(DISTINCT customer_id) AS user_count
FROM customer_clean
GROUP BY join_age
ORDER BY join_age;

-- Age group distribution (Under 16 vs 16+)
SELECT
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, birthdate, first_join_date) < 16 THEN 'Under 16'
        ELSE '16+'
    END AS age_group,
    COUNT(*) AS user_count,
    COUNT(*) * 1.0 / SUM(COUNT(*)) OVER() AS user_share
FROM customer_clean
GROUP BY age_group;

-- =========================================================
-- 3. Payment Status Distribution
-- =========================================================

SELECT
    payment_status,
    COUNT(*) AS order_count,
    COUNT(*) * 1.0 / SUM(COUNT(*)) OVER() AS status_pct
FROM orders_clean
GROUP BY payment_status
ORDER BY order_count DESC;