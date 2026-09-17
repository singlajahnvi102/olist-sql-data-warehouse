/*
========================================================================================
DDL Script: Create Gold Views
========================================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse.
    The Gold layer represents the final dimension and fact tables (star schema)

    Each view performs transformations and combines data from the Silver layer
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
========================================================================================
*/




---Create first view
IF object_id('gold.dim_products', 'v') IS NOT NULL
    DROP VIEW gold.dim_products;
GO
CREATE VIEW gold.dim_products
AS
SELECT p.product_id,
       p.product_category_name AS product_category,
       pc.product_category_name_english AS product_category_english,
       p.product_name_lenght,
       p.product_description_lenght,
       p.product_photos_qty,
       p.product_weight_g,
       p.product_length_cm,
       p.product_height_cm,
       p.product_width_cm,
       weigh_quality_status
FROM   [Silver].[olist_products_dataset] AS p
       LEFT OUTER JOIN
       silver.product_category_name_translation AS pc
       ON pc.product_category_name = p.product_category_name;
 
 ---Create second view
IF object_id('gold.dim_sellers', 'v') IS NOT NULL
    DROP VIEW gold.dim_sellers;
GO
CREATE VIEW gold.dim_sellers
AS
SELECT seller_id,
       seller_city,
       seller_state
FROM   silver.olist_sellers_dataset;

---Create third view
IF object_id('gold.dim_customers', 'v') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO
CREATE VIEW gold.dim_customers
AS
SELECT customer_id,
       customer_unique_id,
       customer_city,
       customer_state
FROM   silver.olist_customers_dataset;

---Create fourth view
if object_id('gold.fact_orders','v') is not null
drop view gold.fact_orders;
go
create view gold.fact_orders as

with payments_agg as (
    select 
        order_id, 
        SUM(payment_value) as payment_value, 
        MAX(payment_type) as payment_type,
        max(payment_quality_status) as payment_quality_status
    from silver.olist_order_payments_dataset
    group by order_id
),

reviews_agg as (
    select 
        order_id, 
        AVG(review_score) as review_score
    from silver.order_reviews
    group by order_id
)

select 
    o.order_id, 
    o.customer_id, 
    oi.seller_id, 
    oi.product_id, 
    o.order_status, 
    o.order_purchase_timestamp, 
    o.order_approved_at,
    o.order_delivered_carrier_date, 
    o.order_delivered_customer_date, 
    o.order_estimated_delivery_date,
    oi.price,
    oi.freight_value,
    p.payment_type,
    p.payment_value,
    p.payment_quality_status,
    r.review_score
from silver.olist_orders_dataset o
left join silver.olist_order_items_dataset oi
    on o.order_id = oi.order_id
left join payments_agg p
    on o.order_id = p.order_id
left join reviews_agg r
    on o.order_id = r.order_id;

    
