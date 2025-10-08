-- =================================================================
-- Step 1: Foundational Snowflake Objects
-- =================================================================
USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE WAREHOUSE TAXI_WH
  WAREHOUSE_SIZE = 'X-SMALL' 
  AUTO_SUSPEND = 60 
  AUTO_RESUME = TRUE;

CREATE OR REPLACE DATABASE NYC_TAXI_DB;
CREATE OR REPLACE SCHEMA NYC_TAXI_DB.RAW;
CREATE OR REPLACE SCHEMA NYC_TAXI_DB.ANALYTICS;

-- =================================================================
-- Step 2: Create Storage Integration to connect to S3
-- =================================================================
-- This object securely connects Snowflake to your AWS S3 role.
CREATE OR REPLACE STORAGE INTEGRATION s3_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::641644805315:role/snowflake-access-role'
  STORAGE_ALLOWED_LOCATIONS = ('s3://nyc-taxi-data-proj/');


DESC INTEGRATION s3_integration;

-- =================================================================
-- Step 3: Create File Format, Stage, and Target Table
-- =================================================================
USE SCHEMA NYC_TAXI_DB.RAW;

CREATE OR REPLACE FILE FORMAT CSV_FILE_FORMAT
  TYPE = 'CSV'
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1
  NULL_IF = ('NULL', 'null')
  EMPTY_FIELD_AS_NULL = TRUE;

-- This external stage points to your S3 bucket using the integration
CREATE OR REPLACE STAGE s3_taxi_trip_stage
  STORAGE_INTEGRATION = s3_integration
  URL = 's3://nyc-taxi-data-proj/'
  FILE_FORMAT = CSV_FILE_FORMAT;

-- This is the target table for our raw data
CREATE OR REPLACE TABLE NYC_TAXI_DB.RAW.STG_TRIPS (
    VendorID INT, 
	lpep_pickup_datetime TIMESTAMP_NTZ, 
	lpep_dropoff_datetime TIMESTAMP_NTZ,
    store_and_fwd_flag VARCHAR(1), 
	RatecodeID INT, 
	PULocationID INT, 
	DOLocationID INT,
    passenger_count INT, 
	trip_distance FLOAT, 
	fare_amount FLOAT, 
	extra FLOAT, 
	mta_tax FLOAT,
    tip_amount FLOAT, 
	tolls_amount FLOAT, 
	ehail_fee FLOAT, 
	improvement_surcharge FLOAT,
    total_amount FLOAT, 
	payment_type INT, 
	trip_type INT, 
	congestion_surcharge FLOAT
);