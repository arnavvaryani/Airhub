use Airhub;

GO
CREATE FUNCTION dbo.CalculateFlightDuration(@DepartureDateTime DATETIME, @ArrivalDateTime DATETIME)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(HOUR, @DepartureDateTime, @ArrivalDateTime);
END;
GO

ALTER TABLE FlightSchedule
ADD FlightDurationHours AS dbo.CalculateFlightDuration(DepartureTime, ArrivalTime);



