-- ============================================================================
-- AIRLINE PASSENGER SATISFACTION ANALYSIS
-- Travel Characteristics & Service Tier Analysis
-- ============================================================================
-- Purpose: Analyze satisfaction patterns by travel type, class, and flight distance
-- ============================================================================

-- 1. SATISFACTION BY TYPE OF TRAVEL
-- Compare business vs personal travel satisfaction
SELECT
    Type_of_Travel,
    COUNT(*) AS total_passengers,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    SUM(CASE WHEN satisfaction = 'False' THEN 1 ELSE 0 END) AS dissatisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM airline_satisfaction
WHERE Type_of_Travel IS NOT NULL
GROUP BY Type_of_Travel
ORDER BY satisfaction_rate_pct DESC;

-- ============================================================================

-- 2. SATISFACTION BY CLASS
-- Analyze service tier differences in satisfaction
SELECT
    Class,
    COUNT(*) AS total_passengers,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    SUM(CASE WHEN satisfaction = 'False' THEN 1 ELSE 0 END) AS dissatisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM airline_satisfaction
WHERE Class IS NOT NULL
GROUP BY Class
ORDER BY satisfaction_rate_pct DESC;

-- ============================================================================

-- 3. FLIGHT DISTANCE CATEGORIZATION
-- Create meaningful distance categories and analyze satisfaction
WITH distance_categories AS (
    SELECT
        *,
        CASE
            WHEN Flight_Distance < 500 THEN 'Short Haul (< 500 mi)'
            WHEN Flight_Distance >= 500 AND Flight_Distance < 1500 THEN 'Medium Haul (500-1500 mi)'
            WHEN Flight_Distance >= 1500 AND Flight_Distance < 2500 THEN 'Long Haul (1500-2500 mi)'
            WHEN Flight_Distance >= 2500 THEN 'Ultra Long Haul (2500+ mi)'
        END AS distance_category
    FROM airline_satisfaction
    WHERE Flight_Distance IS NOT NULL
)
SELECT
    distance_category,
    COUNT(*) AS total_passengers,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct,
    ROUND(AVG(CAST(Flight_Distance AS FLOAT)), 0) AS avg_distance,
    MIN(Flight_Distance) AS min_distance,
    MAX(Flight_Distance) AS max_distance
FROM distance_categories
GROUP BY distance_category
ORDER BY
    CASE
        WHEN distance_category = 'Short Haul (< 500 mi)' THEN 1
        WHEN distance_category = 'Medium Haul (500-1500 mi)' THEN 2
        WHEN distance_category = 'Long Haul (1500-2500 mi)' THEN 3
        WHEN distance_category = 'Ultra Long Haul (2500+ mi)' THEN 4
    END;

-- ============================================================================

-- 4. CLASS AND TRAVEL TYPE INTERACTION
-- Analyze combinations of service tier and travel purpose
SELECT
    Class,
    Type_of_Travel,
    COUNT(*) AS total_passengers,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM airline_satisfaction
WHERE Class IS NOT NULL AND Type_of_Travel IS NOT NULL
GROUP BY Class, Type_of_Travel
ORDER BY Class, satisfaction_rate_pct DESC;

-- ============================================================================

-- 5. TRAVEL TYPE AND DISTANCE ANALYSIS
-- Understanding how travel purpose and distance interact
WITH distance_categories AS (
    SELECT
        *,
        CASE
            WHEN Flight_Distance < 500 THEN 'Short Haul'
            WHEN Flight_Distance >= 500 AND Flight_Distance < 1500 THEN 'Medium Haul'
            WHEN Flight_Distance >= 1500 THEN 'Long Haul'
        END AS distance_category
    FROM airline_satisfaction
)
SELECT
    Type_of_Travel,
    distance_category,
    COUNT(*) AS total_passengers,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM distance_categories
WHERE Type_of_Travel IS NOT NULL AND distance_category IS NOT NULL
GROUP BY Type_of_Travel, distance_category
ORDER BY Type_of_Travel,
    CASE
        WHEN distance_category = 'Short Haul' THEN 1
        WHEN distance_category = 'Medium Haul' THEN 2
        WHEN distance_category = 'Long Haul' THEN 3
    END;

-- ============================================================================

