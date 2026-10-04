-- ============================================================================
-- AIRLINE PASSENGER SATISFACTION ANALYSIS
-- Service Experience Analysis
-- ============================================================================
-- Purpose: Compare service ratings between satisfied and dissatisfied passengers
-- Identify which service factors are most associated with passenger satisfaction
-- ============================================================================

-- 1. SERVICE RATING COMPARISON - SATISFIED VS DISSATISFIED
-- Average ratings for key services by satisfaction outcome
SELECT
    satisfaction,
    COUNT(*) AS passenger_count,
    ROUND(AVG(CAST(Inflight_wifi_service AS FLOAT)), 2) AS avg_wifi,
    ROUND(AVG(CAST(Departure_Arrival_time_convenient AS FLOAT)), 2) AS avg_departure_arrival,
    ROUND(AVG(CAST(Ease_of_Online_booking AS FLOAT)), 2) AS avg_online_booking,
    ROUND(AVG(CAST(Gate_location AS FLOAT)), 2) AS avg_gate_location,
    ROUND(AVG(CAST(Food_and_drink AS FLOAT)), 2) AS avg_food_drink,
    ROUND(AVG(CAST(Online_boarding AS FLOAT)), 2) AS avg_online_boarding,
    ROUND(AVG(CAST(Seat_comfort AS FLOAT)), 2) AS avg_seat_comfort,
    ROUND(AVG(CAST(Inflight_entertainment AS FLOAT)), 2) AS avg_entertainment,
    ROUND(AVG(CAST(On_board_service AS FLOAT)), 2) AS avg_onboard_service,
    ROUND(AVG(CAST(Leg_room_service AS FLOAT)), 2) AS avg_legroom,
    ROUND(AVG(CAST(Baggage_handling AS FLOAT)), 2) AS avg_baggage,
    ROUND(AVG(CAST(Checkin_service AS FLOAT)), 2) AS avg_checkin,
    ROUND(AVG(CAST(Cleanliness AS FLOAT)), 2) AS avg_cleanliness
FROM airline_satisfaction
WHERE satisfaction IS NOT NULL
GROUP BY satisfaction;

-- ============================================================================

-- 2. SERVICE RATING DIFFERENCE ANALYSIS
-- Calculate the difference between satisfied and dissatisfied passenger ratings
-- Positive values indicate service is rated higher by satisfied passengers
WITH service_ratings AS (
    SELECT
        satisfaction,
        COUNT(*) AS count,
        AVG(CAST(Inflight_wifi_service AS FLOAT)) AS wifi,
        AVG(CAST(Departure_Arrival_time_convenient AS FLOAT)) AS dep_arr,
        AVG(CAST(Ease_of_Online_booking AS FLOAT)) AS booking,
        AVG(CAST(Gate_location AS FLOAT)) AS gate,
        AVG(CAST(Food_and_drink AS FLOAT)) AS food,
        AVG(CAST(Online_boarding AS FLOAT)) AS boarding,
        AVG(CAST(Seat_comfort AS FLOAT)) AS seat,
        AVG(CAST(Inflight_entertainment AS FLOAT)) AS entertainment,
        AVG(CAST(On_board_service AS FLOAT)) AS onboard,
        AVG(CAST(Leg_room_service AS FLOAT)) AS legroom,
        AVG(CAST(Baggage_handling AS FLOAT)) AS baggage,
        AVG(CAST(Checkin_service AS FLOAT)) AS checkin,
        AVG(CAST(Cleanliness AS FLOAT)) AS cleanliness
    FROM airline_satisfaction
    WHERE satisfaction IS NOT NULL
    GROUP BY satisfaction
)
SELECT
    'RATING DIFFERENCE (Satisfied - Dissatisfied)' AS analysis,
    ROUND((SELECT wifi FROM service_ratings WHERE satisfaction = 'True') -
          (SELECT wifi FROM service_ratings WHERE satisfaction = 'False'), 2) AS wifi_diff,
    ROUND((SELECT dep_arr FROM service_ratings WHERE satisfaction = 'True') -
          (SELECT dep_arr FROM service_ratings WHERE satisfaction = 'False'), 2) AS dep_arr_diff,
    ROUND((SELECT booking FROM service_ratings WHERE satisfaction = 'True') -
          (SELECT booking FROM service_ratings WHERE satisfaction = 'False'), 2) AS booking_diff,
    ROUND((SELECT gate FROM service_ratings WHERE satisfaction = 'True') -
          (SELECT gate FROM service_ratings WHERE satisfaction = 'False'), 2) AS gate_diff,
    ROUND((SELECT food FROM service_ratings WHERE satisfaction = 'True') -
          (SELECT food FROM service_ratings WHERE satisfaction = 'False'), 2) AS food_diff,
    ROUND((SELECT boarding FROM service_ratings WHERE satisfaction = 'True') -
          (SELECT boarding FROM service_ratings WHERE satisfaction = 'False'), 2) AS boarding_diff,
    ROUND((SELECT seat FROM service_ratings WHERE satisfaction = 'True') -
          (SELECT seat FROM service_ratings WHERE satisfaction = 'False'), 2) AS seat_diff,
    ROUND((SELECT entertainment FROM service_ratings WHERE satisfaction = 'True') -
          (SELECT entertainment FROM service_ratings WHERE satisfaction = 'False'), 2) AS entertainment_diff,
    ROUND((SELECT onboard FROM service_ratings WHERE satisfaction = 'True') -
          (SELECT onboard FROM service_ratings WHERE satisfaction = 'False'), 2) AS onboard_diff,
    ROUND((SELECT legroom FROM service_ratings WHERE satisfaction = 'True') -
          (SELECT legroom FROM service_ratings WHERE satisfaction = 'False'), 2) AS legroom_diff,
    ROUND((SELECT baggage FROM service_ratings WHERE satisfaction = 'True') -
          (SELECT baggage FROM service_ratings WHERE satisfaction = 'False'), 2) AS baggage_diff,
    ROUND((SELECT checkin FROM service_ratings WHERE satisfaction = 'True') -
          (SELECT checkin FROM service_ratings WHERE satisfaction = 'False'), 2) AS checkin_diff,
    ROUND((SELECT cleanliness FROM service_ratings WHERE satisfaction = 'True') -
          (SELECT cleanliness FROM service_ratings WHERE satisfaction = 'False'), 2) AS cleanliness_diff;

