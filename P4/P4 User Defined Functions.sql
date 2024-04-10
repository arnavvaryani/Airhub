use Airhub;

GO
CREATE OR ALTER FUNCTION dbo.CalculateFlightDuration(@DepartureDateTime DATETIME, @ArrivalDateTime DATETIME)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(HOUR, @DepartureDateTime, @ArrivalDateTime);
END;
GO

ALTER TABLE FlightSchedule
ADD FlightDurationHours AS dbo.CalculateFlightDuration(DepartureTime, ArrivalTime);

select * from FlightSchedule;

go
CREATE OR ALTER FUNCTION dbo.GetDiscountPercentageByUserID (@UserID VARCHAR(255))
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @DiscountPercentage INT;

    SELECT @DiscountPercentage = CAST(REPLACE(FixedDiscount, '%', '') AS DECIMAL(5, 2))
    FROM LoyaltyProgram
    WHERE LoyaltyID = (
        SELECT ua.LoyaltyID
        FROM UserAccount ua
        WHERE ua.UserID = @UserID
    );

    RETURN @DiscountPercentage;
END;

