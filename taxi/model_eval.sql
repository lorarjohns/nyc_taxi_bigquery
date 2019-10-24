SELECT * FROM
ML.EVALUATE(
  MODEL `nyc-transit-256016.nyc_taxi.tips_model_L1`,
  (
  SELECT
   	     --datetime info
 	     EXTRACT(MONTH FROM pickup_datetime) AS pickup_month,
 	     FORMAT_DATE('%A',DATE(pickup_datetime)) as weekday_name,
 	     EXTRACT(DAY FROM pickup_datetime) AS p_day,
 	     EXTRACT(HOUR FROM pickup_datetime) AS p_hour_of_day,
 	     EXTRACT(DAY FROM dropoff_datetime) AS d_day,
 	     EXTRACT(HOUR FROM dropoff_datetime) AS d_hour_of_day,

 	     --general ride info
 	     passenger_count,
 	     trip_distance,
 	     
		 --dollar info
 	     fare_amount,
 	     mta_tax,
 	     tolls_amount,
 	     
 	     --categorical variables
 	     payment_type,
 	     is_weekend,
 	     is_airport,
 	     is_peak,
 	     
 	     --geographical info
	     pickup_location_id,
 	     dropoff_location_id,
         tip_amount

 	   FROM
 	     `nyc-transit-256016.nyc_taxi._model_data_table`
 	   WHERE
 	     trip_distance > 0 AND fare_amount BETWEEN 0.01 AND 3000.0
 	     AND DATETIME_DIFF(dropoff_datetime, pickup_datetime, HOUR) > 0 -- Filters out all the stuff we don't want to train on
 	     AND passenger_count > 0
 	     AND tip_amount >= 0
 	     AND MOD(ABS(FARM_FINGERPRINT(CAST(pickup_datetime AS STRING))),10) < 8; -- 80 % training data

 	   )
    ) 
    
SELECT * FROM ML.TRAINING_INFO(MODEL `nyc-transit-256016.nyc_taxi.tips_model_L1`)

SELECT tip_amount, predicted_tip_amount
FROM ML.PREDICT(MODEL `nyc-transit-256016.nyc_taxi.tips_model_L1`, (
 	   SELECT
 	     --datetime info
 	     EXTRACT(MONTH FROM pickup_datetime) AS pickup_month,
 	     FORMAT_DATE('%A',DATE(pickup_datetime)) as weekday_name,
 	     EXTRACT(DAY FROM pickup_datetime) AS p_day,
 	     EXTRACT(HOUR FROM pickup_datetime) AS p_hour_of_day,
 	     EXTRACT(DAY FROM dropoff_datetime) AS d_day,
 	     EXTRACT(HOUR FROM dropoff_datetime) AS d_hour_of_day,

 	     --general ride info
 	     passenger_count,
 	     trip_distance,
 	     
		 --dollar info
 	     fare_amount,
 	     mta_tax,
 	     tolls_amount,
 	     
 	     --categorical variables
 	     payment_type,
 	     is_weekend,
 	     is_airport,
 	     is_peak,
 	     
 	     --geographical info
	     pickup_location_id,
 	     dropoff_location_id,
 	     tip_amount

 	   FROM
 	     `nyc-transit-256016.nyc_taxi._model_data_table` -- the table I created
 	   WHERE
 	     trip_distance > 0 AND fare_amount BETWEEN 0.01 AND 3000.0
 	     AND DATETIME_DIFF(dropoff_datetime, pickup_datetime, HOUR) > 0 -- Filters out all the stuff we don't want to train on
 	     AND passenger_count > 0
 	     AND tip_amount >= 0
 	     AND MOD(ABS(FARM_FINGERPRINT(CAST(pickup_datetime AS STRING))),10) >= 8
       )
      )
SELECT * FROM ML.EVALUATE(
  MODEL `nyc-transit-256016.nyc_taxi.tips_model_L1`,
  (
  SELECT
   	     --datetime info
 	     EXTRACT(MONTH FROM pickup_datetime) AS pickup_month,
 	     FORMAT_DATE('%A',DATE(pickup_datetime)) as weekday_name,
 	     EXTRACT(DAY FROM pickup_datetime) AS p_day,
 	     EXTRACT(HOUR FROM pickup_datetime) AS p_hour_of_day,
 	     EXTRACT(DAY FROM dropoff_datetime) AS d_day,
 	     EXTRACT(HOUR FROM dropoff_datetime) AS d_hour_of_day,

 	     --general ride info
 	     passenger_count,
 	     trip_distance,
 	     
		 --dollar info
 	     fare_amount,
 	     mta_tax,
 	     tolls_amount,
 	     
 	     --categorical variables
 	     payment_type,
 	     is_weekend,
 	     is_airport,
 	     is_peak,
 	     
 	     --geographical info
	     pickup_location_id,
 	     dropoff_location_id,
         tip_amount

 	   FROM
 	     `nyc-transit-256016.nyc_taxi._model_data_table`
 	   WHERE
 	     trip_distance > 0 AND fare_amount BETWEEN 0.01 AND 3000.0
 	     AND DATETIME_DIFF(dropoff_datetime, pickup_datetime, HOUR) > 0 -- Filters out all the stuff we don't want to train on
 	     AND passenger_count > 0
 	     AND tip_amount >= 0
 	     AND MOD(ABS(FARM_FINGERPRINT(CAST(pickup_datetime AS STRING))),10) >= 8 -- 20% holdout data

 	   )
    ) 