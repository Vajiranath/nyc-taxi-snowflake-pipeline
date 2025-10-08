# Snowflake ELT Pipeline for NYC Taxi Data Analysis 🚕

This project demonstrates a complete and robust ELT (Extract, Load, Transform) pipeline built on **Snowflake**, ingesting data from **AWS S3**. It transforms raw NYC taxi trip data into a clean, analytics-ready **star schema** to enable efficient business intelligence and data analysis.

---
## 🏛️ Project Architecture

The pipeline follows a modern, multi-layered data architecture, ensuring a clear separation between raw and transformed data. This approach enhances scalability, data integrity, and re-processability.



1.  **External Data Stage (S3):** Raw CSV data is stored and managed in an AWS S3 bucket. A secure connection is established using a Snowflake **Storage Integration**, which allows Snowflake to read from the bucket without exposing credentials.
2.  **Staging Layer (Load):** A manual `COPY` command ingests the data from S3 into a raw staging table (`STG_TRIPS`) within a dedicated `RAW` schema. This table is a direct, unfiltered copy of the source data.
3.  **Analytics Layer (Transform):** A SQL script runs within Snowflake to clean, model, and transform the raw data into a dimensional model (star schema) in a separate `ANALYTICS` schema. This creates the final, business-ready tables.

---
## ⭐ Data Model: The Star Schema

The core of this project is a **dimensional model** (star schema), which is the industry standard for building fast and intuitive data warehouses for analytics. It consists of a central fact table containing quantitative measurements, surrounded by descriptive dimension tables that provide context.

### Schema Visualization

The diagram below illustrates the relationships between the fact and dimension tables, including their primary keys (PK) and foreign keys (FK).

```mermaid
erDiagram
    FCT_TRIPS {
        trip_id int PK "Trip Identifier"
        vendor_id int "TPEP provider code"
        pickup_datetime timestamp "Meter engagement time"
        dropoff_datetime timestamp "Meter disengagement time"
        pickup_date_id date FK "Foreign key to DIM_DATE"
        rate_code_id int FK "Foreign key to DIM_RATE_CODE"
        payment_type_id int FK "Foreign key to DIM_PAYMENT_TYPE"
        pickup_location_id int "TLC Taxi Zone ID for pickup"
        dropoff_location_id int "TLC Taxi Zone ID for dropoff"
        passenger_count int "Number of passengers"
        trip_distance float "Trip distance in miles"
        fare_amount float "Time-and-distance fare"
        tip_amount float "Tip for credit card payments"
        tolls_amount float "Total tolls paid"
        total_amount float "Total amount charged"
    }

    DIM_DATE {
        date_id date PK "Unique date identifier"
        year int "Year of pickup"
        month int "Month of pickup"
        day int "Day of pickup"
        day_of_week int "Day of the week"
        hour_of_day int "Hour of pickup"
    }

    DIM_PAYMENT_TYPE {
        payment_type_id int PK "Numeric code for payment type"
        payment_type_name varchar "Description (e.g., Credit card, Cash)"
    }

    DIM_RATE_CODE {
        rate_code_id int PK "Numeric code for the rate"
        rate_code_name varchar "Description (e.g., Standard rate, JFK)"
    }

    FCT_TRIPS ||--o{ DIM_DATE : "links to"
    FCT_TRIPS ||--o{ DIM_PAYMENT_TYPE : "links to"
    FCT_TRIPS ||--o{ DIM_RATE_CODE : "links to"
