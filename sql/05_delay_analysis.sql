-- ============================================================================
-- AIRLINE PASSENGER SATISFACTION ANALYSIS
-- Delay Impact Analysis
-- ============================================================================
-- Purpose: Analyze how operational delays affect passenger satisfaction
-- ============================================================================

-- 1. DEPARTURE DELAY STATISTICS
-- Overview of departure delays in dataset
SELECT
    'DEPARTURE DELAY OVERVIEW' AS metric,
    COUNT(*) AS total_passengers,
    MIN(Departure_Delay_in_Minutes) AS min_delay,
    MAX(Departure_Delay_in_Minutes) AS max_delay,
    ROUND(AVG(Departure_Delay_in_Minutes), 2) AS avg_delay,
    ROUND(STDEV(Departure_Delay_in_Minutes), 2) AS std_dev_delay,
    SUM(CASE WHEN Departure_Delay_in_Minutes = 0 THEN 1 ELSE 0 END) AS on_time_count,
    SUM(CASE WHEN Departure_Delay_in_Minutes > 0 THEN 1 ELSE 0 END) AS delayed_count,
    ROUND(100.0 * SUM(CASE WHEN Departure_Delay_in_Minutes = 0 THEN 1 ELSE 0 END) / COUNT(*), 2) AS on_time_pct
FROM airline_satisfaction;

-- ============================================================================

-- 2. ARRIVAL DELAY STATISTICS
-- Overview of arrival delays in dataset
SELECT
    'ARRIVAL DELAY OVERVIEW' AS metric,
    COUNT(*) AS total_passengers,
    MIN(Arrival_Delay_in_Minutes) AS min_delay,
    MAX(Arrival_Delay_in_Minutes) AS max_delay,
    ROUND(AVG(Arrival_Delay_in_Minutes), 2) AS avg_delay,
    ROUND(STDEV(Arrival_Delay_in_Minutes), 2) AS std_dev_delay,
    SUM(CASE WHEN Arrival_Delay_in_Minutes = 0 THEN 1 ELSE 0 END) AS on_time_count,
    SUM(CASE WHEN Arrival_Delay_in_Minutes > 0 THEN 1 ELSE 0 END) AS delayed_count,
    ROUND(100.0 * SUM(CASE WHEN Arrival_Delay_in_Minutes = 0 THEN 1 ELSE 0 END) / COUNT(*), 2) AS on_time_pct
FROM airline_satisfaction;

-- ============================================================================

-- 3. DELAY CATEGORIES
-- Segment passengers by delay severity
WITH delay_categories AS (
    SELECT
        *,
        CASE
            WHEN Departure_Delay_in_Minutes = 0 THEN 'On Time'
            WHEN Departure_Delay_in_Minutes > 0 AND Departure_Delay_in_Minutes <= 15 THEN 'Minor Delay (1-15 min)'
            WHEN Departure_Delay_in_Minutes > 15 AND Departure_Delay_in_Minutes <= 60 THEN 'Moderate Delay (16-60 min)'
            WHEN Departure_Delay_in_Minutes > 60 THEN 'Severe Delay (60+ min)'
        END AS departure_delay_category,
        CASE
            WHEN Arrival_Delay_in_Minutes = 0 THEN 'On Time'
            WHEN Arrival_Delay_in_Minutes > 0 AND Arrival_Delay_in_Minutes <= 15 THEN 'Minor Delay (1-15 min)'
            WHEN Arrival_Delay_in_Minutes > 15 AND Arrival_Delay_in_Minutes <= 60 THEN 'Moderate Delay (16-60 min)'
            WHEN Arrival_Delay_in_Minutes > 60 THEN 'Severe Delay (60+ min)'
        END AS arrival_delay_category
    FROM airline_satisfaction
)
SELECT
    'DEPARTURE DELAY CATEGORY ANALYSIS' AS analysis_type,
    departure_delay_category,
    COUNT(*) AS passenger_count,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM delay_categories
