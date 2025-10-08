
USE WAREHOUSE TAXI_WH;
USE SCHEMA NYC_TAXI_DB.ANALYTICS;

-- Create Dimension: DIM_PAYMENT_TYPE
CREATE OR REPLACE TABLE DIM_PAYMENT_TYPE AS
SELECT
    payment_type AS payment_type_id,
    CASE
        WHEN payment_type = 1 THEN 'Credit card'
        WHEN payment_type = 2 THEN 'Cash'
        WHEN payment_type = 3 THEN 'No charge'
        WHEN payment_type = 4 THEN 'Dispute'
        WHEN payment_type = 5 THEN 'Unknown'
        WHEN payment_type = 6 THEN 'Voided trip'
        ELSE 'Other'
    END AS payment_type_name
FROM (SELECT DISTINCT payment_type FROM NYC_TAXI_DB.RAW.STG_TRIPS WHERE payment_type IS NOT NULL);

-- Create Dimension: DIM_RATE_CODE
CREATE OR REPLACE TABLE DIM_RATE_CODE AS
SELECT
    RatecodeID AS rate_code_id,
    CASE
        WHEN RatecodeID = 1 THEN 'Standard rate'
        WHEN RatecodeID = 2 THEN 'JFK'
        WHEN RatecodeID = 3 THEN 'Newark'
        WHEN RatecodeID = 4 THEN 'Nassau or Westchester'
        WHEN RatecodeID = 5 THEN 'Negotiated fare'
        WHEN RatecodeID = 6 THEN 'Group ride'
        ELSE 'Other'
    END AS rate_code_name
FROM (SELECT DISTINCT RatecodeID FROM NYC_TAXI_DB.RAW.STG_TRIPS WHERE RatecodeID IS NOT NULL);

-- Create Dimension: DIM_DATE (from pickup datetime)
CREATE OR REPLACE TABLE DIM_DATE AS
SELECT DISTINCT
    TO_DATE(lpep_pickup_datetime) AS date_id,
    YEAR(lpep_pickup_datetime) AS year,
    MONTH(lpep_pickup_datetime) AS month,
    DAY(lpep_pickup_datetime) AS day,
    DAYOFWEEK(lpep_pickup_datetime) AS day_of_week,
    HOUR(lpep_pickup_datetime) as hour_of_day
FROM NYC_TAXI_DB.RAW.STG_TRIPS
WHERE lpep_pickup_datetime IS NOT NULL;

-- Create Fact Table: FCT_TRIPS
CREATE OR REPLACE TABLE FCT_TRIPS (
    trip_id INT IDENTITY(1,1) PRIMARY KEY,
    vendor_id INT,
    pickup_datetime TIMESTAMP_NTZ,
    dropoff_datetime TIMESTAMP_NTZ,
    pickup_date_id DATE,
    rate_code_id INT,
    payment_type_id INT,
    pickup_location_id INT,
    dropoff_location_id INT,
    passenger_count INT,
    trip_distance FLOAT,
    fare_amount FLOAT,
    tip_amount FLOAT,
    tolls_amount FLOAT,
    total_amount FLOAT,
    congestion_surcharge FLOAT
);

-- Load data into the Fact Table
INSERT INTO FCT_TRIPS (
    vendor_id, 
	pickup_datetime, 
	dropoff_datetime, 
	pickup_date_id,
    rate_code_id, 
	payment_type_id, 
	pickup_location_id, 
	dropoff_location_id,
    passenger_count, 
	trip_distance, 
	fare_amount, 
	tip_amount, 
	tolls_amount,
    total_amount, 
	congestion_surcharge
)
SELECT
    st.VendorID, 
	st.lpep_pickup_datetime, 
	st.lpep_dropoff_datetime, 
	TO_DATE(st.lpep_pickup_datetime),
    st.RatecodeID, 
	st.payment_type, 
	st.PULocationID, 
	st.DOLocationID,
    st.passenger_count, 
	st.trip_distance, 
	st.fare_amount, 
	st.tip_amount, 
	st.tolls_amount,
    st.total_amount, 
	st.congestion_surcharge
FROM NYC_TAXI_DB.RAW.STG_TRIPS st
WHERE st.lpep_pickup_datetime IS NOT NULL 
AND st.RatecodeID IS NOT NULL 
AND st.payment_type IS NOT NULL;