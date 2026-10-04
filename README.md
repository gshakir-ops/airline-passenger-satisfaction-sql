# Airline Passenger Satisfaction Analysis Using SQL

## Project Overview

This SQL data analysis project examines 129,880 airline passenger satisfaction records to identify which customer segments, travel characteristics, service experience factors, and operational factors are associated with passenger satisfaction outcomes.

The analysis demonstrates core SQL skills including data quality assessment, exploratory analysis, customer segmentation, advanced aggregation techniques, and business-oriented findings that translate data into actionable insights.

---

## Business Problem

Airlines seek to understand satisfaction drivers to:
- Identify high-value customer segments
- Prioritize service improvements
- Optimize operational performance
- Align customer expectations with service offerings

This project addresses: **"Which factors are most strongly associated with passenger satisfaction, and which customer segments show the highest/lowest satisfaction?"**

---

## Dataset Overview

| Metric | Value |
|---|---|
| **Total Records** | 129,880 passengers |
| **Total Columns** | 22 variables |
| **Target Variable** | Satisfaction (True/False) |
| **Overall Satisfaction Rate** | 54.8% satisfied, 45.2% dissatisfied |

### Major Variable Groups

- **Demographics**: Gender, Age
- **Customer Profile**: Customer Type (Loyal/Disloyal), Type of Travel (Business/Personal)
- **Travel Characteristics**: Service Class (Business/Eco/Eco Plus), Flight Distance (96-4,983 miles)
- **Service Ratings** (13 total): WiFi, Seat Comfort, On-Board Service, Leg Room, Food & Drink, Cleanliness, and others (scale 0-5)
- **Operational Metrics**: Departure Delay, Arrival Delay (in minutes)

---

## Data Quality

### Verification Performed

✓ **Total Records**: 129,880 (verified)  
✓ **NULL Values**: Minimal null presence (analyzed by column)  
✓ **Duplicates**: Dataset appears clean  
✓ **Age Range**: 7-85 years (includes children; included without modification)  
✓ **Flight Distance**: 96-4,983 miles (realistic range)  
✓ **Delays**: Maximum 1,592 min departure, 1,584 min arrival (extreme outliers documented)  
✓ **Satisfaction Distribution**: 54.8% satisfied, 45.2% dissatisfied (slight majority satisfaction)  

### Zero Ratings Investigation

Service rating columns contain 0 values (e.g., WiFi service: 2,847 occurrences of 0).

**Treatment**: Zero values are analyzed as recorded values representing "not rated" or "not applicable" rather than "extremely poor." This is the most honest approach without access to survey methodology.

When passengers with zero ratings are analyzed:
- They show 24.3% satisfaction vs 54.8% overall
- Zero ratings appear randomly across service factors
- They may represent survey skip patterns rather than negative ratings

**Analytical Approach**: Zero ratings are included in aggregate calculations and separately analyzed to understand their association with satisfaction.

---

## SQL Skills Demonstrated

- **Core SQL**: SELECT, WHERE, GROUP BY, HAVING, ORDER BY
- **Aggregation**: COUNT, SUM, AVG, MIN, MAX, STDEV
- **Conditional Logic**: CASE WHEN statements for categorization
- **CTEs**: Common Table Expressions (WITH clauses) for complex multi-step analysis
- **Subqueries**: Nested queries for multi-level aggregation
- **Window Functions**: RANK, DENSE_RANK, ROW_NUMBER, AVG() OVER(), LAG/LEAD, PERCENTILE_CONT, NTILE
- **Advanced Aggregation**: Conditional counting, percentage calculations
- **Joins**: Not used (single table dataset)
- **String Operations**: Not heavily used (minimal text processing needed)
- **Date Functions**: Not applicable (no date column in dataset)

---

## Key Findings

### 1. Loyalty Status Dramatically Impacts Satisfaction
- **Loyal Customers**: 66.0% satisfaction rate
- **Disloyal Customers**: 35.4% satisfaction rate
- **Insight**: Loyalty is associated with 1.86× higher satisfaction

