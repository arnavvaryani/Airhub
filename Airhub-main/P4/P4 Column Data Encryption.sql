use Airhub;

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'DMDD@Airhub';

CREATE CERTIFICATE PasswordEncryptCertificate WITH SUBJECT = 'PasswordCertificate';

CREATE SYMMETRIC KEY PasswordKey WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE PasswordEncryptCertificate;

OPEN SYMMETRIC KEY PasswordKey
DECRYPTION BY CERTIFICATE PasswordEncryptCertificate;

UPDATE UserAccount
SET 
    [Password] = EncryptByKey(Key_GUID('PasswordKey'), [Password]);

CLOSE SYMMETRIC KEY PasswordKey;

SELECT * FROM UserAccount;

