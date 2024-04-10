use Airhub;

INSERT INTO LoyaltyProgram (LoyaltyID, FixedDiscount) VALUES
('L001', '5%'),
('L002', '10%'),
('L003', '15%'),
('L004', '20%');
 
-- Insert dummy data into UserAccount
INSERT INTO UserAccount (UserID, LoyaltyID, [Name], Email, [Password]) VALUES
('U001', 'L001', 'John Doe', 'john.doe@example.com', 'password39493'),
('U002', 'L002', 'Jane Smith', 'jane.smith@example.com', 'password163'),
('U003', 'L003', 'Jim Bean', 'jim.bean@example.com', 'password133'),
('U004', 'L004', 'Jill Hill', 'jill.hill@example.com', 'password123'),
('U005', 'L001', 'Jake Lake', 'jake.lake@example.com', 'password143'),
('U006', 'L002', 'Judy May', 'judy.may@example.com', 'password103'),
('U007', 'L003', 'Joan Arc', 'joan.arc@example.com', 'password193'),
('U008', 'L004', 'Jack Pine', 'jack.pine@example.com', 'password19233'),
('U009', 'L002', 'Jess March', 'jess.march@example.com', 'password120403'),
('U010', 'L001', 'Joe April', 'joe.april@example.com', 'password1404023');
 
 -- Insert dummy data into Airport
INSERT INTO Airport (AirportID, [Name], Country, [State], City, Capacity) VALUES
('A001', 'Liberty International', 'United States', 'New York', 'New York City', 100000),
('A002', 'Democracy International', 'Canada', 'Ontario', 'Toronto', 200000),
('A003', 'Republic Airport', 'France', 'Île-de-France', 'Paris', 150000),
('A004', 'Constitution Airport', 'United Kingdom', 'England', 'London', 50000),
('A005', 'Union Terminal', 'Germany', 'Hesse', 'Frankfurt', 80000),
('A006', 'Independence Airfield', 'India', 'Maharashtra', 'Mumbai', 40000),
('A007', 'Federal Airport', 'Australia', 'New South Wales', 'Sydney', 75000),
('A008', 'Patriot Gateway', 'New Zealand', 'Auckland', 'Auckland', 60000),
('A009', 'Liberty Landing', 'Japan', 'Tokyo', 'Tokyo', 120000),
('A010', 'Justice Airpark', 'South Africa', 'Gauteng', 'Johannesburg', 30000),
('A011', 'Justice Plane', 'Pakistan', 'ABC', 'DEF', 30000);

-- Insert dummy data into Airline
INSERT INTO Airline (AirlineID, Code, [Name], Country) VALUES
('AR001', 101, 'Freedom Flyers', 'United States'),
('AR002', 102, 'Democracy Wings', 'Canada'),
('AR003', 103, 'Republic Airlines', 'France'),
('AR004', 104, 'Constitution Air', 'United Kingdom'),
('AR005', 105, 'Union Airways', 'Germany'),
('AR006', 106, 'Independence Air', 'India'),
('AR007', 107, 'Federal Flights', 'Australia'),
('AR008', 108, 'Patriot Sky', 'New Zealand'),
('AR009', 109, 'Liberty Lines', 'Japan'),
('AR010', 110, 'Justice Jets', 'South Africa');

INSERT INTO Flight (FlightID, DepartingAirportID, ArrivingAirportID, AirlineID, AirlineName, Capacity, BookedSeats, DepartingGate, ArrivingGate) VALUES
('FT001', 'A001', 'A002', 'AR001', 'Freedom Flyers', 200, 150, 'Gate 1', 'Gate 2'),
('FT002', 'A002', 'A003', 'AR002', 'Democracy Wings', 250, 200, 'Gate 2', 'Gate 3'),
('FT003', 'A003', 'A004', 'AR003', 'Republic Airlines', 300, 250, 'Gate 3', 'Gate 4'),
('FT004', 'A004', 'A005', 'AR004', 'Constitution Air', 350, 300, 'Gate 4', 'Gate 5'),
('FT005', 'A005', 'A006', 'AR005', 'Union Airways', 180, 130, 'Gate 5', 'Gate 6'),
('FT006', 'A006', 'A007', 'AR006', 'Independence Air', 220, 170, 'Gate 6', 'Gate 7'),
('FT007', 'A007', 'A008', 'AR007', 'Federal Flights', 280, 230, 'Gate 7', 'Gate 8'),
('FT008', 'A008', 'A009', 'AR008', 'Patriot Sky', 320, 270, 'Gate 8', 'Gate 9'),
('FT009', 'A009', 'A010', 'AR009', 'Liberty Lines', 200, 150, 'Gate 9', 'Gate 10'),
('FT010', 'A010', 'A011', 'AR010', 'Justice Jets', 240, 190, 'Gate 10', 'Gate 11');

INSERT INTO Ticket (TicketID, FlightID, SeatNumber, Price) VALUES
('TKT1000003', 'FT001', 'A1', 200),
('TKT1000004', 'FT002', 'A2', 220),
('TKT1000005', 'FT003', 'A3', 250),
('TKT1000006', 'FT004', 'B1', 230),
('TKT1000007', 'FT005', 'B2', 210),
('TKT1000008', 'FT006', 'B3', 240),
('TKT1000009', 'FT007', 'C1', 260),
('TKT1000010', 'FT008', 'C2', 220),
('TKT1000011', 'FT009', 'C3', 250),
('TKT1000012', 'FT010', 'D1', 240);

