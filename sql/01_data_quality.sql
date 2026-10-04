-- ============================================================================
-- AIRLINE PASSENGER SATISFACTION ANALYSIS
-- Data Quality Audit Queries
-- ============================================================================
-- Purpose: Comprehensive data quality checks before analysis
-- Dataset: 129,880 passenger records with 22 columns
-- ============================================================================

-- 1. DATASET OVERVIEW
-- Check total row count and column structure
SELECT
    'DATASET OVERVIEW' AS audit_section,
    COUNT(*) AS total_records
FROM airline_satisfaction;

-- ============================================================================

-- 2. NULL VALUE AUDIT
-- Identify missing data across all columns
SELECT
    'NULL VALUES' AS audit_section,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS null_gender,
    SUM(CASE WHEN Customer_Type IS NULL THEN 1 ELSE 0 END) AS null_customer_type,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS null_age,
    SUM(CASE WHEN Type_of_Travel IS NULL THEN 1 ELSE 0 END) AS null_type_of_travel,
    SUM(CASE WHEN Class IS NULL THEN 1 ELSE 0 END) AS null_class,
    SUM(CASE WHEN Flight_Distance IS NULL THEN 1 ELSE 0 END) AS null_flight_distance,
    SUM(CASE WHEN Departure_Delay_in_Minutes IS NULL THEN 1 ELSE 0 END) AS null_departure_delay,
    SUM(CASE WHEN Arrival_Delay_in_Minutes IS NULL THEN 1 ELSE 0 END) AS null_arrival_delay,
    SUM(CASE WHEN satisfaction IS NULL THEN 1 ELSE 0 END) AS null_satisfaction
FROM airline_satisfaction;

-- ============================================================================

-- 3. DUPLICATE RECORDS AUDIT
-- Check for exact duplicate rows
SELECT
    'DUPLICATE ROWS' AS audit_section,
    COUNT(*) - COUNT(DISTINCT *) AS duplicate_count
FROM airline_satisfaction;

-- ============================================================================

-- 4. CATEGORICAL VARIABLE DISTRIBUTION
-- Examine distinct values for key categorical columns

-- Gender Distribution
SELECT
    'GENDER VALUES' AS variable,
    Gender AS value,
    COUNT(*) AS record_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM airline_satisfaction
WHERE Gender IS NOT NULL
GROUP BY Gender
ORDER BY record_count DESC;

-- Customer Type Distribution
SELECT
    'CUSTOMER TYPE' AS variable,
    Customer_Type AS value,
    COUNT(*) AS record_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM airline_satisfaction
WHERE Customer_Type IS NOT NULL
GROUP BY Customer_Type
ORDER BY record_count DESC;

-- Type of Travel Distribution
SELECT
    'TYPE OF TRAVEL' AS variable,
    Type_of_Travel AS value,
    COUNT(*) AS record_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM airline_satisfaction
WHERE Type_of_Travel IS NOT NULL
GROUP BY Type_of_Travel
ORDER BY record_count DESC;

-- Class Distribution
SELECT
    'CLASS' AS variable,
    Class AS value,
    COUNT(*) AS record_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM airline_satisfaction
WHERE Class IS NOT NULL
GROUP BY Class
ORDER BY record_count DESC;

-- ============================================================================

-- 5. AGE ANALYSIS
-- Review age data for anomalies
SELECT
    'AGE STATISTICS' AS metric,
    MIN(Age) AS min_age,
    MAX(Age) AS max_age,
    AVG(Age) AS avg_age,
    COUNT(*) AS total_records,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS null_count,
    SUM(CASE WHEN Age = 0 THEN 1 ELSE 0 END) AS zero_age_count,
    SUM(CASE WHEN Age < 1 THEN 1 ELSE 0 END) AS age_under_1_count
FROM airline_satisfaction;

-- ============================================================================

-- 6. FLIGHT DISTANCE ANALYSIS
-- Review distance data for anomalies
SELECT
    'FLIGHT DISTANCE STATISTICS' AS metric,
    MIN(Flight_Distance) AS min_distance,
    MAX(Flight_Distance) AS max_distance,
    AVG(Flight_Distance) AS avg_distance,
    COUNT(*) AS total_records,
    SUM(CASE WHEN Flight_Distance IS NULL THEN 1 ELSE 0 END) AS null_count,
    SUM(CASE WHEN Flight_Distance = 0 THEN 1 ELSE 0 END) AS zero_distance_count
FROM airline_satisfaction;

-- ============================================================================

-- 7. DELAY ANALYSIS
-- Review departure and arrival delay distributions

-- Departure Delay Statistics
SELECT
    'DEPARTURE DELAY STATISTICS' AS metric,
    MIN(Departure_Delay_in_Minutes) AS min_delay,
    MAX(Departure_Delay_in_Minutes) AS max_delay,
    AVG(Departure_Delay_in_Minutes) AS avg_delay,
    COUNT(*) AS total_records,
    SUM(CASE WHEN Departure_Delay_in_Minutes IS NULL THEN 1 ELSE 0 END) AS null_count,
    SUM(CASE WHEN Departure_Delay_in_Minutes = 0 THEN 1 ELSE 0 END) AS zero_delay_count
FROM airline_satisfaction;

-- Arrival Delay Statistics
SELECT
    'ARRIVAL DELAY STATISTICS' AS metric,
    MIN(Arrival_Delay_in_Minutes) AS min_delay,
    MAX(Arrival_Delay_in_Minutes) AS max_delay,
    AVG(Arrival_Delay_in_Minutes) AS avg_delay,
    COUNT(*) AS total_records,
    SUM(CASE WHEN Arrival_Delay_in_Minutes IS NULL THEN 1 ELSE 0 END) AS null_count,
    SUM(CASE WHEN Arrival_Delay_in_Minutes = 0 THEN 1 ELSE 0 END) AS zero_delay_count
