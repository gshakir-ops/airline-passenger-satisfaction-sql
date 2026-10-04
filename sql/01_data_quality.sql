-- 01 - Data quality audit | SQL Server / T-SQL
SELECT COUNT(*) AS total_rows FROM dbo.airline_satisfaction;

SELECT satisfaction, COUNT(*) AS passenger_count,
       CAST(100.0*COUNT(*)/SUM(COUNT(*)) OVER() AS DECIMAL(6,2)) AS pct_of_total
FROM dbo.airline_satisfaction GROUP BY satisfaction ORDER BY passenger_count DESC;

SELECT
 SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS gender_nulls,
 SUM(CASE WHEN Customer_Type IS NULL THEN 1 ELSE 0 END) AS customer_type_nulls,
 SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS age_nulls,
 SUM(CASE WHEN Type_of_Travel IS NULL THEN 1 ELSE 0 END) AS travel_type_nulls,
 SUM(CASE WHEN Class IS NULL THEN 1 ELSE 0 END) AS class_nulls,
 SUM(CASE WHEN Flight_Distance IS NULL THEN 1 ELSE 0 END) AS distance_nulls,
 SUM(CASE WHEN Departure_Delay_in_Minutes IS NULL THEN 1 ELSE 0 END) AS departure_delay_nulls,
 SUM(CASE WHEN Arrival_Delay_in_Minutes IS NULL THEN 1 ELSE 0 END) AS arrival_delay_nulls,
 SUM(CASE WHEN satisfaction IS NULL THEN 1 ELSE 0 END) AS satisfaction_nulls
FROM dbo.airline_satisfaction;

-- Exact duplicate-row audit across all 22 analytical columns.
SELECT COUNT(*) AS duplicate_groups,
       SUM(group_size-1) AS duplicate_rows_beyond_first
FROM (
 SELECT Gender,Customer_Type,Age,Type_of_Travel,Class,Flight_Distance,
 Inflight_wifi_service,Departure_Arrival_time_convenient,Ease_of_Online_booking,
 Gate_location,Food_and_drink,Online_boarding,Seat_comfort,Inflight_entertainment,
 On_board_service,Leg_room_service,Baggage_handling,Checkin_service,Cleanliness,
 Departure_Delay_in_Minutes,Arrival_Delay_in_Minutes,satisfaction,COUNT(*) AS group_size
 FROM dbo.airline_satisfaction
 GROUP BY Gender,Customer_Type,Age,Type_of_Travel,Class,Flight_Distance,
 Inflight_wifi_service,Departure_Arrival_time_convenient,Ease_of_Online_booking,
 Gate_location,Food_and_drink,Online_boarding,Seat_comfort,Inflight_entertainment,
 On_board_service,Leg_room_service,Baggage_handling,Checkin_service,Cleanliness,
 Departure_Delay_in_Minutes,Arrival_Delay_in_Minutes,satisfaction
 HAVING COUNT(*)>1
) d;

SELECT MIN(Age) AS min_age,MAX(Age) AS max_age,MIN(Flight_Distance) AS min_distance,
 MAX(Flight_Distance) AS max_distance,MIN(Departure_Delay_in_Minutes) AS min_departure_delay,
 MAX(Departure_Delay_in_Minutes) AS max_departure_delay,MIN(Arrival_Delay_in_Minutes) AS min_arrival_delay,
 MAX(Arrival_Delay_in_Minutes) AS max_arrival_delay
FROM dbo.airline_satisfaction;

SELECT * FROM dbo.airline_satisfaction
WHERE Inflight_wifi_service NOT BETWEEN 0 AND 5
 OR Departure_Arrival_time_convenient NOT BETWEEN 0 AND 5
 OR Ease_of_Online_booking NOT BETWEEN 0 AND 5 OR Gate_location NOT BETWEEN 0 AND 5
 OR Food_and_drink NOT BETWEEN 0 AND 5 OR Online_boarding NOT BETWEEN 0 AND 5
 OR Seat_comfort NOT BETWEEN 0 AND 5 OR Inflight_entertainment NOT BETWEEN 0 AND 5
 OR On_board_service NOT BETWEEN 0 AND 5 OR Leg_room_service NOT BETWEEN 0 AND 5
 OR Baggage_handling NOT BETWEEN 0 AND 5 OR Checkin_service NOT BETWEEN 0 AND 5
 OR Cleanliness NOT BETWEEN 0 AND 5;

-- Zero is retained as a distinct survey code; it is not converted to 1 or NULL.
SELECT
 SUM(CASE WHEN Inflight_wifi_service=0 THEN 1 ELSE 0 END) AS wifi_zero,
 SUM(CASE WHEN Departure_Arrival_time_convenient=0 THEN 1 ELSE 0 END) AS time_convenience_zero,
 SUM(CASE WHEN Ease_of_Online_booking=0 THEN 1 ELSE 0 END) AS online_booking_zero,
 SUM(CASE WHEN Gate_location=0 THEN 1 ELSE 0 END) AS gate_zero,
 SUM(CASE WHEN Food_and_drink=0 THEN 1 ELSE 0 END) AS food_zero,
 SUM(CASE WHEN Online_boarding=0 THEN 1 ELSE 0 END) AS online_boarding_zero,
 SUM(CASE WHEN Seat_comfort=0 THEN 1 ELSE 0 END) AS seat_zero,
 SUM(CASE WHEN Inflight_entertainment=0 THEN 1 ELSE 0 END) AS entertainment_zero,
 SUM(CASE WHEN On_board_service=0 THEN 1 ELSE 0 END) AS onboard_zero,
 SUM(CASE WHEN Leg_room_service=0 THEN 1 ELSE 0 END) AS legroom_zero,
 SUM(CASE WHEN Baggage_handling=0 THEN 1 ELSE 0 END) AS baggage_zero,
 SUM(CASE WHEN Checkin_service=0 THEN 1 ELSE 0 END) AS checkin_zero,
 SUM(CASE WHEN Cleanliness=0 THEN 1 ELSE 0 END) AS cleanliness_zero
FROM dbo.airline_satisfaction;
