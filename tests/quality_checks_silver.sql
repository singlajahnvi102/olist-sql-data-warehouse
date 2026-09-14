/*
========================================================================================
Quality Checks
========================================================================================

Script Purpose:
    This script performs various quality checks for data consistency, accuracy,
    and standardization across the 'silver' schemas. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
========================================================================================
*/

--- Table 1 [silver].[olist_customers_dataset]

SELECT TOP (20) [customer_id]
      ,[customer_unique_id]
      ,[customer_zip_code_prefix]
      ,[customer_city]
      ,[customer_state]
  FROM [silver].[olist_customers_dataset]

  --- check for nulls or duplicates in primary key
  
  select [customer_id],count(*) from [silver].[olist_customers_dataset]
  group by [customer_id] 
  having count(*)>1 or [customer_id] is null;

  select [customer_unique_id],count(*) from [silver].[olist_customers_dataset]
  group by [customer_unique_id] 
  having count(*)>1 or [customer_unique_id] is null;

  ---check for unwanted spaces
  SELECT *
FROM silver.olist_customers_dataset
WHERE customer_id != TRIM(customer_id)
   OR customer_unique_id != TRIM(customer_unique_id)
   OR customer_city != TRIM(customer_city)
   OR customer_state != TRIM(customer_state);

  ---- Data Standardization & consistency

  select distinct customer_state,customer_city from silver.olist_customers_dataset;

  --Check zipcode relationship;
  select distinct [customer_zip_code_prefix] from silver.olist_customers_dataset
  where [customer_zip_code_prefix] not in (select geolocation_zip_code_prefix from [silver].[olist_geolocation_dataset]);

  ---check affected customer
  SELECT COUNT(*) AS affected_customer_records
FROM silver.olist_customers_dataset c
WHERE NOT EXISTS (
    SELECT 1
    FROM silver.olist_geolocation_dataset g
    WHERE g.geolocation_zip_code_prefix = c.customer_zip_code_prefix
);

---Table olist_order_dataset

--- check for nulls or duplicates in primary key
  
  select order_id,count(*) from [silver].[olist_orders_dataset]
  group by [order_id] 
  having count(*)>1 or [order_id] is null;


  select customer_id,count(*) from [silver].[olist_orders_dataset]
  group by [customer_id] 
  having count(*)>1 or [customer_id] is null;

  ---Check Relationship of order and customer table
SELECT DISTINCT o.customer_id
FROM silver.olist_orders_dataset o
WHERE NOT EXISTS (
    SELECT 1
    FROM silver.olist_customers_dataset c
    WHERE c.customer_id = o.customer_id
);

-- check unwanted spaces and data standardization

 SELECT order_status,customer_id,order_id
FROM silver.olist_orders_dataset
WHERE order_status != TRIM(order_status)
or customer_id!=TRIM(customer_id) or
order_id!=TRIM(order_id);

select distinct order_status from 
silver.olist_orders_dataset;

---check for invalid date
select count(*) as invalid_dates
from silver.olist_orders_dataset
where order_approved_at<order_purchase_timestamp;

select count(*) as invalid_dates,order_status
from silver.olist_orders_dataset
where order_approved_at>order_delivered_carrier_date
group by order_status;

select order_delivered_carrier_date,order_delivered_customer_date
from silver.olist_orders_dataset
where order_delivered_carrier_date>order_delivered_customer_date;


select order_approved_at,order_delivered_customer_date
from silver.olist_orders_dataset
where order_approved_at>order_delivered_customer_date;

---Check null dates

SELECT
    SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END) AS purchase_nulls,
    SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END) AS approved_nulls,
    SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) AS carrier_nulls,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS customer_delivery_nulls,
    SUM(CASE WHEN order_estimated_delivery_date IS NULL THEN 1 ELSE 0 END) AS estimated_delivery_nulls
FROM silver.olist_orders_dataset;


