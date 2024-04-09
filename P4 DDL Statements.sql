CREATE DATABASE AirHub;
USE AirHub;


CREATE TABLE LoyaltyProgram (
    LoyaltyID VARCHAR(255) NOT NULL PRIMARY KEY,
    FixedDiscount VARCHAR(255)
);
 
CREATE TABLE UserAccount(
    UserID VARCHAR(255) NOT NULL PRIMARY KEY,
    LoyaltyID VARCHAR(255),
    [Name] VARCHAR(255),
    Email VARCHAR(255) UNIQUE,
    [Password] VARCHAR(255),
    FOREIGN KEY (LoyaltyID) REFERENCES LoyaltyProgram(LoyaltyID)
);
 
 CREATE TABLE Airport (
    AirportID VARCHAR(255) NOT NULL PRIMARY KEY,
    [Name] VARCHAR(255),
    Country VARCHAR(255),
    [State] VARCHAR(255),
    City VARCHAR(255),
    Capacity INT
);
 
CREATE TABLE Airline (
    AirlineID VARCHAR(255) NOT NULL PRIMARY KEY,
    Code INT,
    [Name] VARCHAR(255),
    Country VARCHAR(255)
);

 CREATE TABLE Flight (
    FlightID VARCHAR(255) NOT NULL PRIMARY KEY,
    DepartingAirportID VARCHAR(255),
    ArrivingAirportID VARCHAR(255),
    AirlineID VARCHAR(255),
    AirlineName VARCHAR(255),
    Capacity INT,
    BookedSeats INT,
    DepartingGate VARCHAR(255),
    ArrivingGate VARCHAR(255),
    FOREIGN KEY (DepartingAirportID) REFERENCES Airport(AirportID),
    FOREIGN KEY (ArrivingAirportID) REFERENCES Airport(AirportID),
    FOREIGN KEY (AirlineID) REFERENCES Airline(AirlineID)
);

CREATE SEQUENCE Seq_TicketID
START WITH 1000000
INCREMENT BY 1
MINVALUE 1000000
MAXVALUE 9999999
CYCLE;

CREATE SEQUENCE Seq_PassengerID
START WITH 100
INCREMENT BY 1
MINVALUE 100
MAXVALUE 9999999
CYCLE;

CREATE SEQUENCE Seq_BaggageID
START WITH 100
INCREMENT BY 1
MINVALUE 100
MAXVALUE 9999999
CYCLE;

CREATE TABLE Ticket (
    TicketID VARCHAR(255) NOT NULL PRIMARY KEY,
    FlightID VARCHAR(255),
    SeatNumber VARCHAR(255),
    Price VARCHAR(255),
    FOREIGN KEY (FlightID) REFERENCES Flight(FlightID)
);

CREATE TABLE Passenger (
    PassengerID VARCHAR(255) NOT NULL PRIMARY KEY,
    UserID VARCHAR(255),
    TicketID VARCHAR(255),
    [Name] VARCHAR(255),
    Email VARCHAR(255),
    PassportNumber VARCHAR(255)
    FOREIGN KEY (UserID) REFERENCES UserAccount(UserID),
    FOREIGN KEY (TicketID) REFERENCES Ticket(TicketID)
);
 
CREATE TABLE Baggage (
    BaggageID VARCHAR(255) NOT NULL PRIMARY KEY,
    PassengerID VARCHAR(255),
    [Size] VARCHAR(255),
    [Status] VARCHAR(255),
    FOREIGN KEY (PassengerID) REFERENCES Passenger(PassengerID)
);
 
CREATE TABLE FlightSchedule (
    FlightScheduleID VARCHAR(255) NOT NULL PRIMARY KEY,
    UserID VARCHAR(255),
    FlightID VARCHAR(255),
    DepartureTime VARCHAR(255),
    ArrivalTime VARCHAR(255),
    [Date] DATETIME,
    FOREIGN KEY (UserID) REFERENCES UserAccount(UserID),
    FOREIGN KEY (FlightID) REFERENCES Flight(FlightID)
);
 
 CREATE TABLE Payment (
    PaymentID VARCHAR(255) NOT NULL PRIMARY KEY,
    PaymentMethod VARCHAR(255)
);

CREATE TABLE Booking (
    BookingID INT IDENTITY(1,1) PRIMARY KEY,
    PaymentID VARCHAR(255),
    TicketID VARCHAR(255),
    [Date] DATE,
    BookingStatus VARCHAR(50),
    Class VARCHAR(255),
    FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID),
    FOREIGN KEY (TicketID) REFERENCES Ticket(TicketID)
);

-- Add CHECK constraints for UserAccount
ALTER TABLE UserAccount
ADD CONSTRAINT CHK_UserAccount_Password CHECK (LEN([Password]) >= 8);
 
-- Add CHECK constraints for LoyaltyProgram
ALTER TABLE LoyaltyProgram
ADD CONSTRAINT CHK_LoyaltyProgram_FixedDiscount CHECK (FixedDiscount LIKE '%[%]');
 
-- Add CHECK constraints for Passenger
ALTER TABLE Passenger
ADD CONSTRAINT CHK_Passenger_Email CHECK (Email LIKE '%@%.%');
 
-- Add CHECK constraints for Baggage
ALTER TABLE Baggage
ADD CONSTRAINT CHK_Baggage_Status CHECK ([Status] IN ('Checked', 'Carry-On', 'Lost', 'Damaged'));
 
-- Add CHECK constraints for FlightSchedule
ALTER TABLE FlightSchedule
ADD CONSTRAINT CHK_FlightSchedule_Date CHECK ([Date] > '1900-01-01');
 
-- Add CHECK constraints for Airport
ALTER TABLE Airport
ADD CONSTRAINT CHK_Airport_Capacity CHECK (Capacity > 0);
 
-- Add CHECK constraints for Flight
ALTER TABLE Flight
ADD CONSTRAINT CHK_Flight_Capacity CHECK (Capacity >= BookedSeats);
 
-- Add CHECK constraints for Airline
ALTER TABLE Airline
ADD CONSTRAINT CHK_Airline_Code CHECK (Code > 0);
 
-- Add CHECK constraints for Booking
ALTER TABLE Booking
ADD CONSTRAINT CHK_BookingStatus CHECK (BookingStatus IN ('Confirmed', 'Cancelled', 'Pending'));
 
-- Add CHECK constraints for Payment
ALTER TABLE Payment
ADD CONSTRAINT CHK_Payment_Method CHECK (PaymentMethod IN ('Credit Card', 'Debit Card', 'PayPal', 'Bank Transfer'));
 
-- Add CHECK constraints for Ticket
ALTER TABLE Ticket
ADD CONSTRAINT CHK_Ticket_Price CHECK (Price >= 0);