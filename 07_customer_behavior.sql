/*
=========================================================
Customer Behavior Analysis
Project: E-commerce Growth Analysis

Purpose:
- Analyze post-conversion user behavior
- Examine order distribution and engagement structure
- Evaluate repeat behavior and purchase intensity

Scope:
- Users aged 16 and above
- Users with at least one successful purchase
=========================================================
*/

USE 03ecommerce;

-- =========================================================
-- 1. Order Distribution
-- =========================================================

-- ---------------------------------------------------------
-- 1.1 Distribution Overview (Long-tail)
-- ---------------------------------------------------------

SELECT
    cm.total_orders,
    COUNT(*) AS users
FROM customer_metrics cm
JOIN customer_analysis ca
    ON cm.customer_id = ca.customer_id
WHERE ca.valid_behavior_customer = 1
GROUP BY cm.total_orders
ORDER BY cm.total_orders;

-- ---------------------------------------------------------
-- 1.2 Order Bucketing (Engagement Stages)
-- ---------------------------------------------------------

SELECT
    CASE
        WHEN cm.total_orders = 1 THEN '1'
        WHEN cm.total_orders BETWEEN 2 AND 3 THEN '2-3'
        WHEN cm.total_orders BETWEEN 4 AND 10 THEN '4-10'
        WHEN cm.total_orders BETWEEN 11 AND 30 THEN '11-30'
        ELSE '31+'
    END AS order_bucket,
    COUNT(*) AS users,
    COUNT(*) * 1.0 / SUM(COUNT(*)) OVER () AS user_share
FROM customer_metrics cm
JOIN customer_analysis ca
    ON cm.customer_id = ca.customer_id
WHERE ca.valid_behavior_customer = 1
GROUP BY order_bucket
ORDER BY
    CASE order_bucket
        WHEN '1' THEN 1
        WHEN '2-3' THEN 2
        WHEN '4-10' THEN 3
        WHEN '11-30' THEN 4
        WHEN '31+' THEN 5
    END;

-- =========================================================
-- 2. Customer Engagement (Post-conversion)
-- =========================================================

-- ---------------------------------------------------------
-- 2.1 Overall Performance
-- ---------------------------------------------------------

SELECT 
    AVG(cm.repeat_purchase_flag) AS repeat_purchase_rate,
    AVG(cm.total_orders) AS avg_orders_per_user
FROM customer_metrics cm
JOIN customer_analysis ca
    ON cm.customer_id = ca.customer_id
WHERE ca.valid_behavior_customer = 1;

-- ---------------------------------------------------------
-- 2.2 Behavior by Age Group
-- ---------------------------------------------------------

SELECT 
    ca.join_age_group,
    AVG(cm.repeat_purchase_flag) AS repeat_purchase_rate,
    AVG(cm.total_orders) AS avg_orders_per_user
FROM customer_metrics cm
JOIN customer_analysis ca
    ON cm.customer_id = ca.customer_id
WHERE ca.valid_behavior_customer = 1
GROUP BY ca.join_age_group
ORDER BY ca.join_age_group;

-- ---------------------------------------------------------
-- 2.3 Behavior by Gender
-- ---------------------------------------------------------

SELECT 
    ca.gender,
    AVG(cm.repeat_purchase_flag) AS repeat_purchase_rate,
    AVG(cm.total_orders) AS avg_orders_per_user
FROM customer_metrics cm
JOIN customer_analysis ca
    ON cm.customer_id = ca.customer_id
WHERE ca.valid_behavior_customer = 1
GROUP BY ca.gender;

-- ---------------------------------------------------------
-- 2.4 Behavior by Device Type
-- ---------------------------------------------------------

SELECT 
    ca.device_type,
    AVG(cm.repeat_purchase_flag) AS repeat_purchase_rate,
    AVG(cm.total_orders) AS avg_orders_per_user
FROM customer_metrics cm
JOIN customer_analysis ca
    ON cm.customer_id = ca.customer_id
WHERE ca.valid_behavior_customer = 1
GROUP BY ca.device_type;