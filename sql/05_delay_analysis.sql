-- 05 - Operational delay analysis | SQL Server / T-SQL
SELECT CAST(AVG(CAST(Departure_Delay_in_Minutes AS FLOAT)) AS DECIMAL(8,2)) avg_departure_delay,
CAST(AVG(CAST(Arrival_Delay_in_Minutes AS FLOAT)) AS DECIMAL(8,2)) avg_arrival_delay,
MAX(Departure_Delay_in_Minutes) max_departure_delay,MAX(Arrival_Delay_in_Minutes) max_arrival_delay,
SUM(CASE WHEN Departure_Delay_in_Minutes=0 THEN 1 ELSE 0 END) on_time_departures,
SUM(CASE WHEN Departure_Delay_in_Minutes>0 THEN 1 ELSE 0 END) delayed_departures
FROM dbo.airline_satisfaction;

SELECT CASE WHEN Departure_Delay_in_Minutes=0 THEN 'On Time' ELSE 'Delayed' END departure_status,
COUNT(*) passenger_count,CAST(100.0*SUM(CASE WHEN satisfaction='True' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(6,2)) satisfaction_rate_pct,
CAST(AVG(CAST(Departure_Delay_in_Minutes AS FLOAT)) AS DECIMAL(8,2)) avg_departure_delay
FROM dbo.airline_satisfaction GROUP BY CASE WHEN Departure_Delay_in_Minutes=0 THEN 'On Time' ELSE 'Delayed' END ORDER BY satisfaction_rate_pct DESC;

WITH bands AS (
 SELECT CASE WHEN Departure_Delay_in_Minutes=0 THEN '0 - On Time'
 WHEN Departure_Delay_in_Minutes BETWEEN 1 AND 15 THEN '1-15 min'
 WHEN Departure_Delay_in_Minutes BETWEEN 16 AND 60 THEN '16-60 min'
 WHEN Departure_Delay_in_Minutes BETWEEN 61 AND 120 THEN '61-120 min' ELSE '121+ min' END delay_band,satisfaction
 FROM dbo.airline_satisfaction)
SELECT delay_band,COUNT(*) passenger_count,CAST(100.0*SUM(CASE WHEN satisfaction='True' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(6,2)) satisfaction_rate_pct
FROM bands GROUP BY delay_band ORDER BY CASE delay_band WHEN '0 - On Time' THEN 1 WHEN '1-15 min' THEN 2 WHEN '16-60 min' THEN 3 WHEN '61-120 min' THEN 4 ELSE 5 END;

SELECT CASE WHEN Departure_Delay_in_Minutes>120 THEN 'Extreme Delay (>120 min)' ELSE 'Not Extreme' END delay_category,
COUNT(*) passenger_count,CAST(100.0*SUM(CASE WHEN satisfaction='True' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(6,2)) satisfaction_rate_pct
FROM dbo.airline_satisfaction GROUP BY CASE WHEN Departure_Delay_in_Minutes>120 THEN 'Extreme Delay (>120 min)' ELSE 'Not Extreme' END;

SELECT CASE WHEN Arrival_Delay_in_Minutes IS NULL THEN 'Missing Arrival Delay' ELSE 'Arrival Delay Recorded' END arrival_delay_status,
COUNT(*) passenger_count,CAST(100.0*SUM(CASE WHEN satisfaction='True' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(6,2)) satisfaction_rate_pct
FROM dbo.airline_satisfaction GROUP BY CASE WHEN Arrival_Delay_in_Minutes IS NULL THEN 'Missing Arrival Delay' ELSE 'Arrival Delay Recorded' END;
