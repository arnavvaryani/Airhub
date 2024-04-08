use Airhub;

GO
CREATE FUNCTION dbo.CalculateAge (@Birthdate DATE)
RETURNS INT
AS
BEGIN
    RETURN (SELECT DATEDIFF(YEAR, @Birthdate, GETDATE()) - CASE
                WHEN MONTH(@Birthdate) > MONTH(GETDATE()) OR (MONTH(@Birthdate) = MONTH(GETDATE()) AND DAY(@Birthdate) > DAY(GETDATE()))
                THEN 1
                ELSE 0
            END);
END;
GO

ALTER TABLE Passenger
ADD Age AS dbo.CalculateAge(Birthdate);

SELECT * FROM Passenger;

GO
CREATE FUNCTION dbo.CalculateFlightDuration (@DepartureDateTime DATETIME, @ArrivalDateTime DATETIME)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(HOUR, @DepartureDateTime, @ArrivalDateTime);
END;
GO

ALTER TABLE FlightSchedule
ADD FlightDurationHours AS dbo.CalculateFlightDuration(DepartureTime, ArrivalTime);

SELECT * FROM FlightSchedule;


