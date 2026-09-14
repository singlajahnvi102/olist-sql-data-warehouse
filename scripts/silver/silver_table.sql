/*
================================================================================
DDL Script: Create Silver Tables
================================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables
    if they already exist.
    Run this script to re-define the DDL structure of 'bronze' Tables
================================================================================
*/
IF object_id('silver.olist_geolocation_dataset', 'U') IS NOT NULL
    DROP TABLE silver.olist_geolocation_dataset;

CREATE TABLE silver.olist_geolocation_dataset (
    geolocation_zip_code_prefix NVARCHAR (50),
    geolocation_lat decimal(10,2),
    geolocation_lng decimal(10,2),
    geolocation_city NVARCHAR (50),
    geolocation_state NVARCHAR (50)
);

IF object_id('silver.olist_order_items_dataset', 'U') IS NOT NULL
    DROP TABLE silver.olist_order_items_dataset;

CREATE TABLE silver.olist_order_items_dataset (
    order_id NVARCHAR (100),
    order_item_id INT,
    product_id NVARCHAR (100),
    seller_id NVARCHAR (100),
    shipping_limit_date DATETIME,
    price DECIMAL (10, 2),
    freight_value DECIMAL (10, 2)
);

IF object_id('silver.olist_order_payments_dataset', 'U') IS NOT NULL
    DROP TABLE silver.olist_order_payments_dataset;

CREATE TABLE silver.olist_order_payments_dataset (
    order_id NVARCHAR (100),
    payment_sequential INT,
    payment_type NVARCHAR (50),
    payment_installment INT,
    payment_value DECIMAL (10, 2),payment_quality_status NVARCHAR(50)
);

IF object_id('silver.olist_orders_dataset', 'U') IS NOT NULL
    DROP TABLE silver.olist_orders_dataset;

CREATE TABLE silver.olist_orders_dataset (
    order_id NVARCHAR (50),
    customer_id NVARCHAR (50),
    order_status NVARCHAR (50),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,date_quality_status NVARCHAR(100)
);

IF object_id('silver.olist_products_dataset', 'U') IS NOT NULL
    DROP TABLE silver.olist_products_dataset;

CREATE TABLE silver.olist_products_dataset (
    product_id NVARCHAR (100),
    product_category_name NVARCHAR (50),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT,
    weigh_quality_status nvarchar(50)
);

IF object_id('silver.olist_sellers_dataset', 'U') IS NOT NULL
    DROP TABLE silver.olist_sellers_dataset;

CREATE TABLE silver.olist_sellers_dataset (
    seller_id NVARCHAR (100),
    seller_zip_code_prefix CHAR (5),
    seller_city NVARCHAR (50),
    seller_state NVARCHAR (50)
);

IF object_id('silver.product_category_name_translation', 'U') IS NOT NULL
    DROP TABLE silver.product_category_name_translation;

CREATE TABLE silver.product_category_name_translation (
    product_category_name NVARCHAR (50),
    product_category_name_english NVARCHAR (50)
);

IF object_id('silver.olist_customers_dataset', 'U') IS NOT NULL
    DROP TABLE silver.olist_customers_dataset;

CREATE TABLE silver.olist_customers_dataset (
    customer_id NVARCHAR (100),
    customer_unique_id NVARCHAR (100),
    customer_zip_code_prefix int,
    customer_city NVARCHAR (50),
    customer_state NVARCHAR (50)
);

IF object_id('silver.olist_order_reviews_dataset', 'U') IS NOT NULL
    DROP TABLE silver.olist_order_reviews_dataset;

CREATE TABLE silver.olist_order_reviews_dataset (
    review_id NVARCHAR (100),
    order_id NVARCHAR (100),
    review_score INT,
    review_comment_title NVARCHAR (100),
    review_comment_message NVARCHAR (MAX),
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);
IF object_id('silver.order_reviews', 'U') IS NOT NULL
    DROP TABLE silver.order_reviews
CREATE TABLE silver.order_reviews (
    review_id VARCHAR(50) NOT NULL,
    order_id VARCHAR(50) NOT NULL,
    review_score TINYINT,
    review_comment_title NVARCHAR(200),
    review_comment_message NVARCHAR(MAX),
    review_creation_date DATE,
    review_answer_timestamp DATETIME2
);
