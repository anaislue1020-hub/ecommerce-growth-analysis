/*
=========================================================
Validation Checks
Project: E-commerce Growth Analysis

Purpose:
Support statements in the report that certain segmentation
patterns are broadly consistent and therefore not presented
in the main analysis.

Validation scope:
- User growth mix by segment
- Order distribution consistency by segment
- Promotion usage by gender and device type
=========================================================
*/

USE 03ecommerce;

-- =========================================================
-- 1. User Growth Mix Checks
-- Used to validate whether growth patterns differ by segment
-- =========================================================

-- ---------------------------------------------------------
-- 1.1 Monthly user mix by age group
-- ---------------------------------------------------------

SELECT
    DATE_FORMAT(first_join_date, '%Y-%m') AS month,
    join_age_group,
    COUNT(*) AS new_users,
    COUNT(*) * 1.0 / SUM(COUNT(*)) OVER (
        PARTITION BY DATE_FORMAT(first_join_date, '%Y-%m')
    ) AS user_share
FROM customer_analysis
WHERE valid_cohort_customer = 1
GROUP BY month, join_age_group
ORDER BY month, join_age_group;

-- ---------------------------------------------------------
-- 1.2 Monthly user mix by gender
-- ---------------------------------------------------------

SELECT
    DATE_FORMAT(first_join_date, '%Y-%m') AS month,
    gender,
    COUNT(*) AS new_users,
    COUNT(*) * 1.0 / SUM(COUNT(*)) OVER (
        PARTITION BY DATE_FORMAT(first_join_date, '%Y-%m')
    ) AS user_share
FROM customer_analysis
WHERE valid_cohort_customer = 1
GROUP BY month, gender
ORDER BY month, gender;

-- ---------------------------------------------------------
-- 1.3 Monthly user mix by device type
-- ---------------------------------------------------------

SELECT
    DATE_FORMAT(first_join_date, '%Y-%m') AS month,
    device_type,
    COUNT(*) AS new_users,
    COUNT(*) * 1.0 / SUM(COUNT(*)) OVER (
        PARTITION BY DATE_FORMAT(first_join_date, '%Y-%m')
    ) AS user_share
FROM customer_analysis
WHERE valid_cohort_customer = 1
GROUP BY month, device_type
ORDER BY month, device_type;

-- =========================================================
-- 2. Order Distribution Consistency Checks
-- Used to validate that long-tail order distribution is
-- broadly similar across demographic segments
-- =========================================================

-- ---------------------------------------------------------
-- 2.1 Order distribution by age group
-- ---------------------------------------------------------

SELECT
    ca.join_age_group,
    CASE
        WHEN cm.total_orders = 1 THEN '1'
        WHEN cm.total_orders BETWEEN 2 AND 3 THEN '2-3'
        WHEN cm.total_orders BETWEEN 4 AND 10 THEN '4-10'
        WHEN cm.total_orders BETWEEN 11 AND 30 THEN '11-30'
        ELSE '31+'
    END AS order_bucket,
    COUNT(*) AS users,
    COUNT(*) * 1.0 / SUM(COUNT(*)) OVER (
        PARTITION BY ca.join_age_group
    ) AS user_share
FROM customer_metrics cm
JOIN customer_analysis ca
    ON cm.customer_id = ca.customer_id
WHERE ca.valid_behavior_customer = 1
GROUP BY ca.join_age_group, order_bucket
ORDER BY ca.join_age_group, order_bucket;

-- ---------------------------------------------------------
-- 2.2 Order distribution by gender
-- ---------------------------------------------------------

SELECT
    ca.gender,
    CASE
        WHEN cm.total_orders = 1 THEN '1'
        WHEN cm.total_orders BETWEEN 2 AND 3 THEN '2-3'
        WHEN cm.total_orders BETWEEN 4 AND 10 THEN '4-10'
        WHEN cm.total_orders BETWEEN 11 AND 30 THEN '11-30'
        ELSE '31+'
    END AS order_bucket,
    COUNT(*) AS users,
    COUNT(*) * 1.0 / SUM(COUNT(*)) OVER (
        PARTITION BY ca.gender
    ) AS user_share
FROM customer_metrics cm
JOIN customer_analysis ca
    ON cm.customer_id = ca.customer_id
WHERE ca.valid_behavior_customer = 1
GROUP BY ca.gender, order_bucket
ORDER BY ca.gender, order_bucket;

-- ---------------------------------------------------------
-- 2.3 Order distribution by device type
-- ---------------------------------------------------------

SELECT
    ca.device_type,
    CASE
        WHEN cm.total_orders = 1 THEN '1'
        WHEN cm.total_orders BETWEEN 2 AND 3 THEN '2-3'
        WHEN cm.total_orders BETWEEN 4 AND 10 THEN '4-10'
        WHEN cm.total_orders BETWEEN 11 AND 30 THEN '11-30'
        ELSE '31+'
    END AS order_bucket,
    COUNT(*) AS users,
    COUNT(*) * 1.0 / SUM(COUNT(*)) OVER (
        PARTITION BY ca.device_type
    ) AS user_share
FROM customer_metrics cm
JOIN customer_analysis ca
    ON cm.customer_id = ca.customer_id
WHERE ca.valid_behavior_customer = 1
GROUP BY ca.device_type, order_bucket
ORDER BY ca.device_type, order_bucket;

-- =========================================================
-- 3. Promotion Usage Validation
-- Used to confirm that gender and device patterns are
-- broadly consistent and not materially different
-- =========================================================

-- ---------------------------------------------------------
-- 3.1 Promotion usage by gender
-- ---------------------------------------------------------

SELECT
    ca.gender,
    SUM(cm.total_orders) AS total_orders,
    SUM(cm.promo_orders) AS promo_orders,
    SUM(cm.total_revenue) AS total_revenue,
    SUM(cm.total_promo_amount) AS total_promo_amount,

    ROUND(
        SUM(cm.promo_orders) * 1.0 / NULLIF(SUM(cm.total_orders), 0),
        4
    ) AS promo_order_rate,

    ROUND(
        SUM(cm.total_promo_amount) * 1.0
        / NULLIF(SUM(cm.total_revenue) + SUM(cm.total_promo_amount), 0),
        4
    ) AS discount_rate

FROM customer_metrics cm
JOIN customer_analysis ca
    ON cm.customer_id = ca.customer_id
WHERE ca.valid_behavior_customer = 1
GROUP BY ca.gender
ORDER BY ca.gender;

-- ---------------------------------------------------------
-- 3.2 Promotion usage by device type
-- ---------------------------------------------------------

SELECT
    ca.device_type,
    SUM(cm.total_orders) AS total_orders,
    SUM(cm.promo_orders) AS promo_orders,
    SUM(cm.total_revenue) AS total_revenue,
    SUM(cm.total_promo_amount) AS total_promo_amount,

    ROUND(
        SUM(cm.promo_orders) * 1.0 / NULLIF(SUM(cm.total_orders), 0),
        4
    ) AS promo_order_rate,

    ROUND(
        SUM(cm.total_promo_amount) * 1.0
        / NULLIF(SUM(cm.total_revenue) + SUM(cm.total_promo_amount), 0),
        4
    ) AS discount_rate

FROM customer_metrics cm
JOIN customer_analysis ca
    ON cm.customer_id = ca.customer_id
WHERE ca.valid_behavior_customer = 1
GROUP BY ca.device_type
ORDER BY ca.device_type;