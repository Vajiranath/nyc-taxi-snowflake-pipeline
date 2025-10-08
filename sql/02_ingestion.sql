
USE WAREHOUSE TAXI_WH;
USE SCHEMA NYC_TAXI_DB.RAW;

-- Load data from the S3 stage into the staging table
COPY INTO STG_TRIPS
FROM @s3_taxi_trip_stage
ON_ERROR = 'SKIP_FILE';

-- Verify the load
SELECT COUNT(*) FROM STG_TRIPS;