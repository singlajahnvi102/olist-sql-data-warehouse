/*
========================================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
========================================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to
    populate the 'silver' schema tables from the 'bronze' schema.
Actions Performed:
    - Truncates Silver tables.
    - Inserts transformed and cleansed data from Bronze into Silver tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
================================================================================
*/

exec silver.load_silver

CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN
    PRINT '>> Truncating Table:[Silver].[olist_customers_dataset]';
    TRUNCATE TABLE [Silver].[olist_customers_dataset];
    PRINT '>>Inserting Data Into:[Silver].[olist_customers_dataset]';
    INSERT INTO [Silver].[olist_customers_dataset] ([customer_id], [customer_unique_id], [customer_zip_code_prefix], [customer_city], [customer_state])
    SELECT customer_id,
           customer_unique_id,
           TRY_CAST ([customer_zip_code_prefix] AS INT),
           UPPER(LEFT(customer_city, 1)) + SUBSTRING(customer_city, 2, LEN(customer_city)),
           [customer_state]
    FROM   [bronze].[olist_customers_dataset];
    PRINT '>> Truncating Table:[Silver].[olist_orders_dataset]';
    TRUNCATE TABLE [Silver].[olist_orders_dataset];
    PRINT '>>Inserting Data Into:[Silver].[olist_orders_dataset]';
    INSERT INTO [Silver].[olist_orders_dataset] (order_id, customer_id, order_status, order_purchase_timestamp, order_approved_at, order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date, date_quality_status)
    SELECT order_id,
           customer_id,
           order_status,
           CAST (order_purchase_timestamp AS DATETIME),
           CAST (order_approved_at AS DATETIME),
           CAST (order_delivered_carrier_date AS DATETIME),
           CAST (order_delivered_customer_date AS DATETIME),
           CAST (order_estimated_delivery_date AS DATETIME),
           CASE WHEN order_approved_at > order_delivered_carrier_date THEN 'Invalid: approval after carrier' WHEN order_approved_at > order_delivered_customer_date THEN 'Invalid: approval after delivery' WHEN order_delivered_carrier_date > order_delivered_customer_date THEN 'Invalid: carrier after delivery' ELSE 'Valid' END AS date_quality_status
    FROM   [bronze].[olist_orders_dataset];
    
    
     PRINT '>> Truncating Table:[Silver].[olist_order_items_dataset]';
    TRUNCATE TABLE [Silver].[olist_order_items_dataset];
    PRINT '>>Inserting Data Into:[Silver].[olist_order_items_dataset]'
    INSERT INTO [Silver].[olist_order_items_dataset] (order_id, order_item_id, product_id, seller_id, shipping_limit_date, price, freight_value)
    SELECT order_id,
           order_item_id,
           product_id,
           seller_id,
           CAST (shipping_limit_date AS DATETIME),
           CAST (price AS DECIMAL (10, 2)),
           CAST (freight_value AS DECIMAL (10, 2))
    FROM   [bronze].[olist_order_items_dataset];
    PRINT '>> Truncating Table:[Silver].[olist_order_payments_dataset]';
    TRUNCATE TABLE [Silver].[olist_order_payments_dataset];
    PRINT '>>Inserting Data Into:[Silver].[olist_order_payments_dataset]';
    INSERT INTO [Silver].[olist_order_payments_dataset] (order_id, payment_sequential, payment_type, payment_installment, payment_value, payment_quality_status)
    SELECT order_id,
           CAST (payment_sequential AS INT),
           payment_type,
           CAST (payment_installment AS INT),
           CAST (payment_value AS DECIMAL (10, 2)),
           CASE WHEN payment_installment <= 0 THEN 'Invalid:installments <=0' WHEN payment_value <= 0 THEN 'Invalid:payment value<=0' ELSE 'valid' END AS payment_quality_status
    FROM   [bronze].[olist_order_payments_dataset];
    PRINT '>> Truncating Table:[Silver].[olist_products_dataset]';
    TRUNCATE TABLE [Silver].[olist_products_dataset];
    PRINT '>>Inserting Data Into:[Silver].[olist_products_dataset]';
    INSERT INTO [Silver].[olist_products_dataset] (product_id, product_category_name, product_name_lenght, product_description_lenght, product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm, weigh_quality_status)
    SELECT product_id,
           CASE WHEN product_category_name IS NULL THEN 'Unknown' ELSE product_category_name END AS product_category_name,
           product_name_lenght,
           product_description_lenght,
           product_photos_qty,
           product_weight_g,
           product_length_cm,
           product_height_cm,
           product_width_cm,
           CASE WHEN product_weight_g IS NULL THEN 'missing' WHEN product_weight_g = 0 THEN 'Invalid' ELSE 'valid' END AS weigh_quality_status
    FROM   [bronze].[olist_products_dataset];
    PRINT '>> Truncating Table:[Silver].[olist_sellers_dataset]';
    TRUNCATE TABLE [Silver].[olist_sellers_dataset];
    PRINT '>>Inserting Data Into:[Silver].[olist_sellers_dataset]';
    INSERT INTO [Silver].[olist_sellers_dataset] (seller_id, seller_zip_code_prefix, seller_city, seller_state)
    SELECT seller_id,
           seller_zip_code_prefix,
           seller_city,
           seller_state
    FROM   [bronze].[olist_sellers_dataset];
    PRINT '>> Truncating Table:[Silver].[olist_geolocation_dataset]';
    TRUNCATE TABLE [Silver].[olist_geolocation_dataset];
    PRINT '>>Inserting Data Into:[Silver].[olist_geolocation_dataset]';
    INSERT INTO [Silver].[olist_geolocation_dataset] (geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state)
    SELECT geolocation_zip_code_prefix,
           TRY_CAST (geolocation_lat AS DECIMAL (10, 7)),
           TRY_CAST (geolocation_lng AS DECIMAL (10, 7)),
           geolocation_city,
           geolocation_state
    FROM   [bronze].[olist_geolocation_dataset];
    PRINT '>> Truncating Table:[Silver].[product_category_name_translation]';
    TRUNCATE TABLE [Silver].[product_category_name_translation];
    PRINT '>>Inserting Data Into:[Silver].[product_category_name_translation]';
    INSERT INTO [silver].[product_category_name_translation] (product_category_name, product_category_name_english)
    (SELECT product_category_name,
            product_category_name_english
     FROM   [bronze].[product_category_name_translation]);
    PRINT '>> Truncating Table:[Silver].[ order_reviews]';
    TRUNCATE TABLE [Silver].[ order_reviews];
    PRINT '>>Inserting Data Into:[Silver].[ order_reviews]';
    INSERT INTO silver.order_reviews (review_id, order_id, review_score, review_comment_title, review_comment_message, review_creation_date, review_answer_timestamp)
    SELECT review_id,
           order_id,
           review_score,
           NULLIF (review_comment_title, '') AS review_comment_title,
           NULLIF (review_comment_message, '') AS review_comment_message,
           CAST (review_creation_date AS DATE),
           review_answer_timestamp
    FROM   bronze.order_reviews;
END
