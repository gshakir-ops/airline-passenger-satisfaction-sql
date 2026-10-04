# Data Dictionary: Airline Passenger Satisfaction Dataset

## Dataset Overview
- **Total Records**: 129,880 passengers
- **Total Columns**: 22 variables
- **Target Variable**: satisfaction (binary: True/False)
- **Analysis Focus**: Identifying customer segments, travel characteristics, service factors, and operational factors associated with passenger satisfaction

---

## Column Definitions

| Column Name | Data Type | Variable Type | Range/Values | Analytical Role | Notes |
|---|---|---|---|---|---|
| **Gender** | String | Categorical | Male, Female | Demographic segmentation | Customer demographics |
| **Customer Type** | String | Categorical | Loyal Customer, disloyal Customer | Customer segmentation | Distinguishes repeat vs. infrequent fliers |
| **Age** | Integer | Numerical | 7-85 years | Demographic analysis | Used to create age groups for analysis |
| **Type of Travel** | String | Categorical | Business travel, Personal Travel | Travel purpose segmentation | Critical segmentation dimension |
| **Class** | String | Categorical | Business, Eco, Eco Plus | Service tier segmentation | Strongly influences service offerings and satisfaction |
| **Flight Distance** | Integer | Numerical | 96-4983 miles | Travel characteristics | Used to categorize short/medium/long haul flights |
| **Inflight wifi service** | Integer | Rating | 0-5 | Service quality metric | 0 = no rating/not rated; 1-5 = satisfaction rating |
| **Departure/Arrival time convenient** | Integer | Rating | 0-5 | Service quality metric | 0 = no rating; 1-5 = convenience rating |
| **Ease of Online booking** | Integer | Rating | 0-5 | Digital experience metric | 0 = no rating; 1-5 = ease rating |
| **Gate location** | Integer | Rating | 0-5 | Airport service metric | 0 = no rating; 1-5 = location convenience rating |
| **Food and drink** | Integer | Rating | 0-5 | Service quality metric | 0 = no rating; 1-5 = satisfaction rating |
| **Online boarding** | Integer | Rating | 0-5 | Digital experience metric | 0 = no rating; 1-5 = ease rating |
| **Seat comfort** | Integer | Rating | 0-5 | Service quality metric | 0 = no rating; 1-5 = comfort rating |
| **Inflight entertainment** | Integer | Rating | 0-5 | Service quality metric | 0 = no rating; 1-5 = satisfaction rating |
| **On-board service** | Integer | Rating | 0-5 | Service quality metric | 0 = no rating; 1-5 = quality rating |
| **Leg room service** | Integer | Rating | 0-5 | Service quality metric | 0 = no rating; 1-5 = adequacy rating |
| **Baggage handling** | Integer | Rating | 0-5 | Operational metric | 0 = no rating; 1-5 = handling quality rating |
| **Checkin service** | Integer | Rating | 0-5 | Operational metric | 0 = no rating; 1-5 = service quality rating |
| **Cleanliness** | Integer | Rating | 0-5 | Service quality metric | 0 = no rating; 1-5 = cleanliness rating |
| **Departure Delay in Minutes** | Float | Numerical | 0-1592 minutes | Operational metric | Minutes of delay; 0 = on-time departure |
| **Arrival Delay in Minutes** | Float | Numerical | 0-1584 minutes | Operational metric | Minutes of delay; 0 = on-time arrival |
| **satisfaction** | Boolean | Target Variable | True, False | Outcome variable | True = satisfied passenger; False = dissatisfied |

---

## Variable Groupings for Analysis

### Demographic Variables
- Gender
- Age

### Customer Profile Variables
- Customer Type
- Age (secondary)

### Travel Characteristics
- Type of Travel
- Class
- Flight Distance

