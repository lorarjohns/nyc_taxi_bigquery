SELECT * FROM 
# Info 
ML.FEATURE_INFO(MODEL `nyc-transit-256016.nyc_taxi.tips_model`)
LEFT JOIN
# Model coefficients
ML.WEIGHTS(MODEL `nyc-transit-256016.nyc_taxi.tips_model`)
ON 
input = processed_input