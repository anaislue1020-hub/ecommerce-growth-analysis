/*
=========================================================
Monetization Analysis
Project: E-commerce Growth Analysis

Purpose:
- Evaluate how user activity translates into economic value
- Analyze monetization from three perspectives:
  1) Purchase volume (users, orders, revenue)
  2) Order value (AOV)
  3) User value (ARPPU)
- Examine monetization trends over time

Scope:
- Users aged 16 and above
- Users with at least one successful purchase
- Successful orders only
=========================================================
*/

USE 03ecommerce;

-- =========================================================
-- 1. Purchase Volume (Users, Orders, Revenue)
-- =========================================================

-- ---------------------------------------------------------
-- 1.1 Overall Purchase Volume
-- ---------------------------------------------------------

SELECT
    COUNT(DISTINCT cm.customer_id) AS converted_users,
    SUM(cm.total_orders) AS orders,
    SUM(cm.total_revenue) AS total_revenue
FROM customer_metrics cm
JOIN customer_analysis ca
    ON cm.customer_id = ca.customer_id
WHERE ca.valid_behavior_customer = 1;

-- ---------------------------------------------------------
-- 1.2 Purchase Volume by Age Group
-- ---------------------------------------------------------

SELECT
    ca.join_age_group,
    COUNT(DISTINCT cm.customer_id) AS converted_users,
    SUM(cm.total_orders) AS orders,
    SUM(cm.total_revenue) AS total_revenue
FROM customer_metrics cm
JOIN customer_analysis ca
    ON cm.customer_id = ca.customer_id
WHERE ca.valid_behavior_customer = 1
GROUP BY ca.join_age_group
ORDER BY ca.join_age_group;

-- ---------------------------------------------------------
-- 1.3 Purchase Volume by Gender
-- ---------------------------------------------------------

SELECT
    ca.gender,
    COUNT(DISTINCT cm.customer_id) AS converted_users,
    SUM(cm.total_orders) AS orders,
    SUM(cm.total_revenue) AS total_revenue
FROM customer_metrics cm
JOIN customer_analysis ca
    ON cm.customer_id = ca.customer_id
WHERE ca.valid_behavior_customer = 1
GROUP BY ca.gender
ORDER BY ca.gender;

-- ---------------------------------------------------------
-- 1.4 Purchase Volume by Device Type
-- ---------------------------------------------------------

SELECT
    ca.device_type,
    COUNT(DISTINCT cm.customer_id) AS converted_users,
    SUM(cm.total_orders) AS orders,
    SUM(cm.total_revenue) AS total_revenue
FROM customer_metrics cm
JOIN customer_analysis ca
    ON cm.customer_id = ca.customer_id
WHERE ca.valid_behavior_customer = 1
GROUP BY ca.device_type
ORDER BY ca.device_type;

-- =========================================================
-- 2. AOV (Average Order Value)
-- =========================================================

-- ---------------------------------------------------------
-- 2.1 Overall AOV
-- ---------------------------------------------------------

SELECT
    ROUND(SUM(cm.total_revenue) * 1.0 / NULLIF(SUM(cm.total_orders), 0), 2) AS AOV
FROM customer_metrics cm
JOIN customer_analysis ca
    ON cm.customer_id = ca.customer_id
WHERE ca.valid_behavior_customer = 1;

-- ---------------------------------------------------------
-- 2.2 AOV by Age Group
-- ---------------------------------------------------------

SELECT
    ca.join_age_group,
    ROUND(SUM(cm.total_revenue) * 1.0 / NULLIF(SUM(cm.total_orders), 0), 2) AS AOV
FROM customer_metrics cm
JOIN customer_analysis ca
    ON cm.customer_id = ca.customer_id
WHERE ca.valid_behavior_customer = 1
GROUP BY ca.join_age_group
ORDER BY ca.join_age_group;

-- ---------------------------------------------------------
-- 2.3 AOV by Gender
-- ---------------------------------------------------------

