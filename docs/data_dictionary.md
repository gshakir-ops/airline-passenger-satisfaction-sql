# Data Dictionary — Airline Passenger Satisfaction

## Dataset scope
This repository contains 129,880 passenger records and 22 analytical columns. The original public dataset contains additional fields; this repository uses a reduced analytical extract.

## Source
Maven Analytics — Airline Passenger Satisfaction. The public dataset is based on data attributed to John D. and distributed through Kaggle. See the repository README for the source link.

## Columns
| Column | Type | Role |
|---|---|---|
| Gender | text | Demographic |
| Customer_Type | text | Customer profile |
| Age | integer | Demographic |
| Type_of_Travel | text | Travel profile |
| Class | text | Travel profile |
| Flight_Distance | integer | Flight metric |
| Inflight_wifi_service | integer | Service rating, 0-5 |
| Departure_Arrival_time_convenient | integer | Service rating, 0-5 |
| Ease_of_Online_booking | integer | Service rating, 0-5 |
| Gate_location | integer | Service rating, 0-5 |
| Food_and_drink | integer | Service rating, 0-5 |
| Online_boarding | integer | Service rating, 0-5 |
| Seat_comfort | integer | Service rating, 0-5 |
| Inflight_entertainment | integer | Service rating, 0-5 |
| On_board_service | integer | Service rating, 0-5 |
| Leg_room_service | integer | Service rating, 0-5 |
| Baggage_handling | integer | Service rating, 0-5 |
| Checkin_service | integer | Service rating, 0-5 |
| Cleanliness | integer | Service rating, 0-5 |
| Departure_Delay_in_Minutes | integer | Operational |
| Arrival_Delay_in_Minutes | numeric | Operational; may be missing |
| satisfaction | text | Target; True/False |

## Zero-rating methodology
Zero is retained as a distinct survey code and is not converted to 1, NULL, or 5. Raw analyses may include zero as recorded; the service-gap sensitivity analysis also provides a rated-only view using values greater than 0. The project uses descriptive association language only.

## Derived categories
Age groups: Under 20, 20-30, 31-40, 41-50, 51-60, 61+.
Distance groups: Short <500, Medium 500-1499, Long >=1500.
Delay groups: On Time, 1-15, 16-60, 61-120, 121+ minutes. These are project-defined analytical bands.

## Limitations
No airline, route, airport, date, revenue, price, passenger ID, compensation, weather, or aircraft fields are present. Therefore the project cannot support airline comparison, time trends, revenue/ROI analysis, repeat-customer analysis, or causal claims.
