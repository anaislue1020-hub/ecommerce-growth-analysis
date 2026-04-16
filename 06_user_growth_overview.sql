/*
=========================================================
User & Growth Overview
Project: E-commerce Growth Analysis

Purpose:
- Describe the user base and baseline conversion performance
- Examine user structure across key demographic dimensions
- Track user acquisition trends over time


Scope:
- Users aged 16 and above only
=========================================================
*/

USE 03ecommerce;

-- =========================================================
-- 1. User Base
-- =========================================================

-- Overall user base and baseline conversion performance
SELECT 
    COUNT(*) AS total_users,
    SUM(has_order) AS converted_users,
    SUM(has_order) * 1.0 / COUNT(*) AS conversion_rate
FROM customer_analysis
WHERE valid_cohort_customer = 1;

-- =========================================================
-- 2. User Structure
-- =========================================================

-- ---------------------------------------------------------
-- 2.1 Age Group
-- ---------------------------------------------------------

SELECT
    join_age_group,
    COUNT(*) AS total_users,
    COUNT(*) * 1.0 / SUM(COUNT(*)) OVER() AS user_share,
    SUM(has_order) AS converted_users,
    SUM(has_order) * 1.0 / COUNT(*) AS conversion_rate
FROM customer_analysis
WHERE valid_cohort_customer = 1
GROUP BY join_age_group
ORDER BY join_age_group;

-- ---------------------------------------------------------
-- 2.2 Gender
-- ---------------------------------------------------------

SELECT
    gender,
    COUNT(*) AS total_users,
    COUNT(*) * 1.0 / SUM(COUNT(*)) OVER() AS user_share,
    SUM(has_order) AS converted_users,
    SUM(has_order) * 1.0 / COUNT(*) AS conversion_rate
FROM customer_analysis
WHERE valid_cohort_customer = 1
GROUP BY gender
ORDER BY gender;

-- ---------------------------------------------------------
-- 2.3 Device Type
-- ---------------------------------------------------------

SELECT
    device_type,
    COUNT(*) AS total_users,
    COUNT(*) * 1.0 / SUM(COUNT(*)) OVER() AS user_share,
    SUM(has_order) AS converted_users,
    SUM(has_order) * 1.0 / COUNT(*) AS conversion_rate
FROM customer_analysis
WHERE valid_cohort_customer = 1
GROUP BY device_type
ORDER BY device_type;

-- =========================================================
-- 3. User Growth Trend (Monthly Base)
-- =========================================================

-- Monthly new users and converted users
SELECT
    DATE_FORMAT(first_join_date, '%Y-%m') AS month,
    COUNT(*) AS new_users,
    SUM(has_order) AS converted_users
FROM customer_analysis
WHERE valid_cohort_customer = 1
GROUP BY month
ORDER BY month;