-- 6. AVERAGE FLIGHT DISTANCE BY SATISFACTION
-- Understand if flight length differs between satisfied and dissatisfied
SELECT
    satisfaction,
    COUNT(*) AS passenger_count,
    ROUND(AVG(CAST(Flight_Distance AS FLOAT)), 0) AS avg_distance,
    ROUND(MIN(CAST(Flight_Distance AS FLOAT)), 0) AS min_distance,
    ROUND(MAX(CAST(Flight_Distance AS FLOAT)), 0) AS max_distance,
    ROUND(STDEV(CAST(Flight_Distance AS FLOAT)), 0) AS distance_std_dev
FROM airline_satisfaction
WHERE Flight_Distance IS NOT NULL AND satisfaction IS NOT NULL
GROUP BY satisfaction;

-- ============================================================================

-- 7. CLASS DISTRIBUTION BY TRAVEL TYPE
-- Understand service tier composition for each travel purpose
SELECT
    Type_of_Travel,
    Class,
    COUNT(*) AS passenger_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY Type_of_Travel), 2) AS pct_of_travel_type
FROM airline_satisfaction
WHERE Type_of_Travel IS NOT NULL AND Class IS NOT NULL
GROUP BY Type_of_Travel, Class
ORDER BY Type_of_Travel, passenger_count DESC;

-- ============================================================================

-- 8. TRAVEL CHARACTERISTICS SUMMARY
-- High-level overview of satisfaction by travel characteristics
SELECT
    'Travel Type' AS characteristic_category,
    Type_of_Travel AS characteristic_value,
    COUNT(*) AS total_passengers,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM airline_satisfaction
WHERE Type_of_Travel IS NOT NULL
GROUP BY Type_of_Travel
UNION ALL
SELECT
    'Service Class' AS characteristic_category,
    Class AS characteristic_value,
    COUNT(*) AS total_passengers,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM airline_satisfaction
WHERE Class IS NOT NULL
GROUP BY Class
ORDER BY characteristic_category, satisfaction_rate_pct DESC;

-- ============================================================================

-- 9. COMPREHENSIVE TRAVEL PROFILE ANALYSIS
-- Detailed cross-dimensional analysis
SELECT
    Type_of_Travel,
    Class,
    COUNT(*) AS passenger_count,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct,
    ROUND(AVG(CAST(Flight_Distance AS FLOAT)), 0) AS avg_distance
FROM airline_satisfaction
WHERE Type_of_Travel IS NOT NULL AND Class IS NOT NULL AND Flight_Distance IS NOT NULL
GROUP BY Type_of_Travel, Class
ORDER BY satisfaction_rate_pct DESC, passenger_count DESC;

-- ============================================================================

-- 10. FLIGHT DISTANCE QUARTILE ANALYSIS
-- Segment passengers by distance quartiles and analyze satisfaction
WITH distance_quartiles AS (
    SELECT
        *,
        NTILE(4) OVER (ORDER BY Flight_Distance) AS distance_quartile
    FROM airline_satisfaction
    WHERE Flight_Distance IS NOT NULL
)
SELECT
    CASE
        WHEN distance_quartile = 1 THEN 'Q1 - Shortest Distances'
        WHEN distance_quartile = 2 THEN 'Q2 - Short-Medium Distances'
        WHEN distance_quartile = 3 THEN 'Q3 - Medium-Long Distances'
        WHEN distance_quartile = 4 THEN 'Q4 - Longest Distances'
    END AS distance_quartile,
    COUNT(*) AS passenger_count,
    ROUND(AVG(CAST(Flight_Distance AS FLOAT)), 0) AS avg_distance,
    ROUND(MIN(CAST(Flight_Distance AS FLOAT)), 0) AS min_distance,
    ROUND(MAX(CAST(Flight_Distance AS FLOAT)), 0) AS max_distance,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM distance_quartiles
GROUP BY distance_quartile
ORDER BY
    CASE
        WHEN distance_quartile = 'Q1 - Shortest Distances' THEN 1
        WHEN distance_quartile = 'Q2 - Short-Medium Distances' THEN 2
        WHEN distance_quartile = 'Q3 - Medium-Long Distances' THEN 3
        WHEN distance_quartile = 'Q4 - Longest Distances' THEN 4
    END;

-- ============================================================================
-- END OF TRAVEL CHARACTERISTICS ANALYSIS
-- ============================================================================