SELECT
    ca.gender,
    ROUND(SUM(cm.total_revenue) * 1.0 / NULLIF(SUM(cm.total_orders), 0), 2) AS AOV
FROM customer_metrics cm
JOIN customer_analysis ca
    ON cm.customer_id = ca.customer_id
WHERE ca.valid_behavior_customer = 1
GROUP BY ca.gender
ORDER BY ca.gender;

-- ---------------------------------------------------------
-- 2.4 AOV by Device Type
-- ---------------------------------------------------------

SELECT
    ca.device_type,
    ROUND(SUM(cm.total_revenue) * 1.0 / NULLIF(SUM(cm.total_orders), 0), 2) AS AOV
FROM customer_metrics cm
JOIN customer_analysis ca
    ON cm.customer_id = ca.customer_id
WHERE ca.valid_behavior_customer = 1
GROUP BY ca.device_type
ORDER BY ca.device_type;

-- =========================================================
-- 3. ARPPU (Average Revenue per Paying User)
-- =========================================================

-- ---------------------------------------------------------
-- 3.1 Overall ARPPU
-- ---------------------------------------------------------

SELECT
    ROUND(SUM(cm.total_revenue) * 1.0 / COUNT(DISTINCT cm.customer_id), 2) AS ARPPU
FROM customer_metrics cm
JOIN customer_analysis ca
    ON cm.customer_id = ca.customer_id
WHERE ca.valid_behavior_customer = 1;

-- ---------------------------------------------------------
-- 3.2 ARPPU by Age Group
-- ---------------------------------------------------------

SELECT
    ca.join_age_group,
    ROUND(SUM(cm.total_revenue) * 1.0 / COUNT(DISTINCT cm.customer_id), 2) AS ARPPU
FROM customer_metrics cm
JOIN customer_analysis ca
    ON cm.customer_id = ca.customer_id
WHERE ca.valid_behavior_customer = 1
GROUP BY ca.join_age_group
ORDER BY ca.join_age_group;

-- ---------------------------------------------------------
-- 3.3 ARPPU by Gender
-- ---------------------------------------------------------

SELECT
    ca.gender,
    ROUND(SUM(cm.total_revenue) * 1.0 / COUNT(DISTINCT cm.customer_id), 2) AS ARPPU
FROM customer_metrics cm
JOIN customer_analysis ca
    ON cm.customer_id = ca.customer_id
WHERE ca.valid_behavior_customer = 1
GROUP BY ca.gender
ORDER BY ca.gender;

-- ---------------------------------------------------------
-- 3.4 ARPPU by Device Type
-- ---------------------------------------------------------

SELECT
    ca.device_type,
    ROUND(SUM(cm.total_revenue) * 1.0 / COUNT(DISTINCT cm.customer_id), 2) AS ARPPU
FROM customer_metrics cm
JOIN customer_analysis ca
    ON cm.customer_id = ca.customer_id
WHERE ca.valid_behavior_customer = 1
GROUP BY ca.device_type
ORDER BY ca.device_type;

-- =========================================================
-- 4. Monetization Trend (Monthly Base)
-- =========================================================

SELECT
    DATE_FORMAT(o.order_created_at, '%Y-%m') AS month,
    COUNT(DISTINCT o.customer_id) AS converted_users,
    COUNT(DISTINCT o.booking_id) AS orders,
    SUM(o.total_amount) AS total_revenue,
    ROUND(SUM(o.total_amount) * 1.0 / COUNT(DISTINCT o.booking_id), 2) AS AOV,
    ROUND(SUM(o.total_amount) * 1.0 / COUNT(DISTINCT o.customer_id), 2) AS ARPPU
FROM orders_clean o
JOIN customer_analysis ca
    ON o.customer_id = ca.customer_id
WHERE o.payment_status = 'Success'
  AND ca.valid_behavior_customer = 1
GROUP BY month
ORDER BY month;