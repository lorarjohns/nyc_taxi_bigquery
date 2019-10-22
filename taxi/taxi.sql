SELECT
CONCAT(
    'https://stackoverflow.com/questions/',
    CAST(id as STRING)) as url,
view_count
FROM `bigquery-public-data.stackoverflow.posts_questions`
WHERE tags like '%google-bigquery%'
ORDER BY view_count DESC


SELECT
    CAST(trip_distance AS FLOAT64) AS distance, CAST(total_amount AS FLOAT64) AS total
FROM `nyc_taxi.tlc_yellow_trips_2018`
ORDER BY trip_distance DESC
LIMIT 15;


SELECT
    CAST(trip_distance AS FLOAT64) AS distance, CAST(total_amount AS FLOAT64) AS total
FROM `nyc_taxi.tlc_yellow_trips_2018`
ORDER BY trip_distance ASC
LIMIT 15;

SELECT
    COUNT(CASE WHEN trip_distance < 1 THEN 1 ELSE NULL END) AS under_a_mile,
    COUNT(CASE WHEN trip_distance <= 0 THEN 1 ELSE NULL END) AS zero_distance_trips
FROM `nyc_taxi.tlc_yellow_trips_2018`;

SELECT
    CAST(trip_distance AS FLOAT64) AS distance, CAST(tip_amount AS FLOAT64) AS tip, 
    CAST(total_amount AS FLOAT64) AS total
FROM `nyc_taxi.tlc_yellow_trips_2018`
WHERE trip_distance < 1
ORDER BY trip_distance DESC;


SELECT
    CAST(trip_distance AS FLOAT64) AS distance, CAST(tip_amount AS FLOAT64) AS tip, 
    CAST(total_amount AS FLOAT64) AS total
FROM `nyc_taxi.tlc_yellow_trips_2018`
WHERE trip_distance < 1
ORDER BY total, tip DESC
LIMIT 500;
SELECT
    CAST(trip_distance AS FLOAT64) AS distance, ROUND(MIN(tip_amount),4) AS min_tip, ROUND(AVG(tip_amount),4) 
    AS avg_tip, ROUND(MAX(tip_amount),4) AS max_tip
FROM `nyc_taxi.tlc_yellow_trips_2018`
WHERE trip_distance = 0
GROUP BY trip_distance
ORDER BY trip_distance;
SELECT
    CAST(trip_distance AS FLOAT64) AS distance, ROUND(MIN(total_amount),4) AS min_fare, ROUND(AVG(total_amount),4) 
    AS avg_fare, ROUND(MAX(total_amount),4) AS max_fare
FROM `nyc_taxi.tlc_yellow_trips_2018`
WHERE trip_distance = 0
GROUP BY trip_distance
ORDER BY trip_distance;

SELECT *
FROM `nyc_taxi.tlc_yellow_trips_2018`
WHERE passenger_count = 0; 


SELECT DATETIME_DIFF(dropoff_datetime, pickup_datetime, MINUTE) AS trip_time
FROM `nyc_taxi.tlc_yellow_trips_2018`
ORDER BY trip_time;


SELECT
    trip_distance AS distance, total_amount AS total
FROM `nyc_taxi.tlc_yellow_trips_2018`
ORDER BY trip_distance DESC
LIMIT 5000;


SELECT total_amount, trip_distance
FROM `nyc_taxi.tlc_yellow_trips_2018`
WHERE total_amount BETWEEN 10000 AND 11000
;



SELECT (total_amount/trip_distance) AS dollars_per_mile, trip_distance, total_amount
FROM `nyc_taxi.tlc_yellow_trips_2018`
WHERE trip_distance > 0
ORDER BY dollars_per_mile DESC

SELECT 
  EXTRACT(MONTH FROM pickup_datetime) AS month,
  EXTRACT(DAY FROM pickup_datetime) AS day,
  EXTRACT(HOUR FROM pickup_datetime) AS hour,
  AVG(CAST(trip_distance AS FLOAT64)) AS avg_distance, AVG(CAST(fare_amount AS FLOAT64)) AS avg_fare, AVG(CAST(tip_amount AS FLOAT64)) AS avg_tip, AVG(CAST(total_amount AS FLOAT64)) AS avg_total, AVG(CAST(mta_tax AS FLOAT64)) AS avg_tax, AVG(CAST(tolls_amount AS FLOAT64)) AS avg_tolls