WHERE departure_delay_category IS NOT NULL
GROUP BY departure_delay_category
ORDER BY
    CASE
        WHEN departure_delay_category = 'On Time' THEN 1
        WHEN departure_delay_category = 'Minor Delay (1-15 min)' THEN 2
        WHEN departure_delay_category = 'Moderate Delay (16-60 min)' THEN 3
        WHEN departure_delay_category = 'Severe Delay (60+ min)' THEN 4
    END;

-- ============================================================================

-- 4. ARRIVAL DELAY CATEGORY ANALYSIS
WITH delay_categories AS (
    SELECT
        *,
        CASE
            WHEN Arrival_Delay_in_Minutes = 0 THEN 'On Time'
            WHEN Arrival_Delay_in_Minutes > 0 AND Arrival_Delay_in_Minutes <= 15 THEN 'Minor Delay (1-15 min)'
            WHEN Arrival_Delay_in_Minutes > 15 AND Arrival_Delay_in_Minutes <= 60 THEN 'Moderate Delay (16-60 min)'
            WHEN Arrival_Delay_in_Minutes > 60 THEN 'Severe Delay (60+ min)'
        END AS arrival_delay_category
    FROM airline_satisfaction
)
SELECT
    'ARRIVAL DELAY CATEGORY ANALYSIS' AS analysis_type,
    arrival_delay_category,
    COUNT(*) AS passenger_count,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM delay_categories
WHERE arrival_delay_category IS NOT NULL
GROUP BY arrival_delay_category
ORDER BY
    CASE
        WHEN arrival_delay_category = 'On Time' THEN 1
        WHEN arrival_delay_category = 'Minor Delay (1-15 min)' THEN 2
        WHEN arrival_delay_category = 'Moderate Delay (16-60 min)' THEN 3
        WHEN arrival_delay_category = 'Severe Delay (60+ min)' THEN 4
    END;

-- ============================================================================

-- 5. ON-TIME VS DELAYED SATISFACTION COMPARISON
-- High-level comparison of on-time vs delayed passengers
SELECT
    'DEPARTURE STATUS' AS delay_status,
    CASE WHEN Departure_Delay_in_Minutes = 0 THEN 'On-Time Departure' ELSE 'Delayed Departure' END AS status_value,
    COUNT(*) AS passenger_count,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM airline_satisfaction
GROUP BY CASE WHEN Departure_Delay_in_Minutes = 0 THEN 'On-Time Departure' ELSE 'Delayed Departure' END
UNION ALL
SELECT
    'ARRIVAL STATUS' AS delay_status,
    CASE WHEN Arrival_Delay_in_Minutes = 0 THEN 'On-Time Arrival' ELSE 'Delayed Arrival' END AS status_value,
    COUNT(*) AS passenger_count,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM airline_satisfaction
GROUP BY CASE WHEN Arrival_Delay_in_Minutes = 0 THEN 'On-Time Arrival' ELSE 'Delayed Arrival' END;

-- ============================================================================

-- 6. DELAY IMPACT BY TRAVEL TYPE
-- How delays affect business vs personal travelers
WITH delay_status AS (
    SELECT
        *,
        CASE WHEN Departure_Delay_in_Minutes = 0 THEN 'On Time' ELSE 'Delayed' END AS dep_status,
        CASE WHEN Arrival_Delay_in_Minutes = 0 THEN 'On Time' ELSE 'Delayed' END AS arr_status
    FROM airline_satisfaction
)
SELECT
    Type_of_Travel,
    'Departure' AS delay_type,
    dep_status,
    COUNT(*) AS passenger_count,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM delay_status
WHERE Type_of_Travel IS NOT NULL
GROUP BY Type_of_Travel, dep_status
UNION ALL
SELECT
    Type_of_Travel,
    'Arrival' AS delay_type,
    arr_status,
    COUNT(*) AS passenger_count,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM delay_status
WHERE Type_of_Travel IS NOT NULL
GROUP BY Type_of_Travel, arr_status
ORDER BY Type_of_Travel, delay_type;

-- ============================================================================

