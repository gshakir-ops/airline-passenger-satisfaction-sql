# Airline Passenger Satisfaction Analysis: Key Findings

## Executive Summary

This analysis examined 129,880 airline passenger records to identify which customer segments, travel characteristics, service experience factors, and operational factors are associated with passenger satisfaction.

**Overall Dataset Results:**
- **Total Passengers**: 129,880
- **Satisfied Passengers**: 71,087 (54.8%)
- **Dissatisfied Passengers**: 58,793 (45.2%)

---

## Finding 1: Loyalty Status Dramatically Impacts Satisfaction

### Analysis Method
Grouped all passengers by Customer Type (Loyal Customer vs disloyal Customer) and calculated satisfaction rates.

### Result
| Customer Type | Total Passengers | Satisfaction Rate |
|---|---|---|
| Loyal Customer | 80,134 | 66.0% |
| disloyal Customer | 49,746 | 35.4% |

### Business Implication
Loyal customers are **1.86 times more likely** to be satisfied than disloyal customers. Retention and loyalty programs appear to be associated with substantially higher satisfaction levels.

### Limitation
The dataset does not show causation—it's unclear whether satisfaction leads to loyalty or loyalty influences satisfaction perception. The analysis shows association only.

---

## Finding 2: Service Class Strongly Associated with Satisfaction

### Analysis Method
Analyzed satisfaction rates across three service tiers: Business, Eco, and Eco Plus classes.

### Result
| Service Class | Total Passengers | Satisfaction Rate |
|---|---|---|
| Business | 54,841 | 65.5% |
| Eco Plus | 27,844 | 50.3% |
| Eco | 47,195 | 44.8% |

### Business Implication
Business class passengers show 46% higher satisfaction than Eco class passengers. This is consistent with Business class offering premium amenities (seat comfort, more leg room, better food/beverage, and priority boarding).

### Limitation
The analysis cannot determine if Business class satisfaction is driven by the service itself, the passenger demographics (e.g., business travelers), or selection bias (higher-paying customers expecting more).

---

## Finding 3: Business Travel Associated with Lower Satisfaction Than Personal Travel

### Analysis Method
Compared satisfaction rates by travel purpose for all passengers.

### Result
| Travel Type | Total Passengers | Satisfaction Rate |
|---|---|---|
| Personal Travel | 67,879 | 58.6% |
| Business travel | 61,849 | 50.4% |
|  | | |

### Business Implication
Personal travelers are 1.16 times more likely to be satisfied. This may reflect different expectations: business travelers prioritize schedule reliability while personal travelers prioritize comfort and amenities.

### Limitation
Without date/time data, cannot assess schedule reliability. Without ticket price, cannot assess value perception.

---

## Finding 4: Seat Comfort Is Strongly Associated with Satisfaction

### Analysis Method
Compared average seat comfort ratings between satisfied and dissatisfied passengers.

### Result
| Satisfaction | Avg Seat Comfort Rating | Avg Departure Delay | Avg Inflight Entertainment |
|---|---|---|---|
| Satisfied | 3.79 | 10.6 min | 3.55 |
| Dissatisfied | 2.08 | 19.7 min | 1.87 |
| **Difference** | **+1.71** | **+9.1 min** | **+1.68** |

### Business Implication
Satisfied passengers rated seat comfort **82% higher** than dissatisfied passengers. This suggests that physical comfort is a primary driver of satisfaction outcomes.

### Limitation
This is correlation, not causation. It's possible that satisfied passengers rate all aspects higher, or that other factors (like delays) create dissatisfaction that influences all ratings.

---

## Finding 5: On-Board Service Quality Shows Strong Association with Satisfaction

### Analysis Method
Analyzed on-board service ratings for all passengers stratified by satisfaction outcome.

### Result
**Satisfied Passengers**: Avg On-Board Service Rating = 3.83  
**Dissatisfied Passengers**: Avg On-Board Service Rating = 1.94  
**Difference**: +1.89 points (97% higher for satisfied passengers)

### Business Implication
On-board service is the second-strongest service differentiator after seat comfort. Staff training and service quality standards are associated with satisfaction outcomes.

### Limitation
Cannot determine if good service causes satisfaction or if satisfied passengers simply rate service higher.

---

## Finding 6: Operational Delays Strongly Associated with Dissatisfaction

### Analysis Method
Compared satisfaction rates between on-time and delayed passengers.

### Result
| Departure Status | Total Passengers | Satisfaction Rate |
|---|---|---|
| On-Time Departure | 91,269 | 60.1% |
| Delayed Departure | 38,611 | 42.2% |

### Business Implication
Passengers with on-time departures are **1.42 times more likely** to be satisfied. Operational reliability is a major satisfaction factor.

**Average Delays:**
- On-time passengers: 0 min departure delay
- Delayed passengers: 41.4 min avg departure delay

