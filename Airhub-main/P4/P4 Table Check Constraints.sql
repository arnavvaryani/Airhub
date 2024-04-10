use Airhub;

ALTER TABLE UserAccount
ADD CONSTRAINT CHK_UserAccount_Password CHECK (LEN([Password]) >= 8);
 
ALTER TABLE LoyaltyProgram
ADD CONSTRAINT CHK_LoyaltyProgram_FixedDiscount CHECK (FixedDiscount LIKE '%[%]');

ALTER TABLE Passenger
ADD CONSTRAINT CHK_Passenger_Email CHECK (Email LIKE '%@%.%');
 
ALTER TABLE Baggage
ADD CONSTRAINT CHK_Baggage_Status CHECK ([Status] IN ('Checked', 'Carry-On', 'Lost', 'Damaged'));
 
ALTER TABLE FlightSchedule
ADD CONSTRAINT CHK_FlightSchedule_Date CHECK ([Date] > '1900-01-01');
 
ALTER TABLE Airport
ADD CONSTRAINT CHK_Airport_Capacity CHECK (Capacity > 0);
 

ALTER TABLE Flight
ADD CONSTRAINT CHK_Flight_Capacity CHECK (Capacity >= BookedSeats);
 
ALTER TABLE Airline
ADD CONSTRAINT CHK_Airline_Code CHECK (Code > 0);
 
ALTER TABLE Booking
ADD CONSTRAINT CHK_BookingStatus CHECK (BookingStatus IN ('Confirmed', 'Cancelled', 'Pending'));
 
ALTER TABLE Payment
ADD CONSTRAINT CHK_Payment_Method CHECK (PaymentMethod IN ('Credit Card', 'Debit Card', 'PayPal', 'Bank Transfer'));
 
ALTER TABLE Ticket
ADD CONSTRAINT CHK_Ticket_Price CHECK (Price >= 0);