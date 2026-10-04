-- ============================================================================
-- AIRLINE PASSENGER SATISFACTION ANALYSIS
-- Advanced SQL Analysis
-- ============================================================================
-- Purpose: Demonstrate advanced SQL techniques (CTEs, window functions, etc.)
-- while answering meaningful analytical questions
-- ============================================================================

-- 1. PERCENTILE ANALYSIS WITH WINDOW FUNCTIONS
-- Identify high, medium, and low service performers using percentiles
WITH service_scores AS (
    SELECT
        *,
        (Inflight_wifi_service + Seat_comfort + On_board_service +
         Leg_room_service + Food_and_drink + Cleanliness) / 6.0 AS avg_service_score
    FROM airline_satisfaction
)
SELECT
    CASE
        WHEN avg_service_score >= PERCENTILE_CONT(0.75) OVER () THEN 'Premium Service Experience'
        WHEN avg_service_score >= PERCENTILE_CONT(0.50) OVER () THEN 'Standard Service Experience'
        WHEN avg_service_score >= PERCENTILE_CONT(0.25) OVER () THEN 'Below Average Service'
        ELSE 'Poor Service Experience'
    END AS service_tier,
    COUNT(*) AS passenger_count,
    ROUND(AVG(avg_service_score), 2) AS avg_score,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM service_scores
GROUP BY
    CASE
        WHEN avg_service_score >= PERCENTILE_CONT(0.75) OVER () THEN 'Premium Service Experience'
        WHEN avg_service_score >= PERCENTILE_CONT(0.50) OVER () THEN 'Standard Service Experience'
        WHEN avg_service_score >= PERCENTILE_CONT(0.25) OVER () THEN 'Below Average Service'
        ELSE 'Poor Service Experience'
    END;

-- ============================================================================

-- 2. RANKING PASSENGERS BY SERVICE SATISFACTION
-- Use RANK and ROW_NUMBER to identify top/bottom performers
WITH service_analysis AS (
    SELECT
        Customer_Type,
        Type_of_Travel,
        Class,
        COUNT(*) AS segment_size,
        SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
        ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct,
        ROUND(AVG(CAST(On_board_service AS FLOAT)), 2) AS avg_onboard_service,
        ROUND(AVG(CAST(Seat_comfort AS FLOAT)), 2) AS avg_seat_comfort
    FROM airline_satisfaction
    WHERE Customer_Type IS NOT NULL AND Type_of_Travel IS NOT NULL AND Class IS NOT NULL
    GROUP BY Customer_Type, Type_of_Travel, Class
    HAVING COUNT(*) >= 30
)
SELECT
    Customer_Type,
    Type_of_Travel,
    Class,
    segment_size,
    satisfaction_rate_pct,
    avg_onboard_service,
    avg_seat_comfort,
    RANK() OVER (ORDER BY satisfaction_rate_pct DESC) AS satisfaction_rank,
    DENSE_RANK() OVER (PARTITION BY Customer_Type ORDER BY satisfaction_rate_pct DESC) AS rank_within_customer_type,
    ROW_NUMBER() OVER (ORDER BY segment_size DESC) AS size_row_number
FROM service_analysis
ORDER BY satisfaction_rate_pct DESC;

-- ============================================================================

-- 3. RUNNING AGGREGATE WITH AVG() OVER()
-- Compare individual segment performance to running average
WITH segment_performance AS (
    SELECT
        Customer_Type,
        Type_of_Travel,
        COUNT(*) AS passenger_count,
        SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
        ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
    FROM airline_satisfaction
    WHERE Customer_Type IS NOT NULL AND Type_of_Travel IS NOT NULL
    GROUP BY Customer_Type, Type_of_Travel
)
SELECT
    Customer_Type,
    Type_of_Travel,
    passenger_count,
    satisfaction_rate_pct,
    ROUND(AVG(satisfaction_rate_pct) OVER (), 2) AS overall_avg_satisfaction,
    ROUND(satisfaction_rate_pct - AVG(satisfaction_rate_pct) OVER (), 2) AS variance_from_avg,
    ROUND(AVG(satisfaction_rate_pct) OVER (PARTITION BY Customer_Type), 2) AS customer_type_avg,
    ROUND(satisfaction_rate_pct - AVG(satisfaction_rate_pct) OVER (PARTITION BY Customer_Type), 2) AS variance_from_type_avg