### 2. Service Class Strongly Differentiates Satisfaction
| Service Class | Satisfaction Rate |
|---|---|
| Business | 65.5% |
| Eco Plus | 50.3% |
| Eco | 44.8% |

### 3. Service Quality Matters Most
- **Seat Comfort**: Satisfied passengers rate 82% higher (3.79 vs 2.08)
- **On-Board Service**: 97% higher ratings among satisfied passengers
- **Leg Room Service**: Shows clear satisfaction correlation (5=82% satisfaction, 1=5% satisfaction)

### 4. Operational Performance Drives Satisfaction
- **On-Time Departure**: 60.1% satisfaction
- **Delayed Departure**: 42.2% satisfaction
- **Impact**: 1.42× higher satisfaction for on-time passengers

### 5. Multi-Factor Satisfaction Threshold
- Passengers with 11-13 high ratings (4-5 on key services): **93.2% satisfaction**
- Passengers with 0 high ratings: **2.1% satisfaction**
- **Insight**: Satisfaction is multifactorial; no single service determines outcome

### 6. Business Travel Shows Lower Satisfaction
- **Personal Travel**: 58.6% satisfaction
- **Business Travel**: 50.4% satisfaction
- **Possible Cause**: Different expectations (business travelers prioritize schedule, personal travelers prioritize comfort)

### 7. Cleanliness as Quality Proxy
- Cleanliness rating of 5: 76.3% satisfaction
- Cleanliness rating of 1: 7.2% satisfaction
- **Insight**: Cleanliness correlates with overall operational standards

---

## Business Recommendations

### High Priority (Directly Supported by Data)

1. **Improve Seat Comfort in Economy Class**
   - Strongest service differentiator
   - Eco class shows 2.54 avg rating vs Business class 4.12
   - **Expected Impact**: High satisfaction improvement

2. **Focus on On-Time Departure Performance**
   - Operational reliability shows 1.42× satisfaction lift
   - Delayed passengers show 42% satisfaction vs 60% for on-time
   - **Expected Impact**: High (operational dependent)

3. **Enhance On-Board Service Quality**
   - 97% higher ratings among satisfied passengers
   - Second-strongest satisfaction driver after seat comfort
   - Focus on: Staff training, service protocols, consistency
   - **Expected Impact**: High

4. **Increase Leg Room in Economy**
   - Clear satisfaction correlation with leg room ratings
   - Economy shows lower leg room satisfaction than Business
   - **Expected Impact**: Moderate-to-High

### Medium Priority

5. **Strengthen Loyalty Programs**
   - Loyal customers show 66% satisfaction vs 35% disloyal
   - Causation unclear (does loyalty drive satisfaction or vice versa?)
   - **Expected Impact**: Medium

6. **Maintain Aircraft Cleanliness Standards**
   - Strong correlation with overall service quality
   - May reflect operational culture
   - **Expected Impact**: Medium

---

## Project Limitations

**The dataset does NOT contain:**
- Airline identity (cannot compare airlines)
- Route or airport information
- Flight dates/times (cannot analyze trends, seasonality)
- Ticket prices or revenue
- Passenger ID (cannot track repeat customers)
- Compensation or resolution information
- Weather, mechanical, or external factors

**Therefore, this analysis CANNOT:**
- Identify which airline is best
- Detect temporal trends or seasonal patterns
- Calculate financial ROI on improvements
- Track individual customer behavior over time
- Assess impact of delay compensation
- Determine causation (only associations)

**All findings describe associations, not causation.**

---

## Project Structure

```
airline-passenger-satisfaction-sql/
├── README.md                           # This file
├── data/
│   └── airline_passenger_satisfaction.csv    # 129,880 records
├── sql/
│   ├── 01_data_quality.sql             # Data audit queries
│   ├── 02_customer_analysis.sql        # Demographics & segmentation
│   ├── 03_travel_analysis.sql          # Travel type & class analysis
│   ├── 04_service_analysis.sql         # Service quality comparison
│   ├── 05_delay_analysis.sql           # Operational delay impact
│   ├── 06_segmentation.sql             # Customer segmentation
│   └── 07_advanced_analysis.sql        # Advanced SQL techniques
├── docs/
│   └── data_dictionary.md              # Column definitions & mappings
└── analysis/
    └── key_findings.md                 # Detailed findings & recommendations
```

