
If object_id ('bronze.olist_geolocation_dataset','U') is not null
drop table bronze.olist_geolocation_dataset;
CREATE TABLE bronze.olist_geolocation_dataset (
    geolocation_zip_code_prefix NVARCHAR (50),
    geolocation_lat NVARCHAR (50),
    geolocation_lng NVARCHAR (50) ,
    geolocation_city NVARCHAR (50),
    geolocation_state NVARCHAR (50)
);

If object_id ('bronze.olist_order_items_dataset','U') is not null
drop table bronze.olist_order_items_dataset;
CREATE TABLE bronze.olist_order_items_dataset (
    order_id NVARCHAR (100),
    order_item_id INT,
    product_id NVARCHAR (100),
    seller_id NVARCHAR (100),
    shipping_limit_date DATETIME,
    price DECIMAL (10, 2),
    freight_value DECIMAL (10, 2)
);
If object_id ('bronze.olist_order_payments_dataset','U') is not null
drop table bronze.olist_order_payments_dataset;
CREATE TABLE bronze.olist_order_payments_dataset (
    order_id NVARCHAR (100),
    payment_sequential INT,
    payment_type NVARCHAR (50),
    payment_installment INT,
    payment_value DECIMAL (10, 2)
);

If object_id ('bronze.olist_orders_dataset','U') is not null
drop table bronze.olist_orders_dataset;
CREATE TABLE bronze.olist_orders_dataset (
    order_id NVARCHAR (100),
    customer_id NVARCHAR (100),
    order_status NVARCHAR (50),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);
If object_id ('bronze.olist_products_dataset','U') is not null
drop table bronze.olist_products_dataset;
CREATE TABLE bronze.olist_products_dataset (
    product_id NVARCHAR (100),
    product_category_name NVARCHAR (50),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);
If object_id ('bronze.olist_sellers_dataset','U') is not null
drop table bronze.olist_sellers_dataset;
CREATE TABLE bronze.olist_sellers_dataset (
    seller_id NVARCHAR (100),
    seller_zip_code_prefix NVARCHAR(100),
    seller_city NVARCHAR (50),
    seller_state NVARCHAR (50)
);
If object_id ('bronze.product_category_name_translation','U') is not null
drop table bronze.product_category_name_translation;
CREATE TABLE bronze.product_category_name_translation (
    product_category_name NVARCHAR (50),
    product_category_name_english NVARCHAR (50)
);
If object_id ('bronze.olist_customers_dataset','U') is not null
drop table bronze.olist_customers_dataset;
CREATE TABLE bronze.olist_customers_dataset (
    customer_id NVARCHAR (100),
    customer_unique_id NVARCHAR (100),
    customer_zip_code_prefix NVARCHAR (100),
    customer_city NVARCHAR (50),
    customer_state NVARCHAR (50)
);

