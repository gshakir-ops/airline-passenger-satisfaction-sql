# Airline Passenger Satisfaction — Key Findings

## Executive summary
The repository contains **129,880 passenger records** across **22 analytical columns**. The target distribution reported by the source dataset is 71,087 satisfied (54.73%) and 58,793 dissatisfied (45.27%). Re-run `sql/01_data_quality.sql` to reproduce the figures from the repository table.

## 1. Customer profile
Customer type, travel purpose, and class show meaningful differences in observed satisfaction. Use `sql/02_customer_analysis.sql` and `sql/03_travel_analysis.sql` for the exact current rates rather than copying manually maintained figures.

## 2. Service experience
`sql/04_service_analysis.sql` ranks the 13 service dimensions by the average-rating gap between satisfied and dissatisfied passengers. It provides both a raw recorded view and a rated-only sensitivity view that excludes the zero survey code.

The analysis uses terms such as **rating gap**, **association**, and **difference between groups**. It does not label a service as a causal “driver.”

## 3. Operational performance
`sql/05_delay_analysis.sql` compares on-time and delayed departures and provides explicit delay bands. A 121+ minute band is a project-defined analytical threshold, not an industry standard.

## 4. Segmentation
`sql/06_segmentation.sql` ranks customer/travel/class combinations and identifies the largest high- and low-satisfaction segments while enforcing minimum segment sizes.

## 5. Advanced SQL
`sql/07_advanced_analysis.sql` demonstrates:
- PERCENTILE_CONT with a separate percentile CTE
- RANK and ROW_NUMBER
- windowed averages
- conditional aggregation
- multi-dimensional segment comparison

Trend analysis and CLV were removed because the dataset has no date, revenue, or longitudinal customer-history fields.

## Recommended business actions
1. Prioritize service dimensions with the largest measured rating gaps, using the rated-only sensitivity view as a check.
2. Investigate large underperforming segments before making operational changes.
3. Monitor delay bands separately rather than treating all delays as one group.
4. Treat zero survey codes as a methodology/data-quality consideration.
5. Validate operational changes with future measurement or experimentation before claiming causal impact.

## Evidence standard
Every numerical claim should be reproducible from the SQL files. If the repository data changes, regenerate the findings from SQL output rather than editing numbers manually.
