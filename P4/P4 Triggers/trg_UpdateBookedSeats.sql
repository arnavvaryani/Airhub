use Airhub; 

GO
CREATE TRIGGER trg_UpdateBookedSeats
ON Booking
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Update the BookedSeats count in the Flight table
    UPDATE Flight
    SET BookedSeats = BookedSeats + 1
    WHERE FlightID IN (SELECT FlightID FROM inserted i JOIN Ticket t ON i.TicketID = t.TicketID);
END;