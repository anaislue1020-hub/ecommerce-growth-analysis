/*
=========================================================
Data Cleaning & Validation
Project: E-commerce Growth Analysis

Purpose:
Validate the quality and consistency of the raw customer
and transaction tables before downstream analysis.

Validation scope:
- Primary key integrity
- Foreign key integrity
- Missing / invalid values
- Categorical consistency
- Date and timestamp validity
- Logical relationships across fields
=========================================================
*/

USE 03ecommerce;

-- =========================================================
-- 1. Customer Table
-- =========================================================

-- ---------------------------------------------------------
-- 1.1 Structure and Primary Key
-- ---------------------------------------------------------

-- Inspect schema
DESCRIBE customer;

-- Check row count, missing primary key, and duplicate customer_id
SELECT
    COUNT(*) AS total_rows,
    SUM(customer_id IS NULL) AS customer_id_null,
    COUNT(*) - COUNT(DISTINCT customer_id) AS duplicate_customer_id
FROM customer;

-- ---------------------------------------------------------
-- 1.2 Categorical Fields
-- ---------------------------------------------------------

-- Check value distribution for gender
SELECT
    gender,
    COUNT(*) AS cnt
FROM customer
GROUP BY gender
ORDER BY cnt DESC;

-- Check value distribution for device_type
SELECT
    device_type,
    COUNT(*) AS cnt
FROM customer
GROUP BY device_type
ORDER BY cnt DESC;

-- Check missing values in categorical fields
SELECT
    SUM(gender IS NULL OR gender = '' OR gender = '0') AS gender_missing,
    SUM(device_type IS NULL OR device_type = '' OR device_type = '0') AS device_type_missing
FROM customer;

-- ---------------------------------------------------------
-- 1.3 Date Fields
-- ---------------------------------------------------------

-- Check missing values and ranges for date fields
SELECT
    SUM(birthdate IS NULL) AS birthdate_null,
    MIN(birthdate) AS min_birthdate,
    MAX(birthdate) AS max_birthdate,
    SUM(first_join_date IS NULL) AS first_join_date_null,
    MIN(first_join_date) AS min_first_join_date,
    MAX(first_join_date) AS max_first_join_date
FROM customer;

-- Check logical consistency: first_join_date should be later than birthdate
SELECT
    COUNT(*) AS invalid_date_logic_rows
FROM customer
WHERE first_join_date < birthdate;

-- Optional: inspect problematic rows if any exist
SELECT *
FROM customer
WHERE first_join_date < birthdate;

-- =========================================================
-- 2. Transactions Table
-- =========================================================

-- ---------------------------------------------------------
-- 2.1 Structure and Primary Key
-- ---------------------------------------------------------

-- Inspect schema
DESCRIBE transactions;

-- Check row count, missing primary key, and duplicate booking_id
SELECT
    COUNT(*) AS total_rows,
    SUM(booking_id IS NULL OR booking_id = '' OR booking_id = '0') AS booking_id_missing,
    COUNT(*) - COUNT(DISTINCT booking_id) AS duplicate_booking_id
FROM transactions;

-- ---------------------------------------------------------
-- 2.2 Foreign Key Integrity and Identifiers
-- ---------------------------------------------------------

-- Check missing customer_id and session_id
SELECT
    SUM(customer_id IS NULL) AS customer_id_null,
    SUM(session_id IS NULL OR session_id = '') AS session_id_missing
FROM transactions;

-- Check whether all transaction customer_id values match the customer table
SELECT
    COUNT(*) AS unmatched_customer_id_rows
FROM transactions t
LEFT JOIN customer c
    ON t.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Optional: inspect unmatched customer_id values if any exist
SELECT
    t.customer_id
FROM transactions t
LEFT JOIN customer c
    ON t.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- ---------------------------------------------------------
-- 2.3 Timestamp Fields
-- ---------------------------------------------------------

-- Check missing values and raw ranges for timestamp fields
SELECT
    SUM(created_at IS NULL OR created_at = '' OR created_at = '0') AS created_at_missing,
    MIN(created_at) AS min_created_at,
    MAX(created_at) AS max_created_at,
    SUM(shipment_date_limit IS NULL OR shipment_date_limit = '' OR shipment_date_limit = '0') AS shipment_deadline_missing,
    MIN(shipment_date_limit) AS min_shipment_deadline,
    MAX(shipment_date_limit) AS max_shipment_deadline
