/*
=========================================================
Cohort Repeat & Frequency Analysis
Project: E-commerce Growth Analysis

Purpose:
- Measure cohort repeat behavior within 30-day and 90-day windows
- Measure cohort purchase frequency within 30-day and 90-day windows
- Compare overall cohort dynamics and age-group differences

Scope:
- Users aged 16 and above only
- Successful orders only
- Monthly cohort output (used as base for quarterly reporting)
=========================================================
*/

USE 03ecommerce;

-- =========================================================
-- 1. Cohort Repeat - Overall
-- =========================================================

WITH orders_in_window AS (
    SELECT
        c.customer_id,
        DATE_FORMAT(c.first_join_date, '%Y-%m') AS cohort_month,

        COUNT(DISTINCT CASE
            WHEN DATEDIFF(o.order_created_at, c.first_join_date) BETWEEN 0 AND 30
            THEN o.booking_id
        END) AS orders_30d,

        COUNT(DISTINCT CASE
            WHEN DATEDIFF(o.order_created_at, c.first_join_date) BETWEEN 0 AND 90
            THEN o.booking_id
        END) AS orders_90d

    FROM customer_analysis c
    LEFT JOIN orders_clean o
        ON c.customer_id = o.customer_id
       AND o.payment_status = 'Success'
    WHERE c.valid_cohort_customer = 1
    GROUP BY c.customer_id, cohort_month
)

SELECT
    cohort_month,
    COUNT(*) AS cohort_users,

    SUM(CASE WHEN orders_30d >= 2 THEN 1 ELSE 0 END) AS repeat_users_30d,
    SUM(CASE WHEN orders_30d >= 2 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS repeat_rate_30d,

    SUM(CASE WHEN orders_90d >= 2 THEN 1 ELSE 0 END) AS repeat_users_90d,
    SUM(CASE WHEN orders_90d >= 2 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS repeat_rate_90d

FROM orders_in_window
GROUP BY cohort_month
ORDER BY cohort_month;

-- =========================================================
-- 2. Cohort Repeat - By Age Group
-- =========================================================

WITH orders_in_window AS (
    SELECT
        c.customer_id,
        DATE_FORMAT(c.first_join_date, '%Y-%m') AS cohort_month,
        c.join_age_group,

        COUNT(DISTINCT CASE
            WHEN DATEDIFF(o.order_created_at, c.first_join_date) BETWEEN 0 AND 30
            THEN o.booking_id
        END) AS orders_30d,

        COUNT(DISTINCT CASE
            WHEN DATEDIFF(o.order_created_at, c.first_join_date) BETWEEN 0 AND 90
            THEN o.booking_id
        END) AS orders_90d

    FROM customer_analysis c
    LEFT JOIN orders_clean o
        ON c.customer_id = o.customer_id
       AND o.payment_status = 'Success'
    WHERE c.valid_cohort_customer = 1
    GROUP BY c.customer_id, cohort_month, c.join_age_group
)

SELECT
    cohort_month,
    join_age_group,
    COUNT(*) AS cohort_users,

    SUM(CASE WHEN orders_30d >= 2 THEN 1 ELSE 0 END) AS repeat_users_30d,
    SUM(CASE WHEN orders_30d >= 2 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS repeat_rate_30d,

    SUM(CASE WHEN orders_90d >= 2 THEN 1 ELSE 0 END) AS repeat_users_90d,
    SUM(CASE WHEN orders_90d >= 2 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS repeat_rate_90d

FROM orders_in_window
GROUP BY cohort_month, join_age_group
ORDER BY cohort_month, join_age_group;

-- =========================================================
-- 3. Cohort Frequency - Overall
-- =========================================================

WITH orders_in_window AS (
    SELECT
        c.customer_id,
        DATE_FORMAT(c.first_join_date, '%Y-%m') AS cohort_month,

        COUNT(DISTINCT CASE
            WHEN DATEDIFF(o.order_created_at, c.first_join_date) BETWEEN 0 AND 30
            THEN o.booking_id
        END) AS orders_30d,

        COUNT(DISTINCT CASE
            WHEN DATEDIFF(o.order_created_at, c.first_join_date) BETWEEN 0 AND 90
            THEN o.booking_id
        END) AS orders_90d

    FROM customer_analysis c
    LEFT JOIN orders_clean o
        ON c.customer_id = o.customer_id
       AND o.payment_status = 'Success'
    WHERE c.valid_cohort_customer = 1
    GROUP BY c.customer_id, cohort_month
)

SELECT
    cohort_month,
    COUNT(*) AS cohort_users,

    SUM(orders_30d) AS total_orders_30d,
    AVG(orders_30d) AS avg_orders_30d,

    SUM(orders_90d) AS total_orders_90d,
    AVG(orders_90d) AS avg_orders_90d

FROM orders_in_window
GROUP BY cohort_month
ORDER BY cohort_month;

-- =========================================================
-- 4. Cohort Frequency - By Age Group
-- =========================================================

WITH orders_in_window AS (
    SELECT
        c.customer_id,
        DATE_FORMAT(c.first_join_date, '%Y-%m') AS cohort_month,
        c.join_age_group,

        COUNT(DISTINCT CASE
            WHEN DATEDIFF(o.order_created_at, c.first_join_date) BETWEEN 0 AND 30
            THEN o.booking_id
        END) AS orders_30d,

        COUNT(DISTINCT CASE
            WHEN DATEDIFF(o.order_created_at, c.first_join_date) BETWEEN 0 AND 90
            THEN o.booking_id
        END) AS orders_90d

    FROM customer_analysis c
    LEFT JOIN orders_clean o
        ON c.customer_id = o.customer_id
       AND o.payment_status = 'Success'
    WHERE c.valid_cohort_customer = 1
    GROUP BY c.customer_id, cohort_month, c.join_age_group
)

SELECT
    cohort_month,
    join_age_group,
    COUNT(*) AS cohort_users,

    SUM(orders_30d) AS total_orders_30d,
    AVG(orders_30d) AS avg_orders_30d,

    SUM(orders_90d) AS total_orders_90d,
    AVG(orders_90d) AS avg_orders_90d

FROM orders_in_window
GROUP BY cohort_month, join_age_group
ORDER BY cohort_month, join_age_group;