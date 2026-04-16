/*
=========================================================
Cohort Conversion Analysis
Project: E-commerce Growth Analysis

Purpose:
- Measure cohort conversion within 30-day and 90-day windows
- Compare overall cohort conversion and age-group differences

Scope:
- Users aged 16 and above only
- Monthly cohort output (used as base for quarterly reporting)
=========================================================
*/

USE 03ecommerce;

-- =========================================================
-- 1. Overall Cohort Conversion
-- =========================================================

SELECT
    DATE_FORMAT(first_join_date, '%Y-%m') AS cohort_month,
    COUNT(*) AS cohort_users,

    SUM(
        CASE
            WHEN has_order = 1
             AND DATEDIFF(first_order_date, first_join_date) <= 30
            THEN 1 ELSE 0
        END
    ) AS converted_users_30d,

    SUM(
        CASE
            WHEN has_order = 1
             AND DATEDIFF(first_order_date, first_join_date) <= 90
            THEN 1 ELSE 0
        END
    ) AS converted_users_90d,

    SUM(
        CASE
            WHEN has_order = 1
             AND DATEDIFF(first_order_date, first_join_date) <= 30
            THEN 1 ELSE 0
        END
    ) * 1.0 / COUNT(*) AS conversion_rate_30d,

    SUM(
        CASE
            WHEN has_order = 1
             AND DATEDIFF(first_order_date, first_join_date) <= 90
            THEN 1 ELSE 0
        END
    ) * 1.0 / COUNT(*) AS conversion_rate_90d

FROM customer_analysis
WHERE valid_cohort_customer = 1
GROUP BY cohort_month
ORDER BY cohort_month;

-- =========================================================
-- 2. Cohort Conversion by Age Group
-- =========================================================

SELECT
    DATE_FORMAT(first_join_date, '%Y-%m') AS cohort_month,
    join_age_group,
    COUNT(*) AS cohort_users,

    SUM(
        CASE
            WHEN has_order = 1
             AND DATEDIFF(first_order_date, first_join_date) <= 30
            THEN 1 ELSE 0
        END
    ) AS converted_users_30d,

    SUM(
        CASE
            WHEN has_order = 1
             AND DATEDIFF(first_order_date, first_join_date) <= 90
            THEN 1 ELSE 0
        END
    ) AS converted_users_90d,

    SUM(
        CASE
            WHEN has_order = 1
             AND DATEDIFF(first_order_date, first_join_date) <= 30
            THEN 1 ELSE 0
        END
    ) * 1.0 / COUNT(*) AS conversion_rate_30d,

    SUM(
        CASE
            WHEN has_order = 1
             AND DATEDIFF(first_order_date, first_join_date) <= 90
            THEN 1 ELSE 0
        END
    ) * 1.0 / COUNT(*) AS conversion_rate_90d

FROM customer_analysis
WHERE valid_cohort_customer = 1
GROUP BY cohort_month, join_age_group
ORDER BY cohort_month, join_age_group;