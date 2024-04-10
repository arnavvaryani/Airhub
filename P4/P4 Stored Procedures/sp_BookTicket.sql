USE airhub;
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
    @BaggageSize VARCHAR(255),
    @TicketID VARCHAR(255) OUTPUT,
    @Message VARCHAR(255) OUTPUT,
    @PaymentMethod VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        -- Check availability of seats on the flight
        DECLARE @Capacity INT, @BookedSeats INT, @PaymentID NVARCHAR(255);
        SELECT @Capacity = Capacity, @BookedSeats = BookedSeats
    FROM Flight
    WHERE FlightID = @FlightID;

        SELECT @PaymentID = PaymentID
    FROM Payment
    WHERE PaymentMethod = @PaymentMethod;

        -- Check for passenger name, passenger email, and passport field should not be blank
        IF (@PassengerName IS NULL OR @PassengerName = '')
        BEGIN
        SET @Message = 'Passenger name cannot be empty or null.';
        THROW 51000, @Message, 1;
    END
        ELSE IF (@PassengerEmail IS NULL OR @PassengerEmail = '')
        BEGIN
        SET @Message = 'Passenger email cannot be empty or null.';
        THROW 51000, @Message, 1;
    END
        ELSE IF (@PassengerPassport IS NULL OR @PassengerPassport = '')
        BEGIN
        SET @Message = 'Passenger passport cannot be empty or null.';
        THROW 51000, @Message, 1;
    END;

        IF @BookedSeats < @Capacity
        BEGIN
        DECLARE @NewPassengerID NVARCHAR(255) = 'P' + CAST(NEXT VALUE FOR Seq_PassengerID AS NVARCHAR(10));

        IF EXISTS (SELECT *
        FROM Passenger
        WHERE PassengerID = @NewPassengerID)
            BEGIN
            SET @Message = 'Passenger cannot have old passenger details';
            THROW 51000, @Message, 1;
        END;

        IF EXISTS (SELECT *
        FROM Passenger
        WHERE PassportNumber = @PassengerPassport)
            BEGIN
            SET @Message = 'Please provide correct passport details';
            THROW 51000, @Message, 1;
        END;

        DECLARE @Price FLOAT;
        SELECT @Price = Price
        FROM Ticket
        WHERE FlightID = @FlightID;

        DECLARE @NewTicketID VARCHAR(255) = 'TKT' + CAST(NEXT VALUE FOR Seq_TicketID AS VARCHAR(7));

        -- Check if the provided @SeatNumber is empty
        IF (@SeatNumber = '')
            BEGIN
            DECLARE @numericPart VARCHAR(50);
            DECLARE @letterPart VARCHAR(50);
            DECLARE @ExistingCount INT;

            WHILE (1 = 1)
                BEGIN
                SET @numericPart = CAST(NEXT VALUE FOR Seq_UniqueSeatNumber AS INT) % 10 + 1;
                SET @letterPart = CHAR(ASCII('A') + CAST(NEXT VALUE FOR Seq_UniqueSeatNumber AS INT) % 10);
                SET @SeatNumber = @numericPart + @letterPart;

                SELECT @ExistingCount = COUNT(*)
                FROM Ticket
                WHERE FlightID = @FlightID AND SeatNumber = @SeatNumber;

                IF @ExistingCount = 0
                        BREAK;
            END;

            INSERT INTO Ticket
                (TicketID, FlightID, SeatNumber, Price)
            VALUES
                (@NewTicketID, @FlightID, @SeatNumber, @Price);
        END
            ELSE IF EXISTS (SELECT *
        FROM Ticket
        WHERE FlightID = @FlightID AND SeatNumber = @SeatNumber)
            BEGIN
            SET @Message = 'Please select another seat as it is already taken!';
            THROW 51000, @Message, 1;
        END
            ELSE
            BEGIN
            INSERT INTO Ticket
                (TicketID, FlightID, SeatNumber, Price)
            VALUES
                (@NewTicketID, @FlightID, @SeatNumber, @Price);
        END;

        SET @TicketID = @NewTicketID;

        INSERT INTO Passenger
            (PassengerID, UserID, TicketID, [Name], Email, PassportNumber)
        VALUES
            (@NewPassengerID, @UserID, @NewTicketID, @PassengerName, @PassengerEmail, @PassengerPassport);

        INSERT INTO Booking
            (PaymentID, TicketID, [Date], BookingStatus, Class)
        VALUES
            (@PaymentID, @TicketID, @BookingDate, 'Confirmed', @Class);

        SELECT @BookingID = SCOPE_IDENTITY();

        DECLARE @discountpercentage DECIMAL(5, 2);
        SELECT @discountpercentage = dbo.GetDiscountPercentageByUserID(@UserID);

        UPDATE t
            SET t.Price = CAST(t.Price * (1 - @discountpercentage / 100) AS INT)
            FROM UserAccount ua
            JOIN LoyaltyProgram lp ON ua.LoyaltyID = lp.LoyaltyID
            JOIN Passenger p ON p.UserID = ua.UserID
            JOIN Ticket t ON t.TicketID = p.TicketID
            WHERE ua.UserID = @UserID AND p.PassengerID = @NewPassengerID;

        DECLARE @IsUnique BIT = 0;
        DECLARE @BaggageID VARCHAR(255);

        WHILE @IsUnique = 0
        BEGIN
            SET @numericPart = '';
            SET @letterPart = '';

            SET @numericPart = CAST(NEXT VALUE FOR Seq_BaggageID AS INT) % 10 + 1;
            SET @letterPart = CHAR(ASCII('A') + CAST(NEXT VALUE FOR Seq_BaggageID AS INT) % 10);
            SET @BaggageID = @numericPart + @letterPart;

            IF NOT EXISTS (SELECT *
            FROM Baggage
            WHERE BaggageID = @BaggageID)
        SET @IsUnique = 1;
        END;


        INSERT INTO Baggage
            (BaggageID, PassengerID, [Size], [Status])
        VALUES
            (@BaggageID, @NewPassengerID, @BaggageSize, 'Checked');

        UPDATE Flight
            SET BookedSeats = @BookedSeats + 1
            WHERE FlightID = @FlightID;

        SET @Message = 'Booking successful';
    END
        ELSE
        BEGIN
        SET @Message = 'No seats available';
        THROW 51000, @Message, 1;
    END;

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;

        SET @Message = ERROR_MESSAGE();
    END CATCH;

    RETURN;
END;
GO