FROM segment_performance
ORDER BY satisfaction_rate_pct DESC;

-- ============================================================================

-- 4. LAG AND LEAD FOR TREND ANALYSIS
-- Identify segments with improving/declining satisfaction when ranked by size
WITH segment_ranked AS (
    SELECT
        Customer_Type,
        Type_of_Travel,
        COUNT(*) AS passenger_count,
        SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
        ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct,
        ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS size_rank
    FROM airline_satisfaction
    WHERE Customer_Type IS NOT NULL AND Type_of_Travel IS NOT NULL
    GROUP BY Customer_Type, Type_of_Travel
    HAVING COUNT(*) >= 50
)
SELECT
    size_rank,
    Customer_Type,
    Type_of_Travel,
    passenger_count,
    satisfaction_rate_pct,
    LAG(satisfaction_rate_pct) OVER (ORDER BY size_rank) AS previous_segment_satisfaction,
    LEAD(satisfaction_rate_pct) OVER (ORDER BY size_rank) AS next_segment_satisfaction,
    ROUND(satisfaction_rate_pct - LAG(satisfaction_rate_pct) OVER (ORDER BY size_rank), 2) AS satisfaction_diff_from_previous
FROM segment_ranked
ORDER BY size_rank;

-- ============================================================================

-- 5. SERVICE RATING DISTRIBUTION BY SATISFACTION
-- Detailed breakdown using CASE WHEN aggregation
SELECT
    satisfaction,
    COUNT(*) AS passenger_count,
    -- WiFi service distribution
    SUM(CASE WHEN Inflight_wifi_service = 0 THEN 1 ELSE 0 END) AS wifi_zero,
    SUM(CASE WHEN Inflight_wifi_service IN (1, 2) THEN 1 ELSE 0 END) AS wifi_low,
    SUM(CASE WHEN Inflight_wifi_service IN (3) THEN 1 ELSE 0 END) AS wifi_medium,
    SUM(CASE WHEN Inflight_wifi_service IN (4, 5) THEN 1 ELSE 0 END) AS wifi_high,
    -- Seat comfort distribution
    SUM(CASE WHEN Seat_comfort IN (4, 5) THEN 1 ELSE 0 END) AS high_seat_comfort,
    SUM(CASE WHEN Seat_comfort IN (1, 2) THEN 1 ELSE 0 END) AS low_seat_comfort,
    -- On-board service distribution
    SUM(CASE WHEN On_board_service IN (4, 5) THEN 1 ELSE 0 END) AS high_onboard_service
FROM airline_satisfaction
WHERE satisfaction IS NOT NULL
GROUP BY satisfaction;

-- ============================================================================

-- 6. MULTI-DIMENSIONAL SEGMENT COMPARISON
-- Compare performance across multiple dimensions simultaneously
WITH segment_metrics AS (
    SELECT
        Type_of_Travel,
        Class,
        COUNT(*) AS total_passengers,
        SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
        ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct,
        ROUND(AVG(CAST(Departure_Delay_in_Minutes AS FLOAT)), 1) AS avg_dep_delay,
        ROUND(AVG(CAST(Arrival_Delay_in_Minutes AS FLOAT)), 1) AS avg_arr_delay,
        ROUND(AVG(CAST(On_board_service AS FLOAT)), 2) AS avg_onboard_service,
        ROUND(AVG(CAST(Seat_comfort AS FLOAT)), 2) AS avg_seat_comfort,
        ROUND(AVG(CAST(Food_and_drink AS FLOAT)), 2) AS avg_food_drink
    FROM airline_satisfaction
    WHERE Type_of_Travel IS NOT NULL AND Class IS NOT NULL
    GROUP BY Type_of_Travel, Class
    HAVING COUNT(*) >= 50
)
SELECT
    Type_of_Travel,
    Class,
    total_passengers,
    satisfaction_rate_pct,
    ROUND(AVG(satisfaction_rate_pct) OVER (PARTITION BY Type_of_Travel), 2) AS travel_type_avg_satisfaction,
    ROUND(AVG(satisfaction_rate_pct) OVER (PARTITION BY Class), 2) AS class_avg_satisfaction,
    avg_dep_delay,
    avg_onboard_service,
    CASE
        WHEN satisfaction_rate_pct > AVG(satisfaction_rate_pct) OVER () THEN 'Above Average'
        ELSE 'Below Average'
    END AS performance_tier
