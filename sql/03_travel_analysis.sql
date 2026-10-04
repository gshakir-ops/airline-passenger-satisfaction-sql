-- 03 - Travel and class analysis | SQL Server / T-SQL
SELECT Type_of_Travel,COUNT(*) passenger_count,SUM(CASE WHEN satisfaction='True' THEN 1 ELSE 0 END) satisfied_count,
CAST(100.0*SUM(CASE WHEN satisfaction='True' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(6,2)) satisfaction_rate_pct
FROM dbo.airline_satisfaction GROUP BY Type_of_Travel ORDER BY satisfaction_rate_pct DESC;

SELECT Class,COUNT(*) passenger_count,SUM(CASE WHEN satisfaction='True' THEN 1 ELSE 0 END) satisfied_count,
CAST(100.0*SUM(CASE WHEN satisfaction='True' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(6,2)) satisfaction_rate_pct
FROM dbo.airline_satisfaction GROUP BY Class ORDER BY satisfaction_rate_pct DESC;

SELECT Type_of_Travel,Class,COUNT(*) passenger_count,
CAST(100.0*SUM(CASE WHEN satisfaction='True' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(6,2)) satisfaction_rate_pct
FROM dbo.airline_satisfaction GROUP BY Type_of_Travel,Class HAVING COUNT(*)>=50 ORDER BY satisfaction_rate_pct DESC;

SELECT Customer_Type,Class,COUNT(*) passenger_count,
CAST(100.0*SUM(CASE WHEN satisfaction='True' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(6,2)) satisfaction_rate_pct
FROM dbo.airline_satisfaction GROUP BY Customer_Type,Class HAVING COUNT(*)>=50 ORDER BY satisfaction_rate_pct DESC;

WITH d AS (SELECT DISTINCT Flight_Distance FROM dbo.airline_satisfaction WHERE Flight_Distance IS NOT NULL)
SELECT MIN(Flight_Distance) min_distance,MAX(Flight_Distance) max_distance,
CAST(AVG(CAST(Flight_Distance AS FLOAT)) AS DECIMAL(10,2)) avg_distance,
CAST(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Flight_Distance) OVER() AS DECIMAL(10,2)) q1_distance,
CAST(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY Flight_Distance) OVER() AS DECIMAL(10,2)) median_distance,
CAST(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Flight_Distance) OVER() AS DECIMAL(10,2)) q3_distance
FROM dbo.airline_satisfaction WHERE Flight_Distance IS NOT NULL;

WITH d AS (
 SELECT CASE WHEN Flight_Distance<500 THEN 'Short' WHEN Flight_Distance<1500 THEN 'Medium' ELSE 'Long' END distance_category,satisfaction
 FROM dbo.airline_satisfaction)
SELECT distance_category,COUNT(*) passenger_count,
CAST(100.0*SUM(CASE WHEN satisfaction='True' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(6,2)) satisfaction_rate_pct
FROM d GROUP BY distance_category ORDER BY CASE distance_category WHEN 'Short' THEN 1 WHEN 'Medium' THEN 2 ELSE 3 END;