---Table 3 olist_order_items_dataset

--- check for nulls 
  
  select count(*) as null_order_item_id
  from [silver].[olist_order_items_dataset]
  where [order_id] is null;

  select count(*) as null_seller_id
  from [silver].[olist_order_items_dataset]
  where seller_id is null;

  select count(*) as null_product_id
  from [silver].[olist_order_items_dataset]
  where product_id is null;

  ---check relationship
  select distinct order_id from [silver].[olist_order_items_dataset]
  where order_id not in(select order_id from silver.olist_orders_dataset);

  select distinct seller_id from [silver].[olist_order_items_dataset]
  where seller_id not in(select seller_id from silver.olist_sellers_dataset);

  select distinct product_id from [silver].[olist_order_items_dataset]
  where order_id not in(select order_id from silver.olist_products_dataset);

  ---check order_id and order_item_id together have a unique value
  
  select order_id,order_item_id
  ,count(*) as cnt 
from silver.olist_order_items_dataset 
group by order_id,order_item_id
having count(*)>1;

select * from silver.olist_order_items_dataset;


---check null dates
select
count(*) as null_shipping_dates 
from [silver].[olist_order_items_dataset]
where shipping_limit_date is null ;

---Check Unwanted Spaces

  SELECT order_id,product_id,seller_id
FROM silver.olist_order_items_dataset
WHERE order_id != TRIM(order_id)
   OR product_id != TRIM(product_id)
   OR seller_id != TRIM(seller_id);

   ---check freight and price

   select freight_value,price
   from silver.olist_order_items_dataset
   where freight_value <=0 and price <=0;

   ---Table 4 [olist_order_payments_dataset]
---check relationship between order_id

select distinct order_id from [silver].[olist_order_payments_dataset]
  where order_id not in(select order_id from silver.olist_orders_dataset);

---check null values
select count(*) as null_order_ids from [silver].[olist_order_payments_dataset]
where order_id is null;

select count(*) as null_payment_sequential from [silver].[olist_order_payments_dataset]
where payment_sequential is null;

select count(*) as null_payment_installments from [silver].[olist_order_payments_dataset]
where payment_installment is null;

---Check data standardization

select distinct payment_type from [silver].[olist_order_payments_dataset];

---check payment_value

   select payment_type,payment_value,payment_installment
   from silver.olist_order_payments_dataset
   where payment_value <=0 ;

   select payment_installment,payment_type,payment_value
   from silver.olist_order_payments_dataset
   where payment_installment <=0 ;

select payment_installment,payment_type,payment_value
   from silver.olist_order_payments_dataset
   where payment_installment <=0 ;

select payment_sequential,payment_type,payment_value
   from silver.olist_order_payments_dataset
   where payment_sequential <=0 ;


