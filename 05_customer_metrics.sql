/*
=========================================================
Customer Metrics Table
Project: E-commerce Growth Analysis

Purpose:
- Aggregate user-level behavioral and revenue metrics
- Support frequency, retention, and monetization analysis

Metrics include:
- Order count (success / failed)
- Revenue
- Promotion usage
- Repeat purchase flag
=========================================================
*/

USE 03ecommerce;

-- =========================================================
-- 1. Customer Metrics Table
-- =========================================================

-- Drop existing table
DROP TABLE IF EXISTS customer_metrics;

-- Create customer metrics table
CREATE TABLE customer_metrics AS
SELECT
    customer_id,

    -- Order counts
    COUNT(DISTINCT CASE WHEN payment_status = 'Success' THEN booking_id END) AS total_orders,
    COUNT(DISTINCT CASE WHEN payment_status <> 'Success' THEN booking_id END) AS failed_orders,

    -- Revenue
    COALESCE(SUM(CASE WHEN payment_status = 'Success' THEN total_amount END), 0) AS total_revenue,

    -- First / last order date (success only)
    MIN(CASE WHEN payment_status = 'Success' THEN order_created_at END) AS first_order_date,
    MAX(CASE WHEN payment_status = 'Success' THEN order_created_at END) AS last_order_date,

    -- Promotion
    COUNT(DISTINCT CASE WHEN payment_status = 'Success' AND promo_amount > 0 THEN booking_id END) AS promo_orders,
    COALESCE(SUM(CASE WHEN payment_status = 'Success' THEN promo_amount END), 0) AS total_promo_amount,

    -- Repeat purchase flag
    CASE
        WHEN COUNT(DISTINCT CASE WHEN payment_status = 'Success' THEN booking_id END) > 1 THEN 1
        ELSE 0
    END AS repeat_purchase_flag

FROM orders_clean
GROUP BY customer_id;

-- =========================================================
-- 2. Validation
-- =========================================================

SELECT COUNT(*) AS total_rows FROM customer_metrics;

SELECT
    MIN(total_orders),
    MAX(total_orders),
    AVG(total_orders)
FROM customer_metrics;

SELECT
    MIN(total_revenue),
    MAX(total_revenue),
    AVG(total_revenue)
FROM customer_metrics;

SELECT
    repeat_purchase_flag,
    COUNT(*)
FROM customer_metrics
GROUP BY repeat_purchase_flag;