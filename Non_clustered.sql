use Airhub;

CREATE NONCLUSTERED INDEX IDX_UserAccount_LoyaltyID ON UserAccount(LoyaltyID);

CREATE NONCLUSTERED INDEX IDX_Flight_DepartingAirportID ON Flight(DepartingAirportID);
CREATE NONCLUSTERED INDEX IDX_Flight_ArrivingAirportID ON Flight(ArrivingAirportID);

CREATE NONCLUSTERED INDEX IDX_Booking_Date ON Booking([Date]);


SELECT * 
FROM UserAccount
WHERE LoyaltyID = 'L002';

SELECT * 
FROM Booking
WHERE [Date] BETWEEN '2024-07-01' AND '2024-07-31';

SELECT * 
FROM Flight 
WHERE DepartingAirportID = 'A001';

SELECT f.FlightID, a.Name as DepartingAirport
FROM Flight f
JOIN Airport a ON f.DepartingAirportID = a.AirportID
WHERE f.DepartingAirportID = 'A001';