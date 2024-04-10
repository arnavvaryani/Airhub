CREATE OR ALTER PROCEDURE sp_RemoveBaggageOnCancelled
    @TicketID NVARCHAR(50)
AS
BEGIN
    -- check if baggage present when passenger ticket cancelled
    IF EXISTS(SELECT p.PassengerID,bg.* 
from Ticket t 
JOIN Passenger p on p.TicketID = t.TicketID
JOIN Baggage bg on bg.PassengerID = p.PassengerID
where t.TicketID = @TicketID)
    BEGIN
        --remove baggage details from table
        delete from bg
        from Ticket t
        JOIN Flight f on t.FlightID = f.FlightID
        JOIN Booking b on b.TicketID = t.TicketID
        JOIN Passenger p on p.TicketID = t.TicketID
        JOIN Baggage bg on bg.PassengerID = p.PassengerID
        where t.TicketID = @TicketID;
END

    SELECT @@ROWCOUNT AS 'RowsUpdated';
END;