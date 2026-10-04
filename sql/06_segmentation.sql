-- 06 - Customer segmentation | SQL Server / T-SQL
WITH segments AS (
 SELECT Customer_Type,Type_of_Travel,Class,COUNT(*) passenger_count,SUM(CASE WHEN satisfaction='True' THEN 1 ELSE 0 END) satisfied_count
 FROM dbo.airline_satisfaction GROUP BY Customer_Type,Type_of_Travel,Class)
SELECT Customer_Type,Type_of_Travel,Class,passenger_count,satisfied_count,
CAST(100.0*satisfied_count/passenger_count AS DECIMAL(6,2)) satisfaction_rate_pct,
RANK() OVER(ORDER BY CAST(100.0*satisfied_count/passenger_count AS DECIMAL(6,2)) DESC) satisfaction_rank,
RANK() OVER(ORDER BY passenger_count DESC) size_rank
FROM segments WHERE passenger_count>=30 ORDER BY satisfaction_rank;

WITH segments AS (
 SELECT CASE WHEN Age<20 THEN 'Under 20' WHEN Age<31 THEN '20-30' WHEN Age<41 THEN '31-40' WHEN Age<51 THEN '41-50' WHEN Age<61 THEN '51-60' ELSE '61+' END age_group,
 Class,satisfaction FROM dbo.airline_satisfaction)
SELECT age_group,Class,COUNT(*) passenger_count,CAST(100.0*SUM(CASE WHEN satisfaction='True' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(6,2)) satisfaction_rate_pct
FROM segments GROUP BY age_group,Class HAVING COUNT(*)>=30 ORDER BY satisfaction_rate_pct DESC;

WITH scores AS (
 SELECT satisfaction,(CAST(Inflight_wifi_service AS FLOAT)+Seat_comfort+On_board_service+Leg_room_service+Online_boarding)/5.0 service_score
 FROM dbo.airline_satisfaction)
SELECT CASE WHEN service_score>=4 THEN 'High (4.0-5.0)' WHEN service_score>=3 THEN 'Medium (3.0-3.99)' WHEN service_score>=2 THEN 'Low (2.0-2.99)' ELSE 'Very Low (<2.0)' END service_score_band,
COUNT(*) passenger_count,CAST(100.0*SUM(CASE WHEN satisfaction='True' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(6,2)) satisfaction_rate_pct
FROM scores GROUP BY CASE WHEN service_score>=4 THEN 'High (4.0-5.0)' WHEN service_score>=3 THEN 'Medium (3.0-3.99)' WHEN service_score>=2 THEN 'Low (2.0-2.99)' ELSE 'Very Low (<2.0)' END
ORDER BY satisfaction_rate_pct DESC;

WITH segments AS (
 SELECT Customer_Type,Type_of_Travel,Class,COUNT(*) passenger_count,
 CAST(100.0*SUM(CASE WHEN satisfaction='True' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(6,2)) satisfaction_rate_pct
 FROM dbo.airline_satisfaction GROUP BY Customer_Type,Type_of_Travel,Class)
SELECT TOP (10) Customer_Type,Type_of_Travel,Class,passenger_count,satisfaction_rate_pct
FROM segments WHERE passenger_count>=100 ORDER BY satisfaction_rate_pct ASC,passenger_count DESC;

WITH segments AS (
 SELECT Customer_Type,Type_of_Travel,Class,COUNT(*) passenger_count,
 CAST(100.0*SUM(CASE WHEN satisfaction='True' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(6,2)) satisfaction_rate_pct
 FROM dbo.airline_satisfaction GROUP BY Customer_Type,Type_of_Travel,Class)
SELECT TOP (10) Customer_Type,Type_of_Travel,Class,passenger_count,satisfaction_rate_pct
FROM segments WHERE passenger_count>=100 ORDER BY satisfaction_rate_pct DESC,passenger_count DESC;