FROM `nyc-transit-256016.nyc_taxi.tlc_yellow_trips_2018`
WHERE trip_distance BETWEEN 1 AND 2000 AND total_amount > 0
GROUP BY month, day, hour
ORDER BY month, day, hour
;
SELECT 
  pickup_datetime, dropoff_datetime,
  CASE 
    WHEN rate_code = '2' THEN 'JFK'
    WHEN rate_code = '3' THEN 'Newark'
    WHEN rate_code = '4' THEN 'Nassau or Westchester' END AS airport_code,
    z1.zone_name AS pickup_zone, z2.zone_name AS dropoff_zone, dropoff_location_id, pickup_location_id, trip_distance, total_amount
FROM `nyc-transit-256016.nyc_taxi.tlc_yellow_trips_2018`
LEFT JOIN `nyc-transit-256016.nyc_taxi.taxi_zone_geom` z1
ON pickup_location_id = z1.zone_id
LEFT JOIN `nyc-transit-256016.nyc_taxi.taxi_zone_geom` z2
ON dropoff_location_id = z2.zone_id
WHERE trip_distance BETWEEN 1 AND 2000 AND total_amount > 0 AND rate_code IN ('2', '3', '4')
;

SELECT 
  EXTRACT(MONTH FROM pickup_datetime) AS month,
  EXTRACT(DAY FROM pickup_datetime) AS day,
  EXTRACT(HOUR FROM pickup_datetime) AS hour,
  STDDEV(trip_distance) AS STD_distance, STDDEV(fare_amount) AS STD_fare, STDDEV(tip_amount) AS STD_tip, STDDEV(total_amount) AS STD_total, STDDEV(mta_tax) AS STD_tax, STDDEV(tolls_amount) AS STD_tolls
FROM `nyc-transit-256016.nyc_taxi.tlc_yellow_trips_2018`
WHERE trip_distance BETWEEN 0 AND 2000 AND total_amount > 0
GROUP BY month, day, hour
ORDER BY month, day, hour
;

SELECT 
  EXTRACT(MONTH FROM pickup_datetime) AS month,
  EXTRACT(DAY FROM pickup_datetime) AS day,
  EXTRACT(HOUR FROM pickup_datetime) AS hour,
  CAST(trip_distance AS FLOAT64) AS distance, CAST(fare_amount AS FLOAT64) AS fare, CAST(tip_amount AS FLOAT64) AS avg_tip, CAST(total_amount AS FLOAT64) AS total, CAST(mta_tax AS FLOAT64) AS avg_tax, CAST(tolls_amount AS FLOAT64) AS tolls
FROM `nyc-transit-256016.nyc_taxi.tlc_yellow_trips_2018`
WHERE trip_distance BETWEEN 0 AND 2000 AND total_amount > 0
GROUP BY month, day, hour
ORDER BY month, day, hour
;
SELECT 
  EXTRACT(MONTH FROM pickup_datetime) AS month,
  EXTRACT(DAY FROM pickup_datetime) AS day,
  EXTRACT(HOUR FROM pickup_datetime) AS hour,
  pickup_location_id, z1.zone_name AS pickup_zone, dropoff_location_id, z2.zone_name AS dropoff_zone,
  AVG(CAST(trip_distance AS FLOAT64)) AS avg_distance, AVG(CAST(fare_amount AS FLOAT64)) AS avg_fare, AVG(CAST(tip_amount AS FLOAT64)) AS avg_tip, AVG(CAST(total_amount AS FLOAT64)) AS avg_total, AVG(CAST(mta_tax AS FLOAT64)) AS avg_tax, AVG(CAST(tolls_amount AS FLOAT64)) AS avg_tolls
FROM `nyc-transit-256016.nyc_taxi.tlc_yellow_trips_2018`
LEFT JOIN `nyc-transit-256016.nyc_taxi.taxi_zone_geom` z1
ON pickup_location_id = z1.zone_id
LEFT JOIN `nyc-transit-256016.nyc_taxi.taxi_zone_geom` z2
ON dropoff_location_id = z2.zone_id
WHERE trip_distance BETWEEN 0 AND 2000 AND total_amount > 0
GROUP BY month, day, hour, pickup_location_id, pickup_zone, dropoff_location_id, dropoff_zone
ORDER BY month, day, hour
;