-- 7. DELAY IMPACT BY CLASS
-- How delays affect different service classes
WITH delay_status AS (
    SELECT
        *,
        CASE WHEN Departure_Delay_in_Minutes = 0 THEN 'On Time' ELSE 'Delayed' END AS dep_status
    FROM airline_satisfaction
)
SELECT
    Class,
    dep_status,
    COUNT(*) AS passenger_count,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM delay_status
WHERE Class IS NOT NULL
GROUP BY Class, dep_status
ORDER BY Class,
    CASE WHEN dep_status = 'On Time' THEN 1 ELSE 2 END;

-- ============================================================================

-- 8. COMBINED DEPARTURE AND ARRIVAL DELAY ANALYSIS
-- Passengers experiencing both delays vs only one vs neither
WITH combined_delays AS (
    SELECT
        *,
        CASE
            WHEN Departure_Delay_in_Minutes = 0 AND Arrival_Delay_in_Minutes = 0 THEN 'Both On Time'
            WHEN Departure_Delay_in_Minutes > 0 AND Arrival_Delay_in_Minutes = 0 THEN 'Departure Delayed Only'
            WHEN Departure_Delay_in_Minutes = 0 AND Arrival_Delay_in_Minutes > 0 THEN 'Arrival Delayed Only'
            WHEN Departure_Delay_in_Minutes > 0 AND Arrival_Delay_in_Minutes > 0 THEN 'Both Delayed'
        END AS combined_delay_status
    FROM airline_satisfaction
)
SELECT
    combined_delay_status,
    COUNT(*) AS passenger_count,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM combined_delays
GROUP BY combined_delay_status
ORDER BY
    CASE
        WHEN combined_delay_status = 'Both On Time' THEN 1
        WHEN combined_delay_status = 'Departure Delayed Only' THEN 2
        WHEN combined_delay_status = 'Arrival Delayed Only' THEN 3
        WHEN combined_delay_status = 'Both Delayed' THEN 4
    END;

-- ============================================================================

-- 9. DELAY SEVERITY AND SERVICE RATINGS
-- How delay severity correlates with service satisfaction
WITH delay_categories AS (
    SELECT
        *,
        CASE
            WHEN Departure_Delay_in_Minutes = 0 THEN 'On Time'
            WHEN Departure_Delay_in_Minutes > 0 AND Departure_Delay_in_Minutes <= 30 THEN 'Minor (1-30 min)'
            WHEN Departure_Delay_in_Minutes > 30 AND Departure_Delay_in_Minutes <= 120 THEN 'Moderate (31-120 min)'
            WHEN Departure_Delay_in_Minutes > 120 THEN 'Severe (120+ min)'
        END AS delay_category
    FROM airline_satisfaction
)
SELECT
    delay_category,
    COUNT(*) AS passenger_count,
    ROUND(AVG(CAST(On_board_service AS FLOAT)), 2) AS avg_onboard_service,
    ROUND(AVG(CAST(Seat_comfort AS FLOAT)), 2) AS avg_seat_comfort,
    ROUND(AVG(CAST(Inflight_entertainment AS FLOAT)), 2) AS avg_entertainment,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM delay_categories
GROUP BY delay_category
ORDER BY
    CASE
        WHEN delay_category = 'On Time' THEN 1
        WHEN delay_category = 'Minor (1-30 min)' THEN 2
        WHEN delay_category = 'Moderate (31-120 min)' THEN 3
        WHEN delay_category = 'Severe (120+ min)' THEN 4
    END;

-- ============================================================================

-- 10. EXTREME DELAY ANALYSIS
-- Analyze passengers with very large delays (100+ minutes)
SELECT
    'EXTREME DELAYS (100+ min)' AS analysis_type,
    COUNT(*) AS passenger_count,
    SUM(CASE WHEN Departure_Delay_in_Minutes >= 100 THEN 1 ELSE 0 END) AS departure_extreme,
    SUM(CASE WHEN Arrival_Delay_in_Minutes >= 100 THEN 1 ELSE 0 END) AS arrival_extreme,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM airline_satisfaction;

-- ============================================================================
-- END OF DELAY ANALYSIS
-- ============================================================================
