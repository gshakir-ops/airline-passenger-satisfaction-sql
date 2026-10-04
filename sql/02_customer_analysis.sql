-- ============================================================================
-- AIRLINE PASSENGER SATISFACTION ANALYSIS
-- Customer Demographics & Segmentation Analysis
-- ============================================================================
-- Purpose: Analyze satisfaction patterns by demographic and customer characteristics
-- ============================================================================

-- 1. SATISFACTION RATE BY GENDER
-- Understand how gender relates to satisfaction outcomes
SELECT
    Gender,
    COUNT(*) AS total_passengers,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    SUM(CASE WHEN satisfaction = 'False' THEN 1 ELSE 0 END) AS dissatisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM airline_satisfaction
WHERE Gender IS NOT NULL
GROUP BY Gender
ORDER BY satisfaction_rate_pct DESC;

-- ============================================================================

-- 2. SATISFACTION RATE BY CUSTOMER TYPE
-- Compare loyalty status and satisfaction
SELECT
    Customer_Type,
    COUNT(*) AS total_passengers,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    SUM(CASE WHEN satisfaction = 'False' THEN 1 ELSE 0 END) AS dissatisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM airline_satisfaction
WHERE Customer_Type IS NOT NULL
GROUP BY Customer_Type
ORDER BY satisfaction_rate_pct DESC;

-- ============================================================================

-- 3. AGE GROUP ANALYSIS
-- Create meaningful age groups and analyze satisfaction by age group
WITH age_groups AS (
    SELECT
        *,
        CASE
            WHEN Age < 13 THEN '0-12 (Child)'
            WHEN Age >= 13 AND Age < 18 THEN '13-17 (Teen)'
            WHEN Age >= 18 AND Age < 25 THEN '18-24 (Young Adult)'
            WHEN Age >= 25 AND Age < 35 THEN '25-34 (Adult)'
            WHEN Age >= 35 AND Age < 50 THEN '35-49 (Mid-Age)'
            WHEN Age >= 50 AND Age < 65 THEN '50-64 (Senior)'
            WHEN Age >= 65 THEN '65+ (Elderly)'
        END AS age_group
    FROM airline_satisfaction
)
SELECT
    age_group,
    COUNT(*) AS total_passengers,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    SUM(CASE WHEN satisfaction = 'False' THEN 1 ELSE 0 END) AS dissatisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct,
    ROUND(AVG(CAST(Age AS FLOAT)), 1) AS avg_age_in_group
FROM age_groups
GROUP BY age_group
ORDER BY
    CASE
        WHEN age_group = '0-12 (Child)' THEN 1
        WHEN age_group = '13-17 (Teen)' THEN 2
        WHEN age_group = '18-24 (Young Adult)' THEN 3
        WHEN age_group = '25-34 (Adult)' THEN 4
        WHEN age_group = '35-49 (Mid-Age)' THEN 5
        WHEN age_group = '50-64 (Senior)' THEN 6
        WHEN age_group = '65+ (Elderly)' THEN 7
    END;

-- ============================================================================

-- 4. GENDER AND CUSTOMER TYPE CROSS-TABULATION
-- Analyze satisfaction by gender and loyalty combination
SELECT
    Gender,
    Customer_Type,
    COUNT(*) AS total_passengers,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM airline_satisfaction
WHERE Gender IS NOT NULL AND Customer_Type IS NOT NULL
GROUP BY Gender, Customer_Type
ORDER BY satisfaction_rate_pct DESC;

-- ============================================================================

-- 5. CUSTOMER TYPE AND AGE GROUP INTERACTION
-- Identify which customer/age combinations have best satisfaction
WITH age_groups AS (
    SELECT
        *,
        CASE
            WHEN Age < 18 THEN 'Under 18'
            WHEN Age >= 18 AND Age < 35 THEN '18-34'
            WHEN Age >= 35 AND Age < 50 THEN '35-49'
            WHEN Age >= 50 THEN '50+'
        END AS age_group
    FROM airline_satisfaction
)
SELECT
    Customer_Type,
    age_group,
    COUNT(*) AS total_passengers,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM age_groups
WHERE Customer_Type IS NOT NULL AND age_group IS NOT NULL
GROUP BY Customer_Type, age_group
ORDER BY Customer_Type,
    CASE
        WHEN age_group = 'Under 18' THEN 1
        WHEN age_group = '18-34' THEN 2
        WHEN age_group = '35-49' THEN 3
        WHEN age_group = '50+' THEN 4
    END;

-- ============================================================================

-- 6. DEMOGRAPHIC SEGMENT IDENTIFICATION
-- Identify highest-performing demographic segments
WITH segment_analysis AS (
    SELECT
        Gender,
        Customer_Type,
        COUNT(*) AS total_passengers,
        SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
        ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
    FROM airline_satisfaction
    WHERE Gender IS NOT NULL AND Customer_Type IS NOT NULL
    GROUP BY Gender, Customer_Type
)
SELECT
    'HIGHEST SATISFACTION SEGMENTS' AS segment_type,
    Gender,
    Customer_Type,
    total_passengers,
    satisfied_count,
    satisfaction_rate_pct
FROM segment_analysis
ORDER BY satisfaction_rate_pct DESC
UNION ALL
SELECT
    'LARGEST PASSENGER VOLUME SEGMENTS' AS segment_type,
    Gender,
    Customer_Type,
    total_passengers,
    satisfied_count,
    satisfaction_rate_pct
FROM segment_analysis
ORDER BY total_passengers DESC;

-- ============================================================================

-- 7. LOYALTY STATUS DEEP DIVE
-- Detailed analysis of loyal vs disloyal customer satisfaction
SELECT
    Customer_Type,
    Gender,
    COUNT(*) AS total_count,
    ROUND(AVG(CAST(Age AS FLOAT)), 1) AS avg_age,
    SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) AS satisfied_count,
    SUM(CASE WHEN satisfaction = 'False' THEN 1 ELSE 0 END) AS dissatisfied_count,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM airline_satisfaction
WHERE Customer_Type IS NOT NULL AND Gender IS NOT NULL
GROUP BY Customer_Type, Gender
ORDER BY Customer_Type, satisfaction_rate_pct DESC;

-- ============================================================================

-- 8. DEMOGRAPHIC SUMMARY TABLE
-- High-level overview of satisfaction by demographics
SELECT
    'Overall' AS demographic_category,
    'All Passengers' AS demographic_value,
    COUNT(*) AS total_passengers,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM airline_satisfaction
UNION ALL
SELECT
    'Gender' AS demographic_category,
    Gender AS demographic_value,
    COUNT(*) AS total_passengers,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM airline_satisfaction
WHERE Gender IS NOT NULL
GROUP BY Gender
UNION ALL
SELECT
    'Customer Type' AS demographic_category,
    Customer_Type AS demographic_value,
    COUNT(*) AS total_passengers,
    ROUND(100.0 * SUM(CASE WHEN satisfaction = 'True' THEN 1 ELSE 0 END) / COUNT(*), 2) AS satisfaction_rate_pct
FROM airline_satisfaction
WHERE Customer_Type IS NOT NULL
GROUP BY Customer_Type
ORDER BY demographic_category, satisfaction_rate_pct DESC;

-- ============================================================================
-- END OF CUSTOMER DEMOGRAPHICS ANALYSIS
-- ============================================================================
