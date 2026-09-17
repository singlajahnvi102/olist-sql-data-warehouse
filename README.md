# Olist E-Commerce SQL Data Warehouse

## 📌 Project Overview

In this project, I worked with the Olist Brazilian E-Commerce Public Dataset to build a SQL Server Data Warehouse. My goal was to understand how raw e-commerce data can be loaded, cleaned, validated, transformed, and organized into an analytical data model. I followed a Bronze → Silver → Gold architecture using SQL Server, T-SQL, and Python.

## 📊 Dataset

The Olist Brazilian E-Commerce Public Dataset contains around 100,000 orders and includes information about customers, orders, order items, payments, products, sellers, reviews, geolocation, and product category translations.

## 🏗️ Data Warehouse Architecture

The project follows a three-layer architecture:

Olist CSV Files → Bronze Layer → Silver Layer → Gold Layer

The Bronze layer is used for data ingestion, the Silver layer is used for cleaning and validation, and the Gold layer contains the final analytical data model.

## 🥉 Bronze Layer

I created Bronze tables for all the source datasets and loaded the CSV files into SQL Server using BULK INSERT. The Bronze tables include customers, orders, order items, payments, products, sellers, geolocation, product category translation, and order reviews.

I created the stored procedure `bronze.load_bronze` to truncate and reload the Bronze tables.

## 🐍 Python Preprocessing

While loading the Order Reviews dataset, I faced a problem where line breaks inside review comments were being interpreted as new records by SQL Server. I used Python and Pandas to preprocess the file. I removed duplicate review IDs, cleaned text fields, removed unwanted spaces, replaced embedded line breaks, restored NULL values, converted review scores to integers, parsed dates, and performed basic validation. The cleaned file was saved as `order_reviews_clean.csv` and then loaded into SQL Server.

## 🥈 Silver Layer

The Silver layer is where I performed data cleaning, validation, standardization, and data-type conversion. I created the stored procedure `silver.load_silver` to transform and load data from Bronze into Silver.

For the Customers table, I checked NULLs, duplicates, customer IDs, relationships, unwanted spaces, city values, ZIP codes, and relationships with Geolocation.

For the Orders table, I checked order ID uniqueness, customer relationships, order statuses, NULL dates, and invalid date sequences. I created `date_quality_status` to identify invalid date sequences such as approval occurring after carrier delivery or customer delivery.

For Order Items, I checked NULLs, relationships with Orders, Products and Sellers, price and freight values, shipping dates, and `(order_id, order_item_id)` uniqueness. The combination of `order_id + order_item_id` represents a unique order-item record.

For Payments, I checked order relationships, NULLs, repeated order IDs, payment types, payment values, installments, and payment sequence. I created `payment_quality_status` to identify invalid payment records.

For Products, I checked product ID uniqueness, categories, NULL values, product attributes, dimensions, and weight. Missing product categories were replaced with `Unknown`. I also created `weigh_quality_status` to identify missing or invalid product-weight values.

For Sellers, I checked seller ID uniqueness, NULLs, ZIP codes, city and state values, and data standardization.

For Geolocation, I checked repeated ZIP prefixes, NULL ZIP prefixes, latitude and longitude ranges, city and state values, and data standardization. Since ZIP prefixes are repeated, I kept Geolocation in Silver but did not force it into the final Gold model.

For Product Category Translation, I checked NULL values, duplicate categories, and Portuguese-English category consistency.

For Order Reviews, I checked review ID uniqueness, relationships with Orders, review scores, NULL values, review dates, and invalid date sequences. I also calculated `days_to_answer` for validation and analysis.

## 🥇 Gold Layer

The Gold layer contains analytical SQL views based on the cleaned Silver data. The final model contains `gold.fact_orders`, `gold.dim_customers`, `gold.dim_products`, and `gold.dim_sellers`.

The main fact table is at order-item grain, meaning one row represents one item within an order. The combination of `order_id + order_item_id` uniquely identifies an order-item record. The dimension views provide customer, product, and seller information, while the fact view contains order and order-item level information such as price and freight value.

## 🧪 Data Quality Testing

I created `scripts/tests/quality_checks_silver.sql` for Silver-layer data-quality testing. The checks cover NULL values, duplicate records, primary-key validation, relationship checks, unwanted spaces, data standardization, invalid dates, payment validation, product attribute validation, review-score validation, latitude and longitude validation, and order-item uniqueness.

## 📐 Project Documentation

I created separate documentation for the architecture and final data model:

- [Data Integration Model](docs/data_integration_model.png)
- [Data Flow Diagram](docs/data_flow.drawio.png)
- [Final Star Schema](docs/olist_star_schema_final.pdf)

## 🛠️ Tools Used

SQL Server | T-SQL | Python | Pandas | Draw.io | GitHub

## 📁 Repository Structure

olist-sql-data-warehouse/
├── README.md
├── docs/
│   ├── data_integration_model.png
│   ├── data_flow.drawio.png
│   └── olist_star_schema_final.pdf
└── scripts/
    ├── bronze/
    │   ├── bronze_table.sql
    │   └── load_data_bronze.sql
    ├── silver/
    │   ├── silver_table.sql
    │   ├── load_data_silver.sql
    │   └── intl_database.sql
    ├── gold/
    │   └── create_views.sql
    └── tests/
        └── quality_checks_silver.sql

## 📚 What I Learned

This project helped me understand how a data warehouse is built from raw data. I learned about Bronze, Silver and Gold architecture, SQL Server data ingestion, BULK INSERT, data cleaning and validation, stored procedures, primary and foreign keys, composite keys, fact and dimension tables, Star Schema, SQL data types and conversions, one-to-many relationships, Python and Pandas preprocessing, handling messy CSV files, data-quality testing, and data warehouse documentation.

One of the most useful parts of this project was dealing with real data-quality and ingestion problems instead of working with an already-clean dataset.

## 🚀 Future Improvements

In the future, I can extend this project by using the Gold layer for further business analysis and visualization. For now, the main focus of this project is:

Data Ingestion → Data Cleaning → Data Validation → Data Transformation → Analytical Data Modeling
