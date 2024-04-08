use Airhub;

-- GO
-- CREATE OR ALTER VIEW vw_PassengerItinerary AS
-- SELECT ua.UserID, ua.Name AS UserName, ua.Email,
--        fs.FlightScheduleID, fs.FlightID, fs.DepartureTime, fs.ArrivalTime, fs.Date,
--        f.AirlineName, f.DepartingGate, f.ArrivingGate,
--        da.Name AS DepartingAirport, aa.Name AS ArrivingAirport
-- FROM UserAccount ua
-- JOIN FlightSchedule fs ON ua.UserID = fs.UserID
-- JOIN Flight f ON fs.FlightID = f.FlightID
-- JOIN Airport da ON f.DepartingAirportID = da.AirportID
-- JOIN Airport aa ON f.ArrivingAirportID = aa.AirportID;

SELECT * FROM vw_PassengerItinerary;

-- GO
-- CREATE OR ALTER VIEW vw_AvailableFlights AS
-- SELECT 
--     f.FlightID,
--     f.AirlineName,
--     a1.Name AS DepartingAirport,
--     a2.Name AS ArrivingAirport,
--     f.DepartingGate,
--     f.ArrivingGate,
--     f.Capacity,
--     f.BookedSeats,
--     (f.Capacity - f.BookedSeats) AS AvailableSeats
-- FROM Flight f
-- JOIN Airport a1 ON f.DepartingAirportID = a1.AirportID
-- JOIN Airport a2 ON f.ArrivingAirportID = a2.AirportID;

-- SELECT * FROM vw_AvailableFlights;

--  GO
-- CREATE VIEW vw_BookingDetails AS
-- SELECT
--     b.BookingID,
--     b.Date AS BookingDate,
--     b.BookingStatus,
--     b.Class,
--     p.PassengerID,
--     p.Name AS PassengerName,
--     p.Email AS PassengerEmail,
--     f.FlightID,
--     f.DepartingGate,
--     f.ArrivingGate,
--     f.AirlineName,
--     a1.Name AS DepartingAirport,
--     a2.Name AS ArrivingAirport,
--     t.TicketID,
--     t.SeatNumber,
--     t.Price AS TicketPrice,
--     pm.PaymentMethod
-- FROM Booking b
-- JOIN Ticket t ON b.TicketID = t.TicketID
-- JOIN Flight f ON t.FlightID = f.FlightID
-- JOIN Airport a1 ON f.DepartingAirportID = a1.AirportID
-- JOIN Airport a2 ON f.ArrivingAirportID = a2.AirportID
-- JOIN Passenger p ON p.PassengerID = (SELECT TOP 1 PassengerID FROM FlightSchedule WHERE FlightID = f.FlightID ORDER BY Date DESC)
-- JOIN Payment pm ON b.PaymentID = pm.PaymentID;

Select * from vw_BookingDetails;