FROM segment_metrics
ORDER BY satisfaction_rate_pct DESC;

-- ============================================================================

-- 7. CUSTOMER LIFETIME VALUE PROXY
-- Business travelers with loyalty show different patterns than others
WITH customer_profiles AS (
    SELECT
        Customer_Type,
        Type_of_Travel,
        Gender,
        COUNT(*) AS flight_count,
        SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_flights,
        ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct,
        ROUND(AVG(CAST(Flight_Distance AS FLOAT)), 0) AS avg_distance,
        ROUND(AVG(CAST(Age AS FLOAT)), 1) AS avg_age
    FROM airline_satisfaction
    GROUP BY Customer_Type, Type_of_Travel, Gender
    HAVING COUNT(*) >= 20
)
SELECT
    Customer_Type,
    Type_of_Travel,
    Gender,
    flight_count,
    satisfied_flights,
    satisfaction_rate_pct,
    avg_distance,
    avg_age,
    CASE
        WHEN Customer_Type = 'Loyal Customer' AND Type_of_Travel = 'Business travel'
             AND satisfaction_rate_pct >= 60 THEN 'Premium Segment'
        WHEN Customer_Type = 'Loyal Customer' AND satisfaction_rate_pct >= 50 THEN 'Core Loyal'
        WHEN Type_of_Travel = 'Business travel' AND satisfaction_rate_pct >= 50 THEN 'Business Focus'
        ELSE 'Standard'
    END AS customer_value_segment
FROM customer_profiles
ORDER BY satisfaction_rate_pct DESC;

-- ============================================================================

-- 8. SATISFACTION THRESHOLD ANALYSIS
-- How many ratings of 4+ needed for satisfaction?
WITH rating_counts AS (
    SELECT
        *,
        (CASE WHEN Inflight_wifi_service >= 4 THEN 1 ELSE 0 END +
         CASE WHEN Departure_Arrival_time_convenient >= 4 THEN 1 ELSE 0 END +
         CASE WHEN Ease_of_Online_booking >= 4 THEN 1 ELSE 0 END +
         CASE WHEN Gate_location >= 4 THEN 1 ELSE 0 END +
         CASE WHEN Food_and_drink >= 4 THEN 1 ELSE 0 END +
         CASE WHEN Online_boarding >= 4 THEN 1 ELSE 0 END +
         CASE WHEN Seat_comfort >= 4 THEN 1 ELSE 0 END +
         CASE WHEN Inflight_entertainment >= 4 THEN 1 ELSE 0 END +
         CASE WHEN On_board_service >= 4 THEN 1 ELSE 0 END +
         CASE WHEN Leg_room_service >= 4 THEN 1 ELSE 0 END +
         CASE WHEN Baggage_handling >= 4 THEN 1 ELSE 0 END +
         CASE WHEN Checkin_service >= 4 THEN 1 ELSE 0 END +
         CASE WHEN Cleanliness >= 4 THEN 1 ELSE 0 END) AS high_ratings_count
    FROM airline_satisfaction
)
SELECT
    high_ratings_count,
    COUNT(*) AS passenger_count,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) /
          SUM(COUNT(*)) OVER (), 2) AS pct_of_all_satisfied
