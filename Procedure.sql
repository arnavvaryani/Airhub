use Airhub;


GO
CREATE OR ALTER PROCEDURE sp_BookTicket
    @UserID VARCHAR(255),
    @FlightID VARCHAR(255),
    @Class VARCHAR(255),
    @PassengerName VARCHAR(255),
    @PassengerEmail VARCHAR(255),
    @PassengerPassport VARCHAR(255),
    @SeatNumber VARCHAR(255),
    @BookingDate DATE,
    @BookingID INT OUTPUT,
    -- Changed to INT to match the BookingID data type
    @TicketID VARCHAR(255) OUTPUT,
    -- This will now be generated within the procedure
    @Message VARCHAR(255) OUTPUT,
    @PaymentMethod VARCHAR(255)
-- Added PaymentMethod parameter for future use
AS
BEGIN
    SET NOCOUNT ON;


    -- Check availability of seats on the flight
    DECLARE @Capacity INT, @BookedSeats INT;
    SELECT @Capacity = Capacity, @BookedSeats = BookedSeats
    FROM Flight
    WHERE FlightID = @FlightID;
    SELECT @PaymentMethod = PaymentID
    FROM Payment
    WHERE PaymentMethod = 'Debit Card';

    IF @BookedSeats < @Capacity
    BEGIN

        Declare @NewPassengerID Nvarchar(255) = 'P' + CAST(NEXT VALUE FOR Seq_PassengerID AS NVARCHAR(10));

        IF EXISTS(SELECT *
        from Passenger
        where PassengerID = @NewPassengerID) -- check for same passenger id / throw error message 
            BEGIN
            SET @Message = 'Passenger cannot have old passenger details';
            RETURN;
        END

        IF EXISTS(SELECT *
        from Passenger
        where PassportNumber = @PassengerPassport) -- check for same passport id / throw error message 
            BEGIN
            SET @Message = 'Please provide correct passport details';
            RETURN;
        END


        IF NOT EXISTS(select *
        from Passenger
        where PassportNumber = @PassengerPassport and PassengerID = @NewPassengerID)
                    
                        BEGIN

            Declare @Price FLOAT;
            SELECT @Price = Price
            from Ticket
            WHERE FlightID = @FlightID

            -- Generate a new TicketID
            DECLARE @NewTicketID VARCHAR(255) = 'TKT' + CAST(NEXT VALUE FOR Seq_TicketID AS VARCHAR(7));
            -- Insert a new ticket entry with the generated TicketID

            IF(@SeatNumber = '')
                BEGIN
                    SET @SeatNumber = CAST(NEXT VALUE FOR Seq_UniqueSeatNumber as VARCHAR(3)) + 'F';
                    INSERT INTO Ticket
                        (TicketID, FlightID, SeatNumber, Price)
                    VALUES
                        (@NewTicketID, @FlightID, @SeatNumber, @Price);
                END
            ELSE
                IF EXISTS(select * from Ticket where FlightID = @FlightID and SeatNumber = @SeatNumber)
                    BEGIN
                        SET @Message = 'Please select another seat as it is already taken !';
                        RETURN;
                    END
                ELSE
                    BEGIN
                        INSERT INTO Ticket
                            (TicketID, FlightID, SeatNumber, Price)
                        VALUES
                            (@NewTicketID, @FlightID, @SeatNumber, @Price);
                    END

            -- Set the output TicketID parameter
            SET @TicketID = @NewTicketID;
            -- Generate new Passenger id against user id

            INSERT into Passenger
                (PassengerID, UserID, TicketID, [Name], Email, PassportNumber)
            VALUES(@NewPassengerID, @UserID, @NewTicketID, @PassengerName, @PassengerEmail, @PassengerPassport)
        END

        -- Insert a new booking entry
        -- Assuming PaymentID is either pre-generated or added later, an empty string might cause a foreign key constraint error if it's enforced. Consider handling PaymentID appropriately.
        INSERT INTO Booking
            (PaymentID, TicketID, [Date], BookingStatus, Class)
        VALUES
            (@PaymentMethod, @TicketID, @BookingDate, 'Confirmed', @Class);

        -- Retrieve the newly generated BookingID using SCOPE_IDENTITY() and set the output parameter
        SELECT @BookingID = CAST(SCOPE_IDENTITY() AS INT);
        -- Ensure correct data type casting

        -- Update the booked seats count
        UPDATE Flight
        SET BookedSeats = @BookedSeats + 1
        WHERE FlightID = @FlightID;

        SET @Message = 'Booking successful';
    END
    ELSE
    BEGIN
        SET @Message = 'No seats available';
    END

    RETURN;
END;
GO


-- Declare variables for the input parameters
DECLARE @UserID VARCHAR(255) = 'U001';
DECLARE @FlightID VARCHAR(255) = 'FT001';
DECLARE @Class VARCHAR(255) = 'Economy';
DECLARE @PassengerName VARCHAR(255) = 'David Bugrara';
Declare @PassengerEmail VARCHAR(255) = 'davidb1@gmail.com'
Declare @PassengerPassport Varchar(255) = 'DN0922188';
DECLARE @SeatNumber VARCHAR(255) = '';
DECLARE @BookingDate DATE = '2024-07-20';

-- Declare variables for the output parameters
DECLARE @BookingID INT;
DECLARE @TicketID VARCHAR(255);
DECLARE @Message VARCHAR(255);

-- Execute the stored procedure
EXEC sp_BookTicket
    @UserID = @UserID,
    @PassengerName = @PassengerName,
    @PassengerEmail = @PassengerEmail,
    @PassengerPassport = @PassengerPassport,
    @FlightID = @FlightID,
    @Class = @Class,
    @SeatNumber = @SeatNumber,
    @BookingDate = @BookingDate,
    @BookingID = @BookingID OUTPUT,
    @TicketID = @TicketID OUTPUT,
    @Message = @Message OUTPUT,
    @PaymentMethod = 'Credit Card'; -- Added PaymentMethod parameter

SELECT * FROM Ticket;
SELECT * FROM Booking;
SELECT * FROM Flight;

-- GO
-- CREATE PROCEDURE sp_UpdatePassengerInformation
--     @PassengerID VARCHAR(255),
--     @Name VARCHAR(255),
--     @Email VARCHAR(255),
--     @PassportNumber VARCHAR(255)
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     UPDATE Passenger
--     SET [Name] = @Name,
--         Email = @Email,
--         PassportNumber = @PassportNumber
--     WHERE PassengerID = @PassengerID;
-- END;
-- GO

-- EXEC sp_UpdatePassengerInformation
--     @PassengerID = 'P001', 
--     @Name = 'Alice NewName', 
--     @Email = 'alice.new@example.com', 
--     @PassportNumber = 'A7654421',
--     @PaymentMethod = 'Credit Card'; 

-- SELECT * FROM Passenger WHERE PassengerID = 'P001';