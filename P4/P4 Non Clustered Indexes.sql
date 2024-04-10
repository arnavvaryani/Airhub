use Airhub;

CREATE NONCLUSTERED INDEX IDX_UserAccount_Email ON UserAccount(Email);
CREATE NONCLUSTERED INDEX IDX_Passenger_TicketID ON Passenger(TicketID);
CREATE NONCLUSTERED INDEX IDX_Passenger_PassportNumber ON Passenger(PassportNumber);

--examples

SELECT *
FROM UserAccount
WHERE Email = 'jane.smith@example.com';

SELECT *
FROM Passenger
WHERE TicketID = 'TKT1000004';

SELECT *
FROM Passenger
WHERE PassportNumber = 'P2345678';