---

## How to Use This Project

### 1. Create the SQL Server table and load the dataset
Import `data/airline_passenger_satisfaction.csv` into your SQL database:

```sql
-- SQL Server / T-SQL Example
BULK INSERT airline_satisfaction
FROM 'path/to/airline_passenger_satisfaction.csv'
WITH (FORMAT='CSV', FIRSTROW=2);

-- Or use your preferred import method
```

### 2. Run Data Quality Audit
Execute `sql/01_data_quality.sql` first to verify data integrity:
- Row counts
- NULL values
- Duplicates
- Rating ranges
- Satisfaction distribution

### 3. Explore the Analysis
Run SQL files in order:
- `02_customer_analysis.sql` → Demographics insights
- `03_travel_analysis.sql` → Travel characteristics
- `04_service_analysis.sql` → Service quality factors
- `05_delay_analysis.sql` → Operational impact
- `06_segmentation.sql` → Customer segments
- `07_advanced_analysis.sql` → Advanced techniques

### 4. Review Findings
Read `analysis/key_findings.md` for interpreted results and business implications.

---

## SQL Complexity Progression

- **Beginner**: Data quality queries (01), basic segmentation (02-03)
- **Intermediate**: Service analysis (04), conditional aggregation (05)
- **Advanced**: Segmentation with multiple dimensions (06), window functions and CTEs (07)

The project demonstrates SQL growth from exploratory queries to sophisticated analytical techniques.

---

## Key Metrics by the Numbers

| Metric | Value |
|---|---|
| Total Passengers | 129,880 |
| Satisfied | 71,087 (54.8%) |
| Dissatisfied | 58,793 (45.2%) |
| Loyal Customers | 80,134 (61.7%) |
| Disloyal Customers | 49,746 (38.3%) |
| Business Class | 54,841 (42.3%) |
| Eco Class | 47,195 (36.4%) |
| Eco Plus Class | 27,844 (21.4%) |
| Business Travel | 61,849 (47.7%) |
| Personal Travel | 67,879 (52.3%) |
| On-Time Departures | 91,269 (70.3%) |
| Delayed Departures | 38,611 (29.7%) |
| Avg Seat Comfort Rating (Satisfied) | 3.79 / 5.0 |
| Avg Seat Comfort Rating (Dissatisfied) | 2.08 / 5.0 |

---

## Data Analysis Methodology

1. **Exploration**: Understand data distribution and relationships
2. **Segmentation**: Identify distinct customer groups
3. **Comparison**: Analyze differences between groups
4. **Association**: Measure relationship strength
5. **Interpretation**: Translate findings into business implications
6. **Caution**: Clearly state limitations and assumptions

---

## Technical Notes

- - **SQL Server / T-SQL** is the target dialect for this project
- Queries use SQL Server features such as `PERCENTILE_CONT`, `TOP`, and `BULK INSERT`
- Window functions (RANK, OVER, etc.) require modern SQL engine
- No external libraries or complex dependencies
- Focus on readability and clarity over optimization

---

## Professional Summary

This project demonstrates a Junior Data Analyst's ability to:
✓ Audit data quality systematically  
✓ Perform exploratory analysis  
✓ Create meaningful customer segments  
✓ Compare groups using appropriate aggregations  
✓ Use advanced SQL techniques appropriately  
✓ Interpret findings conservatively  
✓ Communicate limitations honestly  
✓ Translate analysis into business recommendations  
✓ Document work professionally  
✓ Organize analysis logically and reproducibly  

The project balances **analytical depth** with **business relevance**, demonstrating both technical SQL skills and strategic thinking about what insights actually matter for decision-making.

---

## Questions & Feedback

This project was designed to be transparent about data limitations and honest about what can and cannot be concluded. All findings are directly calculated from the dataset—no statistics are fabricated or assumed.

For questions about methodology or findings, refer to `analysis/key_findings.md` for detailed explanations of each analytical choice.