FROM transactions;

-- Check timestamp format consistency
SELECT created_at
FROM transactions
WHERE created_at NOT LIKE '____-__-__T%Z';

SELECT shipment_date_limit
FROM transactions
WHERE shipment_date_limit NOT LIKE '____-__-__T%Z';

-- Test datetime parsing
SELECT
    created_at,
    STR_TO_DATE(SUBSTRING(created_at, 1, 19), '%Y-%m-%dT%H:%i:%s') AS parsed_created_at,
    shipment_date_limit,
    STR_TO_DATE(SUBSTRING(shipment_date_limit, 1, 19), '%Y-%m-%dT%H:%i:%s') AS parsed_shipment_deadline
FROM transactions
LIMIT 10;

-- Check logical consistency: shipment deadline should not be earlier than order creation time
SELECT
    COUNT(*) AS invalid_timestamp_logic_rows
FROM transactions
WHERE STR_TO_DATE(SUBSTRING(shipment_date_limit, 1, 19), '%Y-%m-%dT%H:%i:%s')
    <
      STR_TO_DATE(SUBSTRING(created_at, 1, 19), '%Y-%m-%dT%H:%i:%s');

-- Optional: inspect problematic rows if any exist
SELECT *
FROM transactions
WHERE STR_TO_DATE(SUBSTRING(shipment_date_limit, 1, 19), '%Y-%m-%dT%H:%i:%s')
    <
      STR_TO_DATE(SUBSTRING(created_at, 1, 19), '%Y-%m-%dT%H:%i:%s');

-- ---------------------------------------------------------
-- 2.4 Categorical Fields
-- ---------------------------------------------------------

-- Check payment_method distribution
SELECT
    payment_method,
    COUNT(*) AS cnt
FROM transactions
GROUP BY payment_method
ORDER BY cnt DESC;

-- Check payment_status distribution
SELECT
    payment_status,
    COUNT(*) AS cnt
FROM transactions
GROUP BY payment_status
ORDER BY cnt DESC;

-- Check missing values in categorical fields
SELECT
    SUM(payment_method IS NULL OR payment_method = '') AS payment_method_missing,
    SUM(payment_status IS NULL OR payment_status = '') AS payment_status_missing
FROM transactions;

-- ---------------------------------------------------------
-- 2.5 Monetary Fields
-- ---------------------------------------------------------

-- Check missing values in monetary fields
SELECT
    SUM(promo_amount IS NULL) AS promo_amount_null,
    SUM(shipment_fee IS NULL) AS shipment_fee_null,
    SUM(total_amount IS NULL) AS total_amount_null
FROM transactions;

-- Check negative values in monetary fields
SELECT
    COUNT(*) AS negative_value_rows
FROM transactions
WHERE promo_amount < 0
   OR shipment_fee < 0
   OR total_amount < 0;

-- Check value ranges
SELECT
    MIN(promo_amount) AS min_promo_amount,
    MAX(promo_amount) AS max_promo_amount,
    MIN(shipment_fee) AS min_shipment_fee,
    MAX(shipment_fee) AS max_shipment_fee,
    MIN(total_amount) AS min_total_amount,
    MAX(total_amount) AS max_total_amount
FROM transactions;

-- Optional: inspect rows with problematic monetary values
SELECT *
FROM transactions
WHERE promo_amount < 0
   OR shipment_fee < 0
   OR total_amount < 0
   OR promo_amount IS NULL
   OR shipment_fee IS NULL
   OR total_amount IS NULL;

-- ---------------------------------------------------------
-- 2.6 Semi-structured Field
-- ---------------------------------------------------------

-- Check whether product_metadata is populated
SELECT
    SUM(product_metadata IS NULL) AS product_metadata_null,
    SUM(product_metadata = '') AS product_metadata_empty,
    SUM(product_metadata = '0') AS product_metadata_zero
FROM transactions;

-- Inspect sample JSON content
SELECT product_metadata
FROM transactions
LIMIT 5;