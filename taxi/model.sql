CREATE OR REPLACE MODEL `nyc_taxi.tlc_yellow_trips_2018.tips_model`
   OPTIONS (
       model_type='linear_reg',
       input_label_cols=['tip_amount'],
       L2_REG=1,
       max_iteration=50 ) AS
       
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
 	     trip_distance > 1 AND fare_amount BETWEEN 0.01 AND 3000.0
 	     AND DATETIME_DIFF(dropoff_datetime, pickup_datetime, HOUR) > 0 -- Filters out all the stuff we don't want to train on
 	     AND passenger_count > 0
 	     AND tip_amount >= 0;
 	     
 	   
 /** https://www.oreilly.com/learning/repeatable-sampling-of-data-sets-in-bigquery-for-machine-learning 
AND ABS(HASH(tip_per_mile) % 10 < 8)) = dataset.TRAIN  
-- MOD(data,1000) to sample 1/1000th of the data, e.g.

to manually split up your data by tip_per_mile and get 
approximately 80% of the data set
HASH function returns the same value any time it is invoked 
on a specific column
to split on a different y_train, invoke that column's name.

for validation data: change the < 8 in the query above to == 8,
and for testing data, change it to == 9. This way, you get 10% of 
samples in validation and 10% in testing. **/