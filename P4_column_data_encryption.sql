use Airhub;

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'DMDD@123';

CREATE CERTIFICATE UserEncryptCertificate WITH SUBJECT = 'Username Certificate';

-- Create the Symmetric Key using AES_256 algorithm
CREATE SYMMETRIC KEY UserKey WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE UserEncryptCertificate;

-- Encrypt the Password columns
OPEN SYMMETRIC KEY UserKey
DECRYPTION BY CERTIFICATE UserEncryptCertificate;

UPDATE UserAccount
SET 
    [Password] = EncryptByKey(Key_GUID('UserKey'), 'password123');

CLOSE SYMMETRIC KEY UserKey;

SELECT * FROM UserAccount;
