-- 02 - Customer and demographic analysis | SQL Server / T-SQL
SELECT Gender,COUNT(*) AS passenger_count,SUM(CASE WHEN satisfaction='True' THEN 1 ELSE 0 END) AS satisfied_count,
CAST(100.0*SUM(CASE WHEN satisfaction='True' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(6,2)) AS satisfaction_rate_pct
FROM dbo.airline_satisfaction GROUP BY Gender ORDER BY satisfaction_rate_pct DESC;

SELECT Customer_Type,COUNT(*) AS passenger_count,SUM(CASE WHEN satisfaction='True' THEN 1 ELSE 0 END) AS satisfied_count,
CAST(100.0*SUM(CASE WHEN satisfaction='True' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(6,2)) AS satisfaction_rate_pct
FROM dbo.airline_satisfaction GROUP BY Customer_Type ORDER BY satisfaction_rate_pct DESC;

WITH age_groups AS (
 SELECT CASE WHEN Age<20 THEN 'Under 20' WHEN Age<31 THEN '20-30' WHEN Age<41 THEN '31-40'
 WHEN Age<51 THEN '41-50' WHEN Age<61 THEN '51-60' ELSE '61+' END age_group,satisfaction
 FROM dbo.airline_satisfaction)
SELECT age_group,COUNT(*) passenger_count,SUM(CASE WHEN satisfaction='True' THEN 1 ELSE 0 END) satisfied_count,
CAST(100.0*SUM(CASE WHEN satisfaction='True' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(6,2)) satisfaction_rate_pct
FROM age_groups GROUP BY age_group ORDER BY CASE age_group WHEN 'Under 20' THEN 1 WHEN '20-30' THEN 2 WHEN '31-40' THEN 3 WHEN '41-50' THEN 4 WHEN '51-60' THEN 5 ELSE 6 END;

SELECT Customer_Type,Type_of_Travel,COUNT(*) passenger_count,
CAST(100.0*SUM(CASE WHEN satisfaction='True' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(6,2)) satisfaction_rate_pct
FROM dbo.airline_satisfaction GROUP BY Customer_Type,Type_of_Travel HAVING COUNT(*)>=50 ORDER BY satisfaction_rate_pct DESC;

SELECT Customer_Type,Gender,COUNT(*) passenger_count,
CAST(100.0*SUM(CASE WHEN satisfaction='True' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(6,2)) satisfaction_rate_pct
FROM dbo.airline_satisfaction GROUP BY Customer_Type,Gender ORDER BY Customer_Type,satisfaction_rate_pct DESC;
