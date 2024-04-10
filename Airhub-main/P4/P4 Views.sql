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

select * from vw_BookingDetails;
select * from vw_AvailableFlights;
select * from vw_PassengerBaggageDetails;