-- AIRLINE PASSENGER SATISFACTION
-- 00 - SQL Server / T-SQL setup
-- Run this file first. Adjust the CSV path for your machine.

IF OBJECT_ID('dbo.airline_satisfaction', 'U') IS NOT NULL
    DROP TABLE dbo.airline_satisfaction;
GO

CREATE TABLE dbo.airline_satisfaction (
    Gender NVARCHAR(20),
    Customer_Type NVARCHAR(30),
    Age INT,
    Type_of_Travel NVARCHAR(30),
    Class NVARCHAR(20),
    Flight_Distance INT,
    Inflight_wifi_service TINYINT,
    Departure_Arrival_time_convenient TINYINT,
    Ease_of_Online_booking TINYINT,
    Gate_location TINYINT,
    Food_and_drink TINYINT,
    Online_boarding TINYINT,
    Seat_comfort TINYINT,
    Inflight_entertainment TINYINT,
    On_board_service TINYINT,
    Leg_room_service TINYINT,
    Baggage_handling TINYINT,
    Checkin_service TINYINT,
    Cleanliness TINYINT,
    Departure_Delay_in_Minutes INT,
    Arrival_Delay_in_Minutes FLOAT NULL,
    satisfaction NVARCHAR(20)
);
GO

BULK INSERT dbo.airline_satisfaction
FROM 'C:\path\to\airline_passenger_satisfaction.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    TABLOCK
);
GO

SELECT COUNT(*) AS total_rows
FROM dbo.airline_satisfaction;
GO
