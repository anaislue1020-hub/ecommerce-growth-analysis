/*
=========================================================
Cohort ARPU Analysis
Project: E-commerce Growth Analysis

Purpose:
- Measure cohort revenue contribution within 30-day and 90-day windows
- Calculate cohort ARPU using all cohort users as denominator
- Compare overall cohort ARPU and age-group differences

Scope:
- Users aged 16 and above only
- Successful orders only
- Monthly cohort output (used as base for quarterly reporting)
=========================================================
*/

USE 03ecommerce;

-- =========================================================
-- 1. Cohort ARPU - Overall
-- =========================================================

WITH revenue_window AS (
    SELECT
        c.customer_id,
        DATE_FORMAT(c.first_join_date, '%Y-%m') AS cohort_month,

        SUM(
            CASE
                WHEN o.payment_status = 'Success'
                 AND DATEDIFF(o.order_created_at, c.first_join_date) BETWEEN 0 AND 30
                THEN o.total_amount
                ELSE 0
            END
        ) AS revenue_30d,

        SUM(
            CASE
                WHEN o.payment_status = 'Success'
                 AND DATEDIFF(o.order_created_at, c.first_join_date) BETWEEN 0 AND 90
                THEN o.total_amount
                ELSE 0
            END
        ) AS revenue_90d

    FROM customer_analysis c
    LEFT JOIN orders_clean o
        ON c.customer_id = o.customer_id
    WHERE c.valid_cohort_customer = 1
    GROUP BY c.customer_id, cohort_month
)

SELECT
    cohort_month,
    COUNT(*) AS cohort_users,

    SUM(revenue_30d) AS total_revenue_30d,
    SUM(revenue_90d) AS total_revenue_90d,

    SUM(revenue_30d) * 1.0 / COUNT(*) AS arpu_30d,
    SUM(revenue_90d) * 1.0 / COUNT(*) AS arpu_90d

FROM revenue_window
GROUP BY cohort_month
ORDER BY cohort_month;

-- =========================================================
-- 2. Cohort ARPU - By Age Group
-- =========================================================

WITH revenue_window AS (
    SELECT
        c.customer_id,
        DATE_FORMAT(c.first_join_date, '%Y-%m') AS cohort_month,
        c.join_age_group,

        SUM(
            CASE
                WHEN o.payment_status = 'Success'
                 AND DATEDIFF(o.order_created_at, c.first_join_date) BETWEEN 0 AND 30
                THEN o.total_amount
                ELSE 0
            END
        ) AS revenue_30d,

        SUM(
            CASE
                WHEN o.payment_status = 'Success'
                 AND DATEDIFF(o.order_created_at, c.first_join_date) BETWEEN 0 AND 90
                THEN o.total_amount
                ELSE 0
            END
        ) AS revenue_90d

    FROM customer_analysis c
    LEFT JOIN orders_clean o
        ON c.customer_id = o.customer_id
    WHERE c.valid_cohort_customer = 1
    GROUP BY c.customer_id, cohort_month, c.join_age_group
)

SELECT
    cohort_month,
    join_age_group,
    COUNT(*) AS cohort_users,

    SUM(revenue_30d) AS total_revenue_30d,
    SUM(revenue_90d) AS total_revenue_90d,

    SUM(revenue_30d) * 1.0 / COUNT(*) AS arpu_30d,
    SUM(revenue_90d) * 1.0 / COUNT(*) AS arpu_90d

FROM revenue_window
GROUP BY cohort_month, join_age_group
ORDER BY cohort_month, join_age_group;