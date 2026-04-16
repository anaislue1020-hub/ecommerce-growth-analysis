/*
=========================================================
Clean Tables Construction
Project: E-commerce Growth Analysis

Purpose:
- Create cleaned and standardized tables for downstream analysis
- Remove irrelevant fields and ensure consistent formats

Tables created:
- customer_clean
- orders_clean
=========================================================
*/

USE 03ecommerce;

-- =========================================================
-- 1. Customer Clean Table
-- =========================================================

-- Drop existing table
DROP TABLE IF EXISTS customer_clean;

-- Create cleaned customer table
CREATE TABLE customer_clean AS
SELECT
    customer_id,
    TRIM(gender) AS gender,
    birthdate,
    first_join_date,
    TRIM(device_type) AS device_type
FROM customer;

-- ---------------------------------------------------------
-- Validation: customer_clean
-- ---------------------------------------------------------

-- Check row count
SELECT COUNT(*) AS total_rows FROM customer_clean;

-- Check duplicate primary key
SELECT
    customer_id,
    COUNT(*) AS cnt
FROM customer_clean
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- =========================================================
-- 2. Orders Clean Table
-- =========================================================

-- Drop existing table
DROP TABLE IF EXISTS orders_clean;

-- Create cleaned orders table
CREATE TABLE orders_clean AS
SELECT
    booking_id,
    customer_id,
    session_id,

    -- Convert timestamp fields
    STR_TO_DATE(SUBSTRING(created_at, 1, 19), '%Y-%m-%dT%H:%i:%s') AS order_created_at,
    STR_TO_DATE(SUBSTRING(shipment_date_limit, 1, 19), '%Y-%m-%dT%H:%i:%s') AS shipment_deadline,

    -- Standardize categorical fields
    TRIM(payment_method) AS payment_method,
    TRIM(payment_status) AS payment_status,

    -- Monetary fields
    promo_amount,
    shipment_fee,
    total_amount

FROM transactions;

-- ---------------------------------------------------------
-- Validation: orders_clean
-- ---------------------------------------------------------

-- Check row count
SELECT COUNT(*) AS total_rows FROM orders_clean;

-- Check duplicate primary key
SELECT
    booking_id,
    COUNT(*) AS cnt
FROM orders_clean
GROUP BY booking_id
HAVING COUNT(*) > 1;