---Next table olist_product_dataset
---check null values
 select [product_id],count(*) from [silver].[olist_products_dataset]
  group by [product_id] 
  having count(*)>1 or [product_id] is null;

  select count(*) from [silver].[olist_products_dataset]
  where [product_category_name] is null;

  select distinct [product_category_name] from [silver].[olist_products_dataset];
  select distinct [product_category_name] from [silver].[product_category_name_translation];
  ---check null values
  select sum(case when product_name_lenght is null then 1 else 0 end) as null_length,
  sum(case when product_description_lenght is null then 1 else 0 end) as null_product_description_length,
  sum(case when product_photos_qty is null then 1 else 0 end) as null_product_photos_qty,
  sum(case when product_weight_g is null then 1 else 0 end) as null_product_weight,
  sum(case when product_length_cm is null then 1 else 0 end) as null_product_length,
  sum(case when product_height_cm is null then 1 else 0 end) as null_product_height,
  sum(case when product_width_cm is null then 1 else 0 end) as null_product_width_cm from [silver].[olist_products_dataset]; 

  select count(*) from [silver].[olist_products_dataset] where product_name_lenght is null
  and product_description_lenght is null
  and product_photos_qty is null and  product_weight_g  is null;

  select product_category_name from [silver].[olist_products_dataset]
  where  product_description_lenght<=0;

  select product_category_name from [silver].[olist_products_dataset]
  where  product_photos_qty<=0;

  select product_category_name from [silver].[olist_products_dataset]
  where product_weight_g<=0;

  select product_category_name from [silver].[olist_products_dataset]
  where   product_height_cm <=0;

  select product_category_name from [silver].[olist_products_dataset]
  where  product_width_cm<=0;

  select product_category_name from [silver].[olist_products_dataset]
  where  product_name_lenght<=0;

   select product_category_name from [silver].[olist_products_dataset]
  where  product_name_lenght<=0;

  ---Table 6 [olist_sellers_dataset]
  select seller_id,count(*) from [silver].[olist_sellers_dataset]
  group by [seller_id] 
  having count(*)>1 or [seller_id] is null;

  select count(*) from [silver].[olist_sellers_dataset]
  where seller_zip_code_prefix<=0;

  ---check data standardization
  select distinct seller_city from [silver].[olist_sellers_dataset];


  select geolocation_zip_code_prefix,count(*) from [silver].[olist_geolocation_dataset]
  group by geolocation_zip_code_prefix
  having count(*)>1 or geolocation_zip_code_prefix is null;

  select count(*) from [silver].[olist_geolocation_dataset]
  where geolocation_zip_code_prefix is null;

  ---Check latitude value and longitude value
  select count(*) from [silver].[olist_geolocation_dataset]
  where TRY_CAST(geolocation_lat as decimal(10,7)) not between -90 and +90;

  select count(*) from [silver].[olist_geolocation_dataset]
  where try_cast(geolocation_lng as decimal(10,7)) not between -180 and 180;

   ---check data standardization
select distinct geolocation_city from [silver].[olist_geolocation_dataset];

select distinct geolocation_state from [silver].[olist_geolocation_dataset];

 ---check table  [silver].[product_category_name_translation]

 ---check data standardization
select count(*) from [silver].[product_category_name_translation]
where product_category_name is null;

SELECT product_category_name, COUNT(*)
FROM [silver].[product_category_name_translation]
GROUP BY product_category_name
HAVING COUNT(*) > 1;


SELECT product_category_name_english, COUNT(*)
FROM [silver].[product_category_name_translation]
GROUP BY product_category_name_english
HAVING COUNT(*) > 1;

---silver.order_reviews
---check primary key or null value
select review_id,count(*) from silver.order_reviews
group by review_id 
having count(*)>1 or review_id is null;

---check relationship

select distinct order_id from silver.order_reviews
where order_id not in (select order_id from  [silver].[olist_orders_dataset]);


---check review score
select count(*) from silver.order_reviews
where review_score<0 or review_score>5;

---check review_comment_title and review_comment_message
---Check unwanted Spaces
SELECT review_comment_title, review_comment_message from silver.order_reviews
where Trim(review_comment_title)!=review_comment_title and TRIM(review_comment_message)!=review_comment_message;


---review_creation_date and review_answer_timestamp

select sum (case when review_creation_date is null then 1 else 0 end) as null_creation_date,
 sum (case when review_answer_timestamp is null then 1 else 0 end) as null_answer_timestamp from silver.order_reviews;

 ---check invalid date
 select review_creation_date,review_answer_timestamp
 from silver.order_reviews
 where review_answer_timestamp<review_creation_date;


 ---check min and max
  select MIN(review_creation_date) as earliest_review,max(review_creation_date) as latest_review,
  min(review_creation_date) as earliest_review , max(review_creation_date) as latest_review from silver.order_reviews;

  --- days_to_answer
  select review_id,review_creation_date,review_answer_timestamp,datediff(DAY,review_creation_date,review_answer_timestamp) as days_to_answer
  from silver.order_reviews;
