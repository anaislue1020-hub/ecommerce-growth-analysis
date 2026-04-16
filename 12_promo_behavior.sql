/*
=========================================================
Promotion Behavior Analysis
Project: E-commerce Growth Analysis

Purpose:
- Evaluate the role of promotions in purchase behavior
- Measure promotion usage across:
  1) Promotion coverage (Promo Order Rate)
  2) Discount intensity (Discount Rate)
- Analyze overall patterns, age-group differences, and time trends

Scope:
- Users aged 16 and above
- Users with at least one successful purchase
- Successful orders only
=========================================================
*/

USE 03ecommerce;

-- =========================================================
-- 1. Promotion Usage
-- =========================================================

-- ---------------------------------------------------------
-- 1.1 Overall Promotion Usage
-- ---------------------------------------------------------

SELECT
    SUM(cm.total_orders) AS total_orders,
    SUM(cm.promo_orders) AS promo_orders,

    SUM(cm.total_revenue) AS total_revenue,
    SUM(cm.total_promo_amount) AS total_promo_amount,

    -- Promotion coverage
    ROUND(
        SUM(cm.promo_orders) * 1.0 / NULLIF(SUM(cm.total_orders), 0),
        4
    ) AS promo_order_rate,

    -- Discount intensity
    ROUND(
        SUM(cm.total_promo_amount) * 1.0
        / NULLIF(SUM(cm.total_revenue) + SUM(cm.total_promo_amount), 0),
        4
    ) AS discount_rate

FROM customer_metrics cm
JOIN customer_analysis ca
    ON cm.customer_id = ca.customer_id
WHERE ca.valid_behavior_customer = 1;

-- ---------------------------------------------------------
-- 1.2 Promotion Usage by Age Group
-- ---------------------------------------------------------

SELECT
    ca.join_age_group,

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
GROUP BY ca.join_age_group
ORDER BY ca.join_age_group;

-- =========================================================
-- 2. Promotion Trend (Monthly Base)
-- =========================================================


SELECT
    DATE_FORMAT(o.order_created_at, '%Y-%m') AS month,

    COUNT(DISTINCT o.booking_id) AS total_orders,

    COUNT(DISTINCT CASE 
        WHEN o.promo_amount > 0 THEN o.booking_id 
    END) AS promo_orders,

    SUM(o.total_amount) AS total_revenue,
    SUM(o.promo_amount) AS total_promo_amount,

    -- Promotion coverage
    ROUND(
        COUNT(DISTINCT CASE 
            WHEN o.promo_amount > 0 THEN o.booking_id 
        END) * 1.0
        / COUNT(DISTINCT o.booking_id),
        4
    ) AS promo_order_rate,

    -- Discount intensity
    ROUND(
        SUM(o.promo_amount) * 1.0
        / (SUM(o.total_amount) + SUM(o.promo_amount)),
        4
    ) AS discount_rate

FROM orders_clean o
JOIN customer_analysis ca
    ON o.customer_id = ca.customer_id

WHERE 
    o.payment_status = 'Success'
    AND ca.valid_behavior_customer = 1

GROUP BY month
ORDER BY month;