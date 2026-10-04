-- ============================================================================
-- AIRLINE PASSENGER SATISFACTION ANALYSIS
-- Customer Segmentation Analysis
-- ============================================================================
-- Purpose: Identify distinct customer segments with different satisfaction profiles
-- ============================================================================

-- 1. BASIC SEGMENT IDENTIFICATION
-- Segments by customer type, travel type, and class
SELECT
    Customer_Type,
    Type_of_Travel,
    Class,
    COUNT(*) AS segment_size,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct,
    ROUND(AVG(CAST(Age AS FLOAT)), 1) AS avg_age,
    ROUND(AVG(CAST(Flight_Distance AS FLOAT)), 0) AS avg_distance
FROM airline_satisfaction
WHERE Customer_Type IS NOT NULL AND Type_of_Travel IS NOT NULL AND Class IS NOT NULL
GROUP BY Customer_Type, Type_of_Travel, Class
ORDER BY segment_size DESC;

-- ============================================================================

-- 2. TOP SATISFACTION SEGMENTS
-- Segments with highest satisfaction rates (minimum 50 passengers for reliability)
SELECT TOP 10
    'HIGH SATISFACTION SEGMENTS' AS segment_type,
    Customer_Type,
    Type_of_Travel,
    Class,
    COUNT(*) AS segment_size,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM airline_satisfaction
WHERE Customer_Type IS NOT NULL AND Type_of_Travel IS NOT NULL AND Class IS NOT NULL
GROUP BY Customer_Type, Type_of_Travel, Class
HAVING COUNT(*) >= 50
ORDER BY satisfaction_rate_pct DESC;

-- ============================================================================

-- 3. LOW SATISFACTION SEGMENTS
-- Segments with lowest satisfaction rates (minimum 50 passengers for reliability)
SELECT TOP 10
    'LOW SATISFACTION SEGMENTS' AS segment_type,
    Customer_Type,
    Type_of_Travel,
    Class,
    COUNT(*) AS segment_size,
    SUM(CASE WHEN satisfaction = 'False' THEN 1 ELSE 0 END) AS dissatisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM airline_satisfaction
WHERE Customer_Type IS NOT NULL AND Type_of_Travel IS NOT NULL AND Class IS NOT NULL
GROUP BY Customer_Type, Type_of_Travel, Class
HAVING COUNT(*) >= 50
ORDER BY satisfaction_rate_pct ASC;

-- ============================================================================

-- 4. LARGEST SEGMENTS BY VOLUME
-- Identify which segments have the most passengers
SELECT TOP 15
    'LARGEST SEGMENTS' AS segment_analysis,
    Customer_Type,
    Type_of_Travel,
    Class,
    COUNT(*) AS segment_size,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM airline_satisfaction), 2) AS pct_of_total_passengers,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM airline_satisfaction
WHERE Customer_Type IS NOT NULL AND Type_of_Travel IS NOT NULL AND Class IS NOT NULL
GROUP BY Customer_Type, Type_of_Travel, Class
ORDER BY segment_size DESC;

-- ============================================================================

-- 5. DEMOGRAPHIC SEGMENTS BY AGE
-- Age-based segmentation within travel/class combinations
WITH age_segments AS (
    SELECT
        *,
        CASE
            WHEN Age < 25 THEN 'Young (< 25)'
            WHEN Age >= 25 AND Age < 45 THEN 'Prime (25-44)'
            WHEN Age >= 45 AND Age < 65 THEN 'Mature (45-64)'
            WHEN Age >= 65 THEN 'Senior (65+)'
        END AS age_segment
    FROM airline_satisfaction
)
SELECT
    Type_of_Travel,
    Class,
    age_segment,
    COUNT(*) AS segment_size,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM age_segments
WHERE Type_of_Travel IS NOT NULL AND Class IS NOT NULL AND age_segment IS NOT NULL
GROUP BY Type_of_Travel, Class, age_segment
HAVING COUNT(*) >= 20
ORDER BY satisfaction_rate_pct DESC;

-- ============================================================================

-- 6. OPERATIONAL PERFORMANCE SEGMENTS
-- Segments by delay status and satisfaction
WITH delay_status AS (
    SELECT
        *,
        CASE WHEN Departure_Delay_in_Minutes = 0 AND Arrival_Delay_in_Minutes = 0 THEN 'Both On-Time'
             WHEN Departure_Delay_in_Minutes > 0 OR Arrival_Delay_in_Minutes > 0 THEN 'Any Delay'
             ELSE 'Unknown'
        END AS operational_status
    FROM airline_satisfaction
)
SELECT
    Customer_Type,
    Type_of_Travel,
    operational_status,
    COUNT(*) AS segment_size,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM airline_satisfaction), 2) AS pct_of_total,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM delay_status
