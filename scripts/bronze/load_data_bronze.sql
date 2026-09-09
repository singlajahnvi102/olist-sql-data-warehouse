/*
================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
================================================================================

Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the 'BULK INSERT' command to load data from CSV files to bronze tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
================================================================================
*/


exec bronze.load_bronze

create or alter Procedure bronze.load_bronze as
Begin
Print'===========================================';
Print'Loading Bronze Layer';
Print'==========================================';

print'>> Truncating table: bronze.olist_geolocation_dataset'; 
Truncate Table bronze.olist_geolocation_dataset;
print'>> Inserting data into: bronze.olist_geolocation_dataset';
Bulk insert bronze.olist_geolocation_dataset
from 'C:\Users\singl\Downloads\Olist_dataset\olist_geolocation_dataset.csv'
with (FIRSTROW=2,FIELDTERMINATOR=',',
ROWTERMINATOR='0x0a',
TABLOCK);

print'>> Truncating table: [bronze].[olist_customers_dataset]'; 
Truncate Table [bronze].[olist_customers_dataset];

print'>> Inserting data into: [bronze].[olist_customers_dataset]';
Bulk insert [bronze].[olist_customers_dataset]
from 'C:\Users\singl\Downloads\Olist_dataset\olist_customers_dataset.csv'
with (FIRSTROW=2,FIELDTERMINATOR=',',
ROWTERMINATOR='0x0a',
TABLOCK);

print'>> Truncating table: [bronze].[olist_order_items_dataset]'; 
Truncate Table [bronze].[olist_order_items_dataset];

print'>> Inserting data into: [bronze].[olist_order_items_dataset]';
Bulk insert [bronze].[olist_order_items_dataset]
from 'C:\Users\singl\Downloads\Olist_dataset\olist_order_items_dataset.csv'
with (FIRSTROW=2,FIELDTERMINATOR=',',
ROWTERMINATOR='0x0a',
TABLOCK);

print'>> Truncating table: [bronze].[olist_sellers_dataset]';
Truncate Table [bronze].[olist_sellers_dataset];

print'>> Inserting data into: [bronze].[olist_sellers_dataset]';
Bulk insert [bronze].[olist_sellers_dataset]
from 'C:\Users\singl\Downloads\Olist_dataset\olist_sellers_dataset.csv'
with (FIRSTROW=2,FIELDTERMINATOR=',',
ROWTERMINATOR='0x0a',
TABLOCK);

print'>> Truncating table: [bronze].[olist_order_payments_dataset]';
Truncate Table [bronze].[olist_order_payments_dataset];

print'>> Inserting data into: [bronze].[olist_order_payments_dataset]';

Bulk insert [bronze].[olist_order_payments_dataset]
from 'C:\Users\singl\Downloads\Olist_dataset\olist_order_payments_dataset.csv'
with (FIRSTROW=2,FIELDTERMINATOR=',',
ROWTERMINATOR='0x0a',
TABLOCK);

print'>> Truncating table: [bronze].[olist_products_dataset]';
Truncate Table [bronze].[olist_products_dataset];

print'>> Inserting data into: [bronze].[olist_products_dataset]';
Bulk insert [bronze].[olist_products_dataset]
from 'C:\Users\singl\Downloads\Olist_dataset\olist_products_dataset.csv'
with (FIRSTROW=2,FIELDTERMINATOR=',',
ROWTERMINATOR='0x0a',
TABLOCK);

print'>> Truncating table: [bronze].[olist_orders_dataset]';
Truncate Table [bronze].[olist_orders_dataset];

print'>> Inserting data into: [bronze].[olist_orders_dataset]';
Bulk insert [bronze].[olist_orders_dataset]
from 'C:\Users\singl\Downloads\Olist_dataset\olist_orders_dataset.csv'
with (FIRSTROW=2,FIELDTERMINATOR=',',
ROWTERMINATOR='0x0a',
TABLOCK);

print'>> Truncating table: [bronze].[product_category_name_translation]';
Truncate Table [bronze].[product_category_name_translation];
print'>> Inserting data into: [bronze].[product_category_name_translation]';
Bulk insert [bronze].[product_category_name_translation]
from 'C:\Users\singl\Downloads\Olist_dataset\product_category_name_translation.csv'
with (FIRSTROW=2,FIELDTERMINATOR=',',
ROWTERMINATOR='0x0a',
TABLOCK);


END