WITH weekdays AS (SELECT ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'] AS dayarray),

trip_data AS (SELECT
   pickup_datetime, dropoff_datetime, dayarray[ORDINAL(EXTRACT(DAYOFWEEK FROM pickup_datetime))] AS day_of_week,
   trip_distance, total_amount, tip_amount, p.zone_id AS pickup_zone, d.zone_id AS dropoff_zone, p.borough AS pickup_borough, 
   d.borough AS dropoff_borough, p.zone_geom AS pickup_coord, d.zone_geom AS dropoff_coord, payment_type,
   pickup_location_id, dropoff_location_id, rate_code

FROM `nyc-transit-256016.nyc_taxi.tlc_yellow_trips_2018`, weekdays
JOIN `nyc-transit-256016.nyc_taxi.taxi_zone_geom` p
ON pickup_location_id = p.zone_id
JOIN  `nyc-transit-256016.nyc_taxi.taxi_zone_geom` d
ON dropoff_location_id = d.zone_id
WHERE total_amount BETWEEN 0 AND 10000)

SELECT * FROM trip_data;
WITH weekdays AS (SELECT ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'] AS dayarray),

trip_data AS (SELECT
   pickup_datetime, dropoff_datetime, dayarray[ORDINAL(EXTRACT(DAYOFWEEK FROM pickup_datetime))] AS day_of_week,
   trip_distance, total_amount, tip_amount, p.zone_id AS pickup_zone, d.zone_id AS dropoff_zone, p.borough AS pickup_borough, 
   d.borough AS dropoff_borough, p.zone_geom AS pickup_coord, d.zone_geom AS dropoff_coord, payment_type,
   pickup_location_id, dropoff_location_id, rate_code,
   CASE WHEN EXTRACT(DAYOFWEEK FROM pickup_datetime) IN (1,7) THEN 1 ELSE 0 END AS is_weekend,
   CASE WHEN p.zone_id = d.zone_id THEN 1 ELSE 0 END AS same_borough_trip

FROM `nyc-transit-256016.nyc_taxi.tlc_yellow_trips_2018`, weekdays
JOIN `nyc-transit-256016.nyc_taxi.taxi_zone_geom` p
ON pickup_location_id = p.zone_id
JOIN  `nyc-transit-256016.nyc_taxi.taxi_zone_geom` d
ON dropoff_location_id = d.zone_id
WHERE total_amount BETWEEN 0 AND 10000 AND trip_distance > 0)

SELECT * FROM trip_data
LIMIT 16000;


/** FEATURE ENGINEERING

Get the number of trips per hour per taxi zone 

Get airport codes **/

SELECT EXTRACT(MONTH FROM pickup_datetime) AS trip_month, EXTRACT(DAY FROM pickup_datetime) AS trip_day, 
EXTRACT(HOUR FROM pickup_datetime) as trip_hour, pickup_location_id, count(1) AS trip_per_hour
FROM `nyc_taxi.tlc_yellow_trips_2018`
GROUP BY pickup_location_id, trip_month, trip_day, trip_hour
ORDER BY trip_month, trip_day, trip_hour, trip_per_hour DESC;


--gets airport zone to name mapping
SELECT zone_id, zone_name
FROM `nyc-transit-256016.nyc_taxi.taxi_zone_geom` 
WHERE zone_name LIKE "%JFK%" OR zone_name LIKE "%Newark%" 
OR zone_name LIKE "%LaGuardia%";

--gets the airport trips
SELECT p.zone_name as pzone, d.zone_name as dzone, CASE WHEN rate_code in ('2', '3') 
OR pickup_location_id IN ("1", "132", "138") 
OR dropoff_location_id IN ("1", "132", "138") THEN 1 ELSE 0 END AS is_airport 
FROM `nyc-transit-256016.nyc_taxi.tlc_yellow_trips_2018` 
INNER JOIN `nyc-transit-256016.nyc_taxi.taxi_zone_geom` p
ON pickup_location_id = p.zone_id
INNER JOIN `nyc-transit-256016.nyc_taxi.taxi_zone_geom` d
ON dropoff_location_id = d.zone_id;

-- gets the overnight and rush trips
SELECT p.zone_name as pzone, d.zone_name as dzone, tip_amount,
CASE WHEN extra = 0.50 THEN '2'
WHEN extra = 1.0 THEN '1' ELSE '0' END AS is_peak

-- gets weekend 
SELECT CASE WHEN FORMAT_DATE('%A',DATE(pickup_datetime)) IN ('Saturday', 'Sunday') THEN '1' ELSE '0' END AS is_weekend
FROM `nyc_taxi.tlc_yellow_trips_2018`