-- Insert dummy data into Passenger
INSERT INTO Passenger (PassengerID, UserID, [Name], TicketID, Email, PassportNumber) VALUES
('P001', 'U001', 'Chloe Sun', (SELECT TicketID FROM Ticket WHERE FlightID = 'FT001'), 'chloe.sun@example.com', 'P1234567'),
('P002', 'U002', 'Evan Moon',(SELECT TicketID FROM Ticket WHERE FlightID = 'FT002'), 'evan.moon@example.com', 'P2345678'),
('P003', 'U003', 'Grace Star',(SELECT TicketID FROM Ticket WHERE FlightID = 'FT003'), 'grace.star@example.com', 'P3456789'),
('P004', 'U004', 'Henry Comet', (SELECT TicketID FROM Ticket WHERE FlightID = 'FT004'), 'henry.comet@example.com', 'P4567890'),
('P005', 'U005', 'Isla Earth',(SELECT TicketID FROM Ticket WHERE FlightID = 'FT005'), 'isla.earth@example.com', 'P5678901'),
('P006', 'U006', 'Jack Mars',(SELECT TicketID FROM Ticket WHERE FlightID = 'FT006'), 'jack.mars@example.com', 'P6789012'),
('P007', 'U007', 'Kara Jupiter', (SELECT TicketID FROM Ticket WHERE FlightID = 'FT007'),'kara.jupiter@example.com', 'P7890123'),
('P008', 'U008', 'Liam Saturn', (SELECT TicketID FROM Ticket WHERE FlightID = 'FT008'),'liam.saturn@example.com', 'P8901234'),
('P009', 'U009', 'Mia Uranus', (SELECT TicketID FROM Ticket WHERE FlightID = 'FT009'),'mia.uranus@example.com', 'P9012345'),
('P010', 'U010', 'Noah Neptune',(SELECT TicketID FROM Ticket WHERE FlightID = 'FT010'), 'noah.neptune@example.com', 'P0123456');

-- Insert dummy data into Baggage
INSERT INTO Baggage (BaggageID, PassengerID, [Size], [Status]) VALUES
('B011', 'P001', 'Medium', 'Checked'),
('B012', 'P002', 'Large', 'Checked'),
('B013', 'P003', 'Small', 'Carry-On'),
('B014', 'P004', 'Medium', 'Checked'),
('B015', 'P005', 'Large', 'Lost'),
('B016', 'P006', 'Small', 'Carry-On'),
('B017', 'P007', 'Medium', 'Checked'),
('B018', 'P008', 'Large', 'Checked'),
('B019', 'P009', 'Small', 'Carry-On'),
('B020', 'P010', 'Medium', 'Checked');

-- Insert dummy data into FlightSchedule
INSERT INTO FlightSchedule (FlightScheduleID, UserID, FlightID, DepartureTime, ArrivalTime, [Date]) VALUES
('FS011', 'U001', 'FT001', '08:00', '11:00', '2024-08-11'),
('FS012', 'U002', 'FT002', '09:00', '12:00', '2024-08-12'),
('FS013', 'U003', 'FT003', '10:00', '13:00', '2024-08-13'),
('FS014', 'U004', 'FT004', '11:00', '14:00', '2024-08-14'),
('FS015', 'U005', 'FT005', '12:00', '15:00', '2024-08-15'),
('FS016', 'U006', 'FT006', '13:00', '16:00', '2024-08-16'),
('FS017', 'U007', 'FT007', '14:00', '17:00', '2024-08-17'),
('FS018', 'U008', 'FT008', '15:00', '18:00', '2024-08-18'),
('FS019', 'U009', 'FT009', '16:00', '19:00', '2024-08-19'),
('FS020', 'U010', 'FT010', '17:00', '20:00', '2024-08-20');

-- Insert dummy data into Payment

INSERT INTO Payment (PaymentID, PaymentMethod) VALUES
('PY001', 'Credit Card'),
('PY002', 'Debit Card'),
('PY003', 'Bank Transfer'),
('PY004', 'Paypal');


-- Corresponding Bookings must reference existing PaymentIDs
INSERT INTO Booking (PaymentID, TicketID, [Date], BookingStatus, Class) VALUES
('PY001', (SELECT TicketID FROM Ticket WHERE FlightID = 'FT001'), '2024-07-31', 'Confirmed', 'Economy'),
('PY002', (SELECT TicketID FROM Ticket WHERE FlightID = 'FT002'), '2024-08-01', 'Confirmed', 'Economy'),
('PY003', (SELECT TicketID FROM Ticket WHERE FlightID = 'FT003'), '2024-08-02', 'Cancelled', 'Business'),
('PY004', (SELECT TicketID FROM Ticket WHERE FlightID = 'FT004'), '2024-08-03', 'Pending', 'First Class'),
('PY003', (SELECT TicketID FROM Ticket WHERE FlightID = 'FT005'), '2024-08-04', 'Confirmed', 'Economy'),
('PY002', (SELECT TicketID FROM Ticket WHERE FlightID = 'FT006'), '2024-08-05', 'Pending', 'Business'),
('PY004', (SELECT TicketID FROM Ticket WHERE FlightID = 'FT007'), '2024-08-06', 'Confirmed', 'First Class'),
('PY001', (SELECT TicketID FROM Ticket WHERE FlightID = 'FT008'), '2024-08-07', 'Cancelled', 'Economy'),
('PY002', (SELECT TicketID FROM Ticket WHERE FlightID = 'FT009'), '2024-08-08', 'Confirmed', 'Economy'),
('PY003', (SELECT TicketID FROM Ticket WHERE FlightID = 'FT010'), '2024-08-09', 'Pending', 'Business');


SELECT * FROM FlightSchedule;
SELECT * FROM Passenger;
SELECT * FROM Baggage;
SELECT * FROM Airport;
SELECT * FROM Airline;
SELECT * FROM Flight;
SELECT * FROM Payment;
SELECT * FROM UserAccount;
SELECT * FROM LoyaltyProgram;
SELECT * FROM Booking;
SELECT * FROM Ticket;