-- ============================================================================

-- 3. INDIVIDUAL SERVICE RATING ANALYSIS - WIFI SERVICE
-- Deep dive on inflight wifi satisfaction impact
SELECT
    'Inflight WiFi Service' AS service_name,
    Inflight_wifi_service AS rating,
    COUNT(*) AS passenger_count,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied,
    SUM(CASE WHEN satisfaction = 'False' THEN 1 ELSE 0 END) AS dissatisfied,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM airline_satisfaction
WHERE Inflight_wifi_service IS NOT NULL AND satisfaction IS NOT NULL
GROUP BY Inflight_wifi_service
ORDER BY Inflight_wifi_service;

-- ============================================================================

-- 4. INDIVIDUAL SERVICE RATING ANALYSIS - SEAT COMFORT
SELECT
    'Seat Comfort' AS service_name,
    Seat_comfort AS rating,
    COUNT(*) AS passenger_count,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied,
    SUM(CASE WHEN satisfaction = 'False' THEN 1 ELSE 0 END) AS dissatisfied,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM airline_satisfaction
WHERE Seat_comfort IS NOT NULL AND satisfaction IS NOT NULL
GROUP BY Seat_comfort
ORDER BY Seat_comfort;

-- ============================================================================

-- 5. INDIVIDUAL SERVICE RATING ANALYSIS - ON-BOARD SERVICE
SELECT
    'On-Board Service' AS service_name,
    On_board_service AS rating,
    COUNT(*) AS passenger_count,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied,
    SUM(CASE WHEN satisfaction = 'False' THEN 1 ELSE 0 END) AS dissatisfied,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM airline_satisfaction
WHERE On_board_service IS NOT NULL AND satisfaction IS NOT NULL
GROUP BY On_board_service
ORDER BY On_board_service;

-- ============================================================================

-- 6. INDIVIDUAL SERVICE RATING ANALYSIS - LEG ROOM SERVICE
SELECT
    'Leg Room Service' AS service_name,
    Leg_room_service AS rating,
    COUNT(*) AS passenger_count,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied,
    SUM(CASE WHEN satisfaction = 'False' THEN 1 ELSE 0 END) AS dissatisfied,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM airline_satisfaction
WHERE Leg_room_service IS NOT NULL AND satisfaction IS NOT NULL
GROUP BY Leg_room_service
ORDER BY Leg_room_service;

-- ============================================================================

-- 7. INDIVIDUAL SERVICE RATING ANALYSIS - FOOD AND DRINK
SELECT
    'Food and Drink' AS service_name,
    Food_and_drink AS rating,
    COUNT(*) AS passenger_count,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied,
    SUM(CASE WHEN satisfaction = 'False' THEN 1 ELSE 0 END) AS dissatisfied,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM airline_satisfaction
WHERE Food_and_drink IS NOT NULL AND satisfaction IS NOT NULL
GROUP BY Food_and_drink
ORDER BY Food_and_drink;

-- ============================================================================

-- 8. ZERO RATING INVESTIGATION
-- Analyze passengers who gave zero ratings on key services
-- This helps understand if zero means "not applicable" or "extremely dissatisfied"
SELECT
    'ZERO RATING ANALYSIS' AS analysis_type,
    COUNT(*) AS passengers_with_any_zero,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    SUM(CASE WHEN satisfaction = 'False' THEN 1 ELSE 0 END) AS dissatisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct_for_zero_raters
FROM airline_satisfaction
WHERE Inflight_wifi_service = 0
   OR Departure_Arrival_time_convenient = 0
   OR Ease_of_Online_booking = 0
   OR Gate_location = 0
   OR Food_and_drink = 0
   OR Online_boarding = 0
   OR Seat_comfort = 0
   OR Inflight_entertainment = 0
   OR On_board_service = 0
   OR Leg_room_service = 0
   OR Baggage_handling = 0
   OR Checkin_service = 0
   OR Cleanliness = 0;

-- ============================================================================

-- 9. HIGH RATING SATISFACTION CORRELATION
-- Passengers who gave ratings 4-5 on multiple services vs others
WITH high_raters AS (
    SELECT
        *,
        (CASE WHEN Inflight_wifi_service IN (4, 5) THEN 1 ELSE 0 END +
         CASE WHEN Seat_comfort IN (4, 5) THEN 1 ELSE 0 END +
         CASE WHEN On_board_service IN (4, 5) THEN 1 ELSE 0 END +
         CASE WHEN Leg_room_service IN (4, 5) THEN 1 ELSE 0 END +
         CASE WHEN Food_and_drink IN (4, 5) THEN 1 ELSE 0 END) AS high_ratings_count
    FROM airline_satisfaction
)
SELECT
    CASE
        WHEN high_ratings_count >= 4 THEN '4-5 High Ratings'
        WHEN high_ratings_count = 3 THEN '3 High Ratings'
        WHEN high_ratings_count = 2 THEN '2 High Ratings'
        WHEN high_ratings_count = 1 THEN '1 High Rating'
        ELSE '0 High Ratings'
    END AS high_rating_category,
    COUNT(*) AS passenger_count,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM high_raters
GROUP BY high_rating_category
ORDER BY
    CASE
        WHEN high_rating_category = '4-5 High Ratings' THEN 1
        WHEN high_rating_category = '3 High Ratings' THEN 2
        WHEN high_rating_category = '2 High Ratings' THEN 3
        WHEN high_rating_category = '1 High Rating' THEN 4
        ELSE 5
    END;

-- ============================================================================

-- 10. CLEANLINESS AND SERVICE QUALITY CORRELATION
-- Cleanliness as a proxy for overall service quality
SELECT
    Cleanliness AS cleanliness_rating,
    COUNT(*) AS passenger_count,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct,
    ROUND(AVG(CAST(On_board_service AS FLOAT)), 2) AS avg_onboard_service,
    ROUND(AVG(CAST(Seat_comfort AS FLOAT)), 2) AS avg_seat_comfort
FROM airline_satisfaction
WHERE Cleanliness IS NOT NULL AND satisfaction IS NOT NULL
GROUP BY Cleanliness
ORDER BY Cleanliness DESC;

-- ============================================================================

-- 11. SERVICE QUALITY BY CUSTOMER TYPE AND CLASS
-- Identify if service quality perception differs by segment
SELECT
    Customer_Type,
    Class,
    COUNT(*) AS passenger_count,
    ROUND(AVG(CAST(Seat_comfort AS FLOAT)), 2) AS avg_seat_comfort,
    ROUND(AVG(CAST(On_board_service AS FLOAT)), 2) AS avg_onboard_service,
    ROUND(AVG(CAST(Inflight_entertainment AS FLOAT)), 2) AS avg_entertainment,
    ROUND(AVG(CAST(Food_and_drink AS FLOAT)), 2) AS avg_food_drink,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM airline_satisfaction
WHERE Customer_Type IS NOT NULL AND Class IS NOT NULL
GROUP BY Customer_Type, Class
ORDER BY satisfaction_rate_pct DESC;

-- ============================================================================
-- END OF SERVICE EXPERIENCE ANALYSIS
-- ============================================================================
