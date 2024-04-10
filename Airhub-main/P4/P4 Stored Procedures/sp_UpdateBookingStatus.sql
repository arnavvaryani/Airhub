CREATE OR ALTER PROCEDURE sp_UpdateBookingStatus
    @TicketID NVARCHAR(50),
    @NewBookingStatus NVARCHAR(50)
AS
BEGIN
    -- update boooking status when we update pasenger booking status
    UPDATE Booking
    SET BookingStatus = @NewBookingStatus
    WHERE TicketID = @TicketID;

    EXEC sp_RemoveBaggageOnCancelled @TicketID

    SELECT @@ROWCOUNT AS 'RowsUpdated';
END;