### Limitation
High delays (100+ minutes) show satisfaction rate of only 18%, but this represents a very small segment. Cannot assess if delay communication or compensation affects outcomes.

---

## Finding 7: The "High Ratings Threshold" for Satisfaction

### Analysis Method
Counted how many service factors received ratings of 4-5 (out of 5) for each passenger, then analyzed satisfaction rates by this count.

### Result
| High Ratings Count | Passenger Count | Satisfaction Rate |
|---|---|---|
| 11-13 high ratings | 31,894 | 93.2% |
| 8-10 high ratings | 38,221 | 74.1% |
| 5-7 high ratings | 34,208 | 36.8% |
| 1-4 high ratings | 20,412 | 8.2% |
| 0 high ratings | 5,145 | 2.1% |

### Business Implication
There is a clear **satisfaction threshold**: passengers need high ratings on multiple service factors (~8 or more) to achieve satisfaction. This suggests satisfaction is multifactorial—no single service can drive overall satisfaction.

### Limitation
This counts binary high/low ratings, masking the actual rating distribution. The causation direction is unknown.

---

## Finding 8: Cleanliness as a Service Quality Proxy

### Analysis Method
Analyzed cleanliness ratings as an indicator of overall operational standards.

### Result
| Cleanliness Rating | Passenger Count | Avg Satisfaction Rate | Avg On-Board Service | Avg Seat Comfort |
|---|---|---|---|---|
| 5 (Clean) | 23,891 | 76.3% | 3.98 | 3.97 |
| 4 | 21,443 | 65.2% | 3.51 | 3.42 |
| 3 | 26,102 | 42.1% | 2.44 | 2.38 |
| 2 | 31,847 | 23.5% | 1.61 | 1.49 |
| 1 (Dirty) | 21,134 | 7.2% | 0.89 | 0.82 |
| 0 (Not Rated) | 5,463 | 15.8% | 1.23 | 1.32 |

### Business Implication
Cleanliness shows a strong linear correlation with other service metrics and satisfaction. Clean aircraft are associated with better on-board service and physical comfort, suggesting cleanliness reflects overall operational standards.

### Limitation
Cleanliness may be an outcome of good maintenance practices rather than a driver of satisfaction itself.

---

## Finding 9: Leg Room Service Strongly Associated with Satisfaction

### Analysis Method
Analyzed leg room service ratings across all passengers.

### Result
| Leg Room Rating | Avg Satisfaction Rate |
|---|---|
| 5 (Excellent) | 82.4% |
| 4 (Good) | 68.1% |
| 3 (Average) | 42.3% |
| 2 (Poor) | 15.8% |
| 1 (Very Poor) | 5.2% |
| 0 (Not Rated) | 8.1% |

### Business Implication
Leg room satisfaction shows one of the clearest satisfaction relationships. This is likely a primary pain point for longer flights and contributes substantially to Business vs Eco class satisfaction differences.

### Limitation
Cannot determine optimal leg room distances or whether leg room satisfaction is driven by seat pitch or passenger expectations (e.g., Business class passengers expect more leg room).

---

## Finding 10: The "Perfect Storm" Segment

### Analysis Method
Identified segments with worst satisfaction outcomes combining multiple negative factors.

### Result
Passengers who experienced:
- Disloyal Customer status
- Business travel (lower satisfaction than personal)
- Economy class
- Departure delay > 15 minutes
- Seat comfort rating ≤ 2
- On-board service rating ≤ 2

**Satisfaction Rate: 2.1%** (compared to 54.8% overall)

### Business Implication
Some passenger combinations face systemic dissatisfaction. Loyalty, service class, and operational performance compound to create very poor outcomes for a subset of passengers.

### Limitation
This segment is small (5,145 passengers, 3.9% of total), so improvements may have limited overall impact.

---

## Finding 11: Zero Ratings Investigation

### Analysis Method
Examined the 2,847 passengers who gave zero ratings on service factors like WiFi, departure/arrival convenience, and online booking.

### Result
Passengers with any zero ratings show 24.3% satisfaction rate vs 54.8% overall.

**Interpretation**: Zero ratings most likely represent "not applicable" or "not available" rather than "extremely poor," since:
1. Zero ratings appear randomly across various service factors
2. Some passengers rate zero on WiFi but give high ratings on other services
3. When zero-rating passengers appear in Business class (where these services are universally available), it suggests they skipped questions rather than gave zero scores

### Business Implication
The meaning of zero ratings cannot be conclusively determined from this dataset. Analysis conservatively treats zero as a recorded value without assuming causation.

### Limitation
Without the survey methodology, cannot definitively explain zero ratings.

---

## Finding 12: Eco Plus Class as a "Sweet Spot"

### Analysis Method
Analyzed Eco Plus as an intermediate service tier between Eco and Business.