### Service Rating Variables (13 total)
- Inflight wifi service
- Departure/Arrival time convenient
- Ease of Online booking
- Gate location
- Food and drink
- Online boarding
- Seat comfort
- Inflight entertainment
- On-board service
- Leg room service
- Baggage handling
- Checkin service
- Cleanliness

### Operational Variables
- Departure Delay in Minutes
- Arrival Delay in Minutes

### Target Variable
- satisfaction

---

## Data Quality Notes

### Zero Ratings in Service Metrics
Service rating columns contain 0 values. These are **NOT** coded as "extremely dissatisfied" but rather represent **no rating provided** or **not applicable**.

**Analytical Treatment**: 
- In aggregate analysis, 0 values are included in calculations
- In comparative analysis (e.g., satisfied vs. dissatisfied), 0 values are analyzed separately to understand their association with satisfaction
- When calculating average ratings for a segment, 0 values are included as recorded

**Rationale**: Without access to the data collection methodology, the most honest approach is to treat 0 as a distinct value and report its frequency and association with satisfaction outcomes.

### Age Outliers
Ages range from 7 to 85 years. Very young passengers (7-12) are present in the dataset, which may indicate children traveling with families. This is included in the analysis without modification.

### Delay Distribution
Departure and arrival delays are right-skewed (most flights on-time, some with significant delays). Maximum departure delay is 1,592 minutes (~26.5 hours); maximum arrival delay is 1,584 minutes (~26.4 hours).

---

## Column Naming for SQL
Original dataset uses readable names with spaces and special characters. For SQL compatibility, these are converted to snake_case:

| Original Column | SQL Column Name |
|---|---|
| Gender | Gender |
| Customer Type | Customer_Type |
| Age | Age |
| Type of Travel | Type_of_Travel |
| Class | Class |
| Flight Distance | Flight_Distance |
| Inflight wifi service | Inflight_wifi_service |
| Departure/Arrival time convenient | Departure_Arrival_time_convenient |
| Ease of Online booking | Ease_of_Online_booking |
| Gate location | Gate_location |
| Food and drink | Food_and_drink |
| Online boarding | Online_boarding |
| Seat comfort | Seat_comfort |
| Inflight entertainment | Inflight_entertainment |
| On-board service | On_board_service |
| Leg room service | Leg_room_service |
| Baggage handling | Baggage_handling |
| Checkin service | Checkin_service |
| Cleanliness | Cleanliness |
| Departure Delay in Minutes | Departure_Delay_in_Minutes |
| Arrival Delay in Minutes | Arrival_Delay_in_Minutes |
| satisfaction | satisfaction |

---

## Analytical Limitations

The dataset **does not contain**:
- Airline identity (cannot compare airline-to-airline)
- Route information (cannot analyze route-specific patterns)
- Airport information (cannot identify problem airports)
- Flight date/time (cannot analyze temporal trends)
- Ticket price (cannot analyze revenue or pricing impact)
- Passenger ID (cannot track repeat customers over time)
- Revenue or profitability data
- Booking source
- Seat assignment method
- Weather conditions
- Aircraft type

Therefore, this analysis **cannot reliably answer**:
- Which airline performs best
- Which routes are problematic
- Whether satisfaction improved over time
- Revenue impact of satisfaction improvements
- ROI on service quality investments
- Repeat customer behavior
- Seasonal patterns

These limitations are acknowledged in all findings and recommendations.

---

## Analysis Strategy

1. **Data Quality**: Verify data integrity before analysis
2. **Exploratory Analysis**: Understand distributions and relationships
3. **Segmentation**: Identify customer segments with different satisfaction levels
4. **Service Analysis**: Compare service ratings between satisfied and dissatisfied passengers
5. **Operational Analysis**: Examine impact of delays on satisfaction
6. **Advanced Analysis**: Use CTEs, window functions, and conditional aggregation for deeper insights
7. **Findings & Recommendations**: Translate insights into actionable recommendations

All findings are based on actual calculations from the dataset. No statistics are fabricated.
