use Airhub;

GO
CREATE OR ALTER VIEW vw_PassengerBaggageDetails AS
SELECT p.Name,p.PassportNumber,p.Ticketid,t.* 
FROM Passenger p
JOIN Baggage t ON p.PassengerID = t.PassengerID

GO
CREATE OR ALTER VIEW vw_AvailableFlights AS
SELECT 
    f.FlightID,
    f.AirlineName,
    a1.Name AS DepartingAirport,
    a2.Name AS ArrivingAirport,
    f.DepartingGate,
    f.ArrivingGate,
    f.Capacity,
    f.BookedSeats,
    (f.Capacity - f.BookedSeats) AS AvailableSeats
FROM Flight f
JOIN Airport a1 ON f.DepartingAirportID = a1.AirportID
JOIN Airport a2 ON f.ArrivingAirportID = a2.AirportID;

 GO
CREATE VIEW vw_BookingDetails AS
SELECT
    b.BookingID,
    b.Date AS BookingDate,
    b.BookingStatus,
    b.Class,
    f.FlightID,
    f.DepartingGate,
    f.ArrivingGate,
    f.AirlineName,
    p.Name,
    p.Email,
    p.PassportNumber,
    a1.Name AS DepartingAirport,
    a2.Name AS ArrivingAirport,
    t.TicketID,
    t.SeatNumber,
    t.Price AS TicketPrice,
    pm.PaymentMethod
FROM Booking b
JOIN Ticket t ON b.TicketID = t.TicketID
JOIN Flight f ON t.FlightID = f.FlightID
JOIN Airport a1 ON f.DepartingAirportID = a1.AirportID
JOIN Airport a2 ON f.ArrivingAirportID = a2.AirportID
JOIN Payment pm ON b.PaymentID = pm.PaymentID
JOIN Passenger p on p.ticketid = t.ticketid

CREATE VIEW FlightDetailsView AS
SELECT 
    ft.FlightID,
    ft.DepartureAirport AS DepartureAirportCode,
    d.AirportName AS DepartureAirportName,
    ft.ArrivalAirport AS ArrivalAirportCode,
    a.AirportName AS ArrivalAirportName
FROM 
    (
    SELECT 
        'FT001' AS FlightID, 'A001' AS DepartureAirport, 'A002' AS ArrivalAirport UNION ALL
    SELECT 
        'FT002', 'A002', 'A003' UNION ALL
    SELECT 
        'FT003', 'A003', 'A004' UNION ALL
    SELECT 
        'FT004', 'A004', 'A005' UNION ALL
    SELECT 
        'FT005', 'A005', 'A006' UNION ALL
    SELECT 
        'FT006', 'A006', 'A007' UNION ALL
    SELECT 
        'FT007', 'A007', 'A008' UNION ALL
    SELECT 
        'FT008', 'A008', 'A009' UNION ALL
    SELECT 
        'FT009', 'A009', 'A010' UNION ALL
    SELECT 
        'FT010', 'A010', 'A011'
    ) AS ft
JOIN 
    (
    SELECT 
        'A001' AS AirportCode, 'Liberty International' AS AirportName, 'United States' AS Country UNION ALL
    SELECT 
        'A002', 'Democracy International', 'Canada' UNION ALL
    SELECT 
        'A003', 'Republic Airport', 'France' UNION ALL
    SELECT 
        'A004', 'Constitution Airport', 'United Kingdom' UNION ALL
    SELECT 
        'A005', 'Union Terminal', 'Germany' UNION ALL
    SELECT 
        'A006', 'Independence Airfield', 'India' UNION ALL
    SELECT 
        'A007', 'Federal Airport', 'Australia' UNION ALL
    SELECT 
        'A008', 'Patriot Gateway', 'New Zealand' UNION ALL
    SELECT 
        'A009', 'Liberty Landing', 'Japan' UNION ALL
    SELECT 
        'A010', 'Justice Airpark', 'South Africa' UNION ALL
    SELECT 
        'A011', 'Justice Plane', 'Pakistan'
    ) AS d ON ft.DepartureAirport = d.AirportCode
JOIN 
    (
    SELECT 
        'A001' AS AirportCode, 'Liberty International' AS AirportName, 'United States' AS Country UNION ALL
    SELECT 
        'A002', 'Democracy International', 'Canada' UNION ALL
    SELECT 
        'A003', 'Republic Airport', 'France' UNION ALL
    SELECT 
        'A004', 'Constitution Airport', 'United Kingdom' UNION ALL
    SELECT 
        'A005', 'Union Terminal', 'Germany' UNION ALL
    SELECT 
        'A006', 'Independence Airfield', 'India' UNION ALL
    SELECT 
        'A007', 'Federal Airport', 'Australia' UNION ALL
    SELECT 
        'A008', 'Patriot Gateway', 'New Zealand' UNION ALL
    SELECT 
        'A009', 'Liberty Landing', 'Japan' UNION ALL
    SELECT 
        'A010', 'Justice Airpark', 'South Africa' UNION ALL
    SELECT 
        'A011', 'Justice Plane', 'Pakistan'
    ) AS a ON ft.ArrivalAirport = a.AirportCode;

select * from vw_BookingDetails;
select * from vw_AvailableFlights;
select * from vw_PassengerBaggageDetails;
SELECT * from FlightDetailsView;
