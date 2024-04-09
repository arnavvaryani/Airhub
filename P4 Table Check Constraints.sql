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