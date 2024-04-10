use airhub; 

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
    @BaggageSize Varchar(255),
    @TicketID VARCHAR(255) OUTPUT,
    @Message VARCHAR(255) OUTPUT,
    @PaymentMethod VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check availability of seats on the flight
    DECLARE @Capacity INT, @BookedSeats INT, @PaymentID NVARCHAR(255);
    SELECT @Capacity = Capacity, @BookedSeats = BookedSeats
    FROM Flight
    WHERE FlightID = @FlightID;
    SELECT @PaymentID = PaymentID
    FROM Payment
    WHERE PaymentMethod = @PaymentMethod

    -- Check for passenger name, passenger email and password field should not be blank

    IF (@PassengerName IS NULL OR @PassengerName = '')
    BEGIN
        SET @message = 'Passenger name cannot be empty or null.';
        RETURN;
    END
    ELSE IF (@PassengerEmail IS NULL OR @PassengerEmail = '')
    BEGIN
        SET @message = 'Passenger email cannot be empty or null.';
        RETURN;
    END
    ELSE IF (@PassengerPassport IS NULL OR @PassengerPassport = '')
    BEGIN
        SET @message = 'Passenger passport cannot be empty or null.';
        RETURN;
    END

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


        IF NOT EXISTS(select * from Passenger where PassportNumber = @PassengerPassport and PassengerID = @NewPassengerID)   
            BEGIN
            Declare @Price FLOAT;
            SELECT @Price = Price
            from Ticket
            WHERE FlightID = @FlightID

            -- Generate a new TicketID
            DECLARE @NewTicketID VARCHAR(255) = 'TKT' + CAST(NEXT VALUE FOR Seq_TicketID AS VARCHAR(7));
            -- Insert a new ticket entry with the generated TicketID


-- Check if the provided @SeatNumber is empty
            IF(@SeatNumber = '')
            BEGIN
                DECLARE @numericPart NVARCHAR(50);
                DECLARE @letterPart NVARCHAR(50);
                DECLARE @ExistingCount INT;
                WHILE (1 = 1)
                BEGIN
                    SET @numericPart = CAST(NEXT VALUE FOR Seq_UniqueSeatNumber AS INT) % 10 + 1;
                    SET @letterPart = CHAR(ASCII('A') + CAST(NEXT VALUE FOR Seq_UniqueSeatNumber AS INT) % 10);
                    SET @SeatNumber = @numericPart + @letterPart;

                    SELECT @ExistingCount = COUNT(*)
                    FROM Ticket
                    WHERE FlightID = @FlightID
                        AND SeatNumber = @SeatNumber;

                    IF @ExistingCount = 0
                        BREAK;
                END

                INSERT INTO Ticket
                    (TicketID, FlightID, SeatNumber, Price)
                VALUES
                    (@NewTicketID, @FlightID, @SeatNumber, @Price);
            END

            ELSE IF EXISTS(select * from Ticket where FlightID = @FlightID and SeatNumber = @SeatNumber)
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
            INSERT into Passenger
                (PassengerID, UserID, TicketID, [Name], Email, PassportNumber)
            VALUES(@NewPassengerID, @UserID, @NewTicketID, @PassengerName, @PassengerEmail, @PassengerPassport)
        END

        -- Insert a new booking entry
        INSERT INTO Booking
            (PaymentID, TicketID, [Date], BookingStatus, Class)
        VALUES
            (@PaymentID, @TicketID, @BookingDate, 'Confirmed', @Class);

        SELECT @BookingID = CAST(SCOPE_IDENTITY() AS INT);

        -- Logic to apply the discount to the original price based on loyalty 
        DECLARE @discountpercentage DECIMAL(5, 2);
        select @discountpercentage = dbo.GetDiscountPercentageByUserID(@UserID);
        update t
            SET t.Price = CAST(t.Price * (1 - @discountpercentage / 100) AS INT)
            FROM UserAccount ua JOIN LoyaltyProgram lp ON ua.LoyaltyID = lp.LoyaltyID
            JOIN Passenger p ON p.UserID = ua.UserID
            JOIN Ticket t ON t.TicketID = p.TicketID
            WHERE ua.UserID = @UserID AND p.PassengerID = @NewPassengerID;

        IF NOT EXISTS(select * from Baggage where PassengerID = @NewPassengerID)
            BEGIN
                DECLARE @BaggageID Nvarchar(255);
                SET @numericPart = CAST(NEXT VALUE FOR Seq_BaggageID AS INT) % 10 + 1; -- Assuming the numeric part starts from 1 and goes up to 10
                SET @letterPart = CHAR(ASCII('A') + CAST(NEXT VALUE FOR Seq_BaggageID AS INT) % 10);
                SET @BaggageID = @numericPart + @letterPart 
                INSERT into Baggage(BaggageID, PassengerID, [Size], [Status])
                VALUES(@BaggageID, @NewPassengerID, @BaggageSize, 'Checked')
            END
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