FROM airline_satisfaction;

-- ============================================================================

-- 8. SATISFACTION TARGET VARIABLE DISTRIBUTION
-- Critical: understand the distribution of the target variable
SELECT
    'SATISFACTION DISTRIBUTION' AS metric,
    satisfaction AS value,
    COUNT(*) AS record_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM airline_satisfaction
GROUP BY satisfaction
ORDER BY
    CASE
        WHEN satisfaction = 'True' THEN 1
        WHEN satisfaction = 'False' THEN 2
        ELSE 3
    END;

-- ============================================================================

-- 9. SERVICE RATING COLUMNS - ZERO VALUE INVESTIGATION
-- Critical: investigate the meaning of 0 ratings across service metrics
-- Count how many times 0 appears in each service rating column

SELECT
    'SERVICE RATING ZERO VALUES' AS metric,
    SUM(CASE WHEN Inflight_wifi_service = 0 THEN 1 ELSE 0 END) AS wifi_zeros,
    SUM(CASE WHEN Departure_Arrival_time_convenient = 0 THEN 1 ELSE 0 END) AS departure_arrival_zeros,
    SUM(CASE WHEN Ease_of_Online_booking = 0 THEN 1 ELSE 0 END) AS booking_zeros,
    SUM(CASE WHEN Gate_location = 0 THEN 1 ELSE 0 END) AS gate_zeros,
    SUM(CASE WHEN Food_and_drink = 0 THEN 1 ELSE 0 END) AS food_zeros,
    SUM(CASE WHEN Online_boarding = 0 THEN 1 ELSE 0 END) AS boarding_zeros,
    SUM(CASE WHEN Seat_comfort = 0 THEN 1 ELSE 0 END) AS seat_zeros,
    SUM(CASE WHEN Inflight_entertainment = 0 THEN 1 ELSE 0 END) AS entertainment_zeros,
    SUM(CASE WHEN On_board_service = 0 THEN 1 ELSE 0 END) AS onboard_zeros,
    SUM(CASE WHEN Leg_room_service = 0 THEN 1 ELSE 0 END) AS legroom_zeros,
    SUM(CASE WHEN Baggage_handling = 0 THEN 1 ELSE 0 END) AS baggage_zeros,
    SUM(CASE WHEN Checkin_service = 0 THEN 1 ELSE 0 END) AS checkin_zeros,
    SUM(CASE WHEN Cleanliness = 0 THEN 1 ELSE 0 END) AS cleanliness_zeros
FROM airline_satisfaction;

-- ============================================================================

-- 10. SERVICE RATING RANGES
-- Verify that service ratings are within expected range (0-5)
SELECT
    'SERVICE RATING RANGES - WIFI' AS metric,
    MIN(Inflight_wifi_service) AS min_value,
    MAX(Inflight_wifi_service) AS max_value,
    COUNT(DISTINCT Inflight_wifi_service) AS distinct_values
FROM airline_satisfaction;

SELECT
    'SERVICE RATING RANGES - DEPARTURE/ARRIVAL TIME' AS metric,
    MIN(Departure_Arrival_time_convenient) AS min_value,
    MAX(Departure_Arrival_time_convenient) AS max_value,
    COUNT(DISTINCT Departure_Arrival_time_convenient) AS distinct_values
FROM airline_satisfaction;

SELECT
    'SERVICE RATING RANGES - ONLINE BOOKING' AS metric,
    MIN(Ease_of_Online_booking) AS min_value,
    MAX(Ease_of_Online_booking) AS max_value,
    COUNT(DISTINCT Ease_of_Online_booking) AS distinct_values
FROM airline_satisfaction;

-- Additional service ratings sample check
SELECT
    'SERVICE RATING RANGES - SEAT COMFORT' AS metric,
    MIN(Seat_comfort) AS min_value,
    MAX(Seat_comfort) AS max_value,
    COUNT(DISTINCT Seat_comfort) AS distinct_values
FROM airline_satisfaction;

-- ============================================================================

-- 11. ZERO RATING INVESTIGATION - SAMPLE RECORDS
-- Review actual records with zero ratings to understand context
SELECT TOP 10
    'SAMPLE RECORDS WITH ZERO RATINGS' AS context,
    Gender,
    Age,
    Customer_Type,
    Type_of_Travel,
    Class,
    Inflight_wifi_service,
    Departure_Arrival_time_convenient,
    Ease_of_Online_booking,
    satisfaction
FROM airline_satisfaction
WHERE Inflight_wifi_service = 0
   OR Departure_Arrival_time_convenient = 0
   OR Ease_of_Online_booking = 0
ORDER BY Inflight_wifi_service DESC, Departure_Arrival_time_convenient DESC;

-- ============================================================================

-- 12. DATA QUALITY SUMMARY REPORT
-- High-level assessment
SELECT
    'DATA QUALITY SUMMARY' AS section,
    COUNT(*) AS total_rows,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    SUM(CASE WHEN satisfaction = 'False' THEN 1 ELSE 0 END) AS dissatisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct,
    COUNT(DISTINCT Age) AS unique_ages,
    COUNT(DISTINCT Customer_Type) AS unique_customer_types,
    COUNT(DISTINCT Class) AS unique_classes
FROM airline_satisfaction;

-- ============================================================================
-- END OF DATA QUALITY AUDIT
-- ============================================================================