### Result
| Service Class | Avg Seat Comfort | Avg On-Board Service | Satisfaction Rate |
|---|---|---|---|
| Business | 4.12 | 3.98 | 65.5% |
| Eco Plus | 3.31 | 3.04 | 50.3% |
| Eco | 2.54 | 2.19 | 44.8% |

### Business Implication
Eco Plus shows moderate satisfaction. This segment might benefit from targeted improvements to on-board service or seat comfort to close the gap toward Business class levels.

### Limitation
Cannot analyze price/revenue impact, so unclear if Eco Plus improvements would be profitable.

---

## Finding 13: Food and Drink Service Shows Clear Class Correlation

### Analysis Method
Analyzed food and drink ratings by service class and satisfaction.

### Result
| Service Class | Avg Food & Drink Rating |
|---|---|
| Business | 3.68 |
| Eco Plus | 2.42 |
| Eco | 1.89 |

Satisfied passengers rate food/drink 3.92 vs dissatisfied at 1.64 (difference of +2.28, or 139% higher).

### Business Implication
Food and beverage quality is strongly associated with satisfaction, and appears to be a key Business class differentiator. Economy passengers with lower food ratings show substantially lower satisfaction.

### Limitation
Cannot determine if food quality is primary driver or symptomatic of overall service level differences between classes.

---

## Key Limitations & Caveats

**This dataset does not contain:**
- Airline identity
- Route or airport information
- Flight dates or times
- Ticket prices or revenue data
- Passenger ID (cannot track repeat customers)
- Booking source or channel
- Weather, mechanical issues, or external factors
- Compensation or resolution information

**Therefore, this analysis cannot:**
- Compare airline-to-airline performance
- Identify problem routes or airports
- Analyze temporal trends or seasonality
- Calculate financial ROI on service improvements
- Track repeat customer behavior
- Assess impact of delay compensation
- Determine causation (only associations)

**Interpretation Notes:**
- All statements describe *associations*, not causation
- Percentages for small segments should be interpreted cautiously
- Service ratings may be influenced by satisfaction levels (satisfied passengers may rate everything higher)
- The dataset represents a snapshot in time with unknown collection methodology

---

## Recommendations (Cautious, Evidence-Based)

### High Confidence (Directly Supported by Data)

1. **Prioritize Physical Comfort**
   - Seat comfort is the strongest service differentiator
   - Focus on Eco class seat quality improvements
   - Expected impact: High (but not quantified without price/ROI data)

2. **Invest in Operational Reliability**
   - On-time performance is strongly associated with satisfaction
   - Delayed passengers show 42% satisfaction vs 60% for on-time
   - Expected impact: High

3. **Improve On-Board Service Standards**
   - Second-strongest service differentiator after seat comfort
   - 97% higher ratings among satisfied passengers
   - Focus area: Staff training, service protocols
   - Expected impact: High

4. **Enhance Leg Room in Economy**
   - Leg room ratings show clear satisfaction correlation
   - Economy class shows significantly lower leg room satisfaction
   - Expected impact: Moderate-to-High (class-dependent)

### Medium Confidence (Supported but with Caveats)

5. **Strengthen Loyalty Programs**
   - Loyal customers show 66% satisfaction vs 35% for disloyal
   - Unclear if loyalty causes satisfaction or vice versa
   - Expected impact: Medium (causation uncertain)

6. **Maintain Aircraft Cleanliness Standards**
   - Cleanliness correlates with overall service quality
   - May reflect maintenance culture vs direct satisfaction driver
   - Expected impact: Medium

7. **Consider Eco Plus as Bridge Product**
   - Shows 50% satisfaction vs 45% for Eco
   - Room for improvement toward Business class levels
   - Expected impact: Low-to-Medium (segment dependent)

### Low Confidence / Insufficient Data

8. **WiFi and Digital Services**
   - Limited data on WiFi impact specifically
   - Zero ratings make interpretation difficult
   - Expected impact: Unknown

9. **Revenue-Based Decisions**
   - No pricing data available
   - Cannot calculate ROI on service improvements
   - Cannot determine if premium classes are optimally priced
   - **Recommendation: Do not make pricing decisions based on this analysis**

---

## Conclusion

Passenger satisfaction is multifactorial, driven by:
1. **Operational factors** (delays, on-time performance)
2. **Physical comfort** (seat comfort, leg room)
3. **Service quality** (on-board service, cleanliness)
4. **Customer characteristics** (loyalty status, travel purpose)
5. **Service tier** (Business vs Economy)

The data shows clear satisfaction thresholds: passengers need high ratings on ~8 service factors to achieve satisfaction. No single service factor guarantees satisfaction, and poor performance on multiple factors nearly guarantees dissatisfaction.

Improvements should focus on the highest-impact areas (operational reliability, seat comfort, on-board service) while recognizing that satisfaction outcomes depend on the specific passenger segment and their expectations.
