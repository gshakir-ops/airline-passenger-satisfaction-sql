-- 07 - Advanced SQL analysis | SQL Server / T-SQL
-- Trend analysis and CLV were intentionally removed: no date, revenue, or customer-history fields exist.

WITH scored AS (
 SELECT satisfaction,(CAST(Inflight_wifi_service AS FLOAT)+Seat_comfort+On_board_service+Leg_room_service+Online_boarding)/5.0 service_score
 FROM dbo.airline_satisfaction),
p AS (
 SELECT DISTINCT PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY service_score) OVER() q1,
 PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY service_score) OVER() median_score,
 PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY service_score) OVER() q3 FROM scored)
SELECT CASE WHEN s.service_score>=p.q3 THEN 'Top Quartile' WHEN s.service_score>=p.median_score THEN 'Upper Middle'
 WHEN s.service_score>=p.q1 THEN 'Lower Middle' ELSE 'Bottom Quartile' END service_quartile,
 COUNT(*) passenger_count,CAST(AVG(s.service_score) AS DECIMAL(6,3)) avg_service_score,
 CAST(100.0*SUM(CASE WHEN s.satisfaction='True' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(6,2)) satisfaction_rate_pct
FROM scored s CROSS JOIN p
GROUP BY CASE WHEN s.service_score>=p.q3 THEN 'Top Quartile' WHEN s.service_score>=p.median_score THEN 'Upper Middle'
 WHEN s.service_score>=p.q1 THEN 'Lower Middle' ELSE 'Bottom Quartile' END
ORDER BY MIN(s.service_score) DESC;

WITH segment_metrics AS (
 SELECT Customer_Type,Type_of_Travel,Class,COUNT(*) passenger_count,
 SUM(CASE WHEN satisfaction='True' THEN 1 ELSE 0 END) satisfied_count,
 CAST(100.0*SUM(CASE WHEN satisfaction='True' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(6,2)) satisfaction_rate_pct
 FROM dbo.airline_satisfaction GROUP BY Customer_Type,Type_of_Travel,Class HAVING COUNT(*)>=100)
SELECT *,RANK() OVER(ORDER BY satisfaction_rate_pct DESC) satisfaction_rank,
ROW_NUMBER() OVER(ORDER BY passenger_count DESC,satisfaction_rate_pct DESC) size_rank
FROM segment_metrics ORDER BY satisfaction_rank;

WITH class_metrics AS (
 SELECT Class,COUNT(*) passenger_count,CAST(100.0*SUM(CASE WHEN satisfaction='True' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(6,2)) satisfaction_rate_pct
 FROM dbo.airline_satisfaction GROUP BY Class)
SELECT Class,passenger_count,satisfaction_rate_pct,
CAST(AVG(satisfaction_rate_pct) OVER() AS DECIMAL(6,2)) avg_class_satisfaction,
CAST(satisfaction_rate_pct-AVG(satisfaction_rate_pct) OVER() AS DECIMAL(6,2)) difference_from_class_average
FROM class_metrics ORDER BY satisfaction_rate_pct DESC;

SELECT satisfaction,COUNT(*) passenger_count,
SUM(CASE WHEN Online_boarding IN(4,5) THEN 1 ELSE 0 END) high_online_boarding,
SUM(CASE WHEN Seat_comfort IN(4,5) THEN 1 ELSE 0 END) high_seat_comfort,
SUM(CASE WHEN Inflight_wifi_service IN(4,5) THEN 1 ELSE 0 END) high_wifi,
SUM(CASE WHEN On_board_service IN(4,5) THEN 1 ELSE 0 END) high_onboard_service
FROM dbo.airline_satisfaction GROUP BY satisfaction;

WITH segment_metrics AS (
 SELECT Type_of_Travel,Class,COUNT(*) passenger_count,
 CAST(100.0*SUM(CASE WHEN satisfaction='True' THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(6,2)) satisfaction_rate_pct,
 CAST(AVG(CAST(Departure_Delay_in_Minutes AS FLOAT)) AS DECIMAL(8,2)) avg_departure_delay,
 CAST(AVG(CAST(On_board_service AS FLOAT)) AS DECIMAL(6,3)) avg_onboard_service,
 CAST(AVG(CAST(Seat_comfort AS FLOAT)) AS DECIMAL(6,3)) avg_seat_comfort
 FROM dbo.airline_satisfaction GROUP BY Type_of_Travel,Class HAVING COUNT(*)>=100)
SELECT *,CAST(AVG(satisfaction_rate_pct) OVER(PARTITION BY Type_of_Travel) AS DECIMAL(6,2)) travel_type_avg,
CAST(satisfaction_rate_pct-AVG(satisfaction_rate_pct) OVER(PARTITION BY Type_of_Travel) AS DECIMAL(6,2)) vs_travel_type_avg
FROM segment_metrics ORDER BY satisfaction_rate_pct DESC;