WHERE Customer_Type IS NOT NULL AND Type_of_Travel IS NOT NULL
GROUP BY Customer_Type, Type_of_Travel, operational_status
ORDER BY satisfaction_rate_pct DESC;

-- ============================================================================

-- 7. SERVICE QUALITY SEGMENTS
-- High-service vs low-service passengers based on ratings
WITH service_quality_segments AS (
    SELECT
        *,
        (CASE WHEN Inflight_wifi_service >= 4 THEN 1 ELSE 0 END +
         CASE WHEN Seat_comfort >= 4 THEN 1 ELSE 0 END +
         CASE WHEN On_board_service >= 4 THEN 1 ELSE 0 END +
         CASE WHEN Leg_room_service >= 4 THEN 1 ELSE 0 END +
         CASE WHEN Food_and_drink >= 4 THEN 1 ELSE 0 END) AS high_ratings_count
    FROM airline_satisfaction
)
SELECT
    CASE
        WHEN high_ratings_count >= 4 THEN 'Premium Service Experience (4-5 high ratings)'
        WHEN high_ratings_count = 3 THEN 'Good Service Experience (3 high ratings)'
        WHEN high_ratings_count = 2 THEN 'Average Service Experience (2 high ratings)'
        WHEN high_ratings_count = 1 THEN 'Poor Service Experience (1 high rating)'
        ELSE 'Very Poor Service Experience (0 high ratings)'
    END AS service_quality_segment,
    COUNT(*) AS segment_size,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM airline_satisfaction), 2) AS pct_of_total,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM service_quality_segments
GROUP BY high_ratings_count
ORDER BY satisfaction_rate_pct DESC;

-- ============================================================================

-- 8. SEGMENT RANKING BY SATISFACTION AND SIZE
-- Using window functions to rank segments
WITH segment_analysis AS (
    SELECT
        Customer_Type,
        Type_of_Travel,
        Class,
        COUNT(*) AS segment_size,
        SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
        ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
    FROM airline_satisfaction
    WHERE Customer_Type IS NOT NULL AND Type_of_Travel IS NOT NULL AND Class IS NOT NULL
    GROUP BY Customer_Type, Type_of_Travel, Class
)
SELECT
    Customer_Type,
    Type_of_Travel,
    Class,
    segment_size,
    satisfied_count,
    satisfaction_rate_pct,
    RANK() OVER (ORDER BY satisfaction_rate_pct DESC) AS satisfaction_rank,
    RANK() OVER (ORDER BY segment_size DESC) AS size_rank,
    ROW_NUMBER() OVER (PARTITION BY Customer_Type ORDER BY satisfaction_rate_pct DESC) AS rank_within_customer_type
FROM segment_analysis
WHERE segment_size >= 30
ORDER BY satisfaction_rate_pct DESC;

-- ============================================================================

-- 9. SEGMENT COMPARISON MATRIX
-- Cross-dimensional view of key metrics by segment
SELECT
    Customer_Type,
    Type_of_Travel,
    COUNT(*) AS passenger_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct,
    ROUND(AVG(CAST(Departure_Delay_in_Minutes AS FLOAT)), 1) AS avg_departure_delay,
    ROUND(AVG(CAST(Arrival_Delay_in_Minutes AS FLOAT)), 1) AS avg_arrival_delay,
    ROUND(AVG(CAST(On_board_service AS FLOAT)), 2) AS avg_onboard_service,
    ROUND(AVG(CAST(Seat_comfort AS FLOAT)), 2) AS avg_seat_comfort
FROM airline_satisfaction
WHERE Customer_Type IS NOT NULL AND Type_of_Travel IS NOT NULL
GROUP BY Customer_Type, Type_of_Travel
ORDER BY satisfaction_rate_pct DESC;

-- ============================================================================

-- 10. SMALL SEGMENT IDENTIFICATION
-- Segments with very few passengers (potential data quality issues or niche markets)
SELECT
    'SMALL SEGMENTS (< 20 passengers)' AS segment_category,
    Customer_Type,
    Type_of_Travel,
    Class,
    COUNT(*) AS segment_size,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM airline_satisfaction
WHERE Customer_Type IS NOT NULL AND Type_of_Travel IS NOT NULL AND Class IS NOT NULL
GROUP BY Customer_Type, Type_of_Travel, Class
HAVING COUNT(*) < 20
ORDER BY segment_size ASC;

-- ============================================================================
-- END OF SEGMENTATION ANALYSIS
-- ============================================================================
