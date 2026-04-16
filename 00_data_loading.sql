/*
=========================================================
Data Loading Script
Project: E-commerce Growth Analysis
Description:
- Create raw tables
- Load CSV data into MySQL using LOAD DATA INFILE

Note:
- Replace file paths with your local directory
- LOCAL INFILE must be enabled
=========================================================
*/

USE 03ecommerce;

-- Enable LOCAL INFILE (may require admin privileges)
SET GLOBAL local_infile = 1;

-- =========================================================
-- 1. Customer Table
-- =========================================================

-- Drop existing table
DROP TABLE IF EXISTS customer;

-- Create raw customer table
CREATE TABLE customer (
    customer_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    username VARCHAR(100),
    email VARCHAR(150),
    gender CHAR(1),
    birthdate DATE,
    device_type VARCHAR(20),
    device_id VARCHAR(100),
    device_version VARCHAR(150),
    home_location_lat DECIMAL(10,8),
    home_location_long DECIMAL(11,8),
    home_location VARCHAR(100),
    home_country VARCHAR(100),
    first_join_date DATE
);

-- Load customer data
LOAD DATA LOCAL INFILE 
'C:/path/to/customer.csv'
INTO TABLE customer
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- =========================================================
-- 2. Transactions Table
-- =========================================================

DROP TABLE IF EXISTS transactions;

CREATE TABLE transactions (
    created_at VARCHAR(35),
    customer_id INT,
    booking_id VARCHAR(50),
    session_id VARCHAR(50),
    product_metadata TEXT,
    payment_method VARCHAR(50),
    payment_status VARCHAR(30),
    promo_amount INT,
    promo_code VARCHAR(100),
    shipment_fee INT,
    shipment_date_limit VARCHAR(35),
    shipment_location_lat DECIMAL(11,8),
    shipment_location_long DECIMAL(11,8),
    total_amount INT
);

-- Load transactions data
LOAD DATA LOCAL INFILE 
'C:/path/to/transactions.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    created_at,
    customer_id,
    booking_id,
    session_id,
    product_metadata,
    payment_method,
    payment_status,
    promo_amount,
    promo_code,
    shipment_fee,
    shipment_date_limit,
    shipment_location_lat,
    shipment_location_long,
    total_amount
);