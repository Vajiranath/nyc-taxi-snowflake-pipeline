
USE WAREHOUSE TAXI_WH;
USE SCHEMA NYC_TAXI_DB.ANALYTICS;

-- =================================================================
-- ANALYSIS QUERIES
-- =================================================================

-- Query 1: What is the average fare amount by payment type?

SELECT
    pt.payment_type_name,
    AVG(f.fare_amount) as average_fare_amount,
    SUM(f.total_amount) as total_revenue
FROM FCT_TRIPS f
JOIN DIM_PAYMENT_TYPE pt ON f.payment_type_id = pt.payment_type_id
GROUP BY 1
ORDER BY 2 DESC;


-- Query 2: What are the busiest hours of the day for taxi pickups?

SELECT
    d.hour_of_day,
    COUNT(f.trip_id) as number_of_trips
FROM FCT_TRIPS f
JOIN DIM_DATE d ON f.pickup_date_id = d.date_id
GROUP BY 1
ORDER BY 2 DESC;


-- Query 3: How does trip distance and revenue vary by rate code?

SELECT
    rc.rate_code_name,
    COUNT(f.trip_id) as number_of_trips,
    AVG(f.trip_distance) as average_trip_distance,
    SUM(f.total_amount) as total_revenue
FROM FCT_TRIPS f
JOIN DIM_RATE_CODE rc ON f.rate_code_id = rc.rate_code_id
GROUP BY 1
ORDER BY 4 DESC;


-- Query 4: What is the average tip amount for credit card payments?

SELECT
    pt.payment_type_name,
    AVG(f.tip_amount) as average_tip_amount
FROM FCT_TRIPS f
JOIN DIM_PAYMENT_TYPE pt ON f.payment_type_id = pt.payment_type_id
WHERE pt.payment_type_name = 'Credit card'
GROUP BY 1;