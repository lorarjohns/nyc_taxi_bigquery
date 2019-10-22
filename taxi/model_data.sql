SELECT pickup_datetime, dropoff_datetime, 
       FORMAT_DATE('%A',DATE(pickup_datetime)) as weekday_name,
 	     EXTRACT(HOUR FROM pickup_datetime) AS p_hour_of_day,
 	     EXTRACT(DAY FROM pickup_datetime) AS p_day,
 	     EXTRACT(HOUR FROM dropoff_datetime) AS d_hour_of_day,
 	     EXTRACT(DAY FROM dropoff_datetime) AS d_day,
 	     EXTRACT(MONTH FROM pickup_datetime) AS pickup_month,
       
       passenger_count,
 	   trip_distance,
       
       fare_amount,
 	   mta_tax,
 	   tolls_amount,
       
       payment_type,
       CASE 
         WHEN FORMAT_DATE('%A',DATE(pickup_datetime)) IN ('Saturday', 'Sunday') 
         THEN '1' ELSE '0' END AS is_weekend,
       CASE 
         WHEN rate_code in ('2', '3') 
         OR pickup_location_id IN ("1", "132", "138") 
         OR dropoff_location_id IN ("1", "132", "138") 
         THEN 1 ELSE 0 END AS is_airport,
       CASE 
         WHEN extra = 0.50 THEN '2'
         WHEN extra = 1.0 THEN '1' ELSE '0' END AS is_peak,
         
	    pickup_location_id,
 	    dropoff_location_id,
 	    
 	    -- label
        tip_amount
      
FROM `nyc-transit-256016.nyc_taxi.tlc_yellow_trips_2018`
INNER JOIN `nyc-transit-256016.nyc_taxi.taxi_zone_geom` p
ON pickup_location_id = p.zone_id
INNER JOIN `nyc-transit-256016.nyc_taxi.taxi_zone_geom` d
ON dropoff_location_id = d.zone_id;