FROM rating_counts
GROUP BY high_ratings_count
ORDER BY high_ratings_count DESC;

-- ============================================================================

-- 9. PASSENGER JOURNEY COMPLEXITY
-- Business travelers often have different expectations than leisure travelers
WITH journey_analysis AS (
    SELECT
        Customer_Type,
        Type_of_Travel,
        Class,
        CASE
            WHEN Flight_Distance < 500 THEN 'Short'
            WHEN Flight_Distance < 1500 THEN 'Medium'
            ELSE 'Long'
        END AS distance_category,
        COUNT(*) AS journey_count,
        SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
        ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct,
        ROUND(AVG(CAST(Departure_Delay_in_Minutes + Arrival_Delay_in_Minutes AS FLOAT)), 1) AS avg_total_delay
    FROM airline_satisfaction
    WHERE Customer_Type IS NOT NULL AND Type_of_Travel IS NOT NULL AND Class IS NOT NULL
    GROUP BY Customer_Type, Type_of_Travel, Class,
        CASE
            WHEN Flight_Distance < 500 THEN 'Short'
            WHEN Flight_Distance < 1500 THEN 'Medium'
            ELSE 'Long'
        END
    HAVING COUNT(*) >= 20
)
SELECT
    *,
    DENSE_RANK() OVER (PARTITION BY Customer_Type, Type_of_Travel ORDER BY satisfaction_rate_pct DESC) AS rank_within_journey_type
FROM journey_analysis
ORDER BY Customer_Type, Type_of_Travel, satisfaction_rate_pct DESC;

-- ============================================================================

-- 10. COMPREHENSIVE DIAGNOSTIC REPORT
-- One query that shows key metrics for all major segments
WITH segment_diagnostics AS (
    SELECT
        Customer_Type AS segment_dimension_1,
        'Customer Type' AS dimension_1_label,
        Type_of_Travel AS segment_dimension_2,
        'Travel Type' AS dimension_2_label,
        COUNT(*) AS passenger_count,
        SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
        ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct,
        ROUND(AVG(CAST(Age AS FLOAT)), 1) AS avg_age,
        ROUND(AVG(CAST(Flight_Distance AS FLOAT)), 0) AS avg_distance,
        ROUND(AVG(CAST(Departure_Delay_in_Minutes + Arrival_Delay_in_Minutes AS FLOAT)), 1) AS avg_total_delay,
        ROUND(AVG(CAST(On_board_service AS FLOAT)), 2) AS avg_onboard_service,
        ROUND(AVG(CAST(Seat_comfort AS FLOAT)), 2) AS avg_seat_comfort
    FROM airline_satisfaction
    WHERE Customer_Type IS NOT NULL AND Type_of_Travel IS NOT NULL
    GROUP BY Customer_Type, Type_of_Travel
    HAVING COUNT(*) >= 50
)
SELECT
    segment_dimension_1,
    segment_dimension_2,
    passenger_count,
    satisfaction_rate_pct,
    CASE
        WHEN satisfaction_rate_pct >= 75 THEN 'Excellent'
        WHEN satisfaction_rate_pct >= 60 THEN 'Good'
        WHEN satisfaction_rate_pct >= 45 THEN 'Fair'
        ELSE 'Poor'
    END AS satisfaction_rating,
    avg_total_delay,
    CASE
        WHEN avg_total_delay > 30 THEN 'High Delay Issues'
        WHEN avg_total_delay > 10 THEN 'Moderate Delays'
        ELSE 'On-Time Performance'
    END AS operational_rating,
    avg_onboard_service,
    avg_seat_comfort,
    ROUND((satisfaction_rate_pct - AVG(satisfaction_rate_pct) OVER ()) / STDEV(satisfaction_rate_pct) OVER (), 2) AS zscore_satisfaction
FROM segment_diagnostics
ORDER BY satisfaction_rate_pct DESC;

-- ============================================================================
-- END OF ADVANCED ANALYSIS
-- ============================================================================
