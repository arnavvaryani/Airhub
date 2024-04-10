use airhub;

GO
CREATE OR ALTER TRIGGER tr_UpdateBookedSeatsOnBookingStatusChange
ON Booking
AFTER UPDATE
AS
BEGIN
    IF UPDATE(BookingStatus) 
    BEGIN
        UPDATE f
        SET f.BookedSeats = f.BookedSeats - 1 
        FROM Flight f
        JOIN Ticket t on t.FlightID = f.FlightID
        JOIN inserted i on i.TicketID = t.TicketID 
        WHERE i.BookingStatus = 'Cancelled'; -- Only update when BookingStatus is 'Cancelled'
    END
END;
GO