USE CalendarShopDB;
GO
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

IF COL_LENGTH('dbo.Users', 'IsEmailConfirmed') IS NULL
BEGIN
    ALTER TABLE dbo.Users ADD IsEmailConfirmed BIT NOT NULL CONSTRAINT DF_Users_IsEmailConfirmed DEFAULT 1;
END
GO

IF COL_LENGTH('dbo.Users', 'EmailConfirmationTokenHash') IS NULL
BEGIN
    ALTER TABLE dbo.Users ADD EmailConfirmationTokenHash NVARCHAR(500) NULL;
END
GO

IF COL_LENGTH('dbo.Users', 'EmailConfirmationTokenExpiredAt') IS NULL
BEGIN
    ALTER TABLE dbo.Users ADD EmailConfirmationTokenExpiredAt DATETIME2 NULL;
END
GO

IF COL_LENGTH('dbo.Users', 'EmailConfirmedAt') IS NULL
BEGIN
    ALTER TABLE dbo.Users ADD EmailConfirmedAt DATETIME2 NULL;
END
GO

IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_Users_Status')
BEGIN
    ALTER TABLE dbo.Users DROP CONSTRAINT CK_Users_Status;
END
GO

ALTER TABLE dbo.Users ADD CONSTRAINT CK_Users_Status CHECK (Status IN ('Active', 'Locked', 'Pending'));
GO

UPDATE dbo.Users
SET IsEmailConfirmed = 1,
    EmailConfirmedAt = COALESCE(EmailConfirmedAt, SYSUTCDATETIME())
WHERE Status = 'Active' AND IsEmailConfirmed = 0;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Users_EmailConfirmationTokenHash' AND object_id = OBJECT_ID('dbo.Users'))
BEGIN
    CREATE INDEX IX_Users_EmailConfirmationTokenHash
    ON dbo.Users(EmailConfirmationTokenHash)
    WHERE EmailConfirmationTokenHash IS NOT NULL;
END
GO

IF OBJECT_ID('dbo.PasswordResetTokens', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.PasswordResetTokens (
        ResetTokenId INT IDENTITY(1,1) PRIMARY KEY,
        UserId INT NOT NULL,
        Token NVARCHAR(500) NOT NULL,
        ExpiredAt DATETIME2 NOT NULL,
        IsUsed BIT NOT NULL DEFAULT 0,
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_PasswordResetTokens_Users
            FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId)
    );
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_PasswordResetTokens_Token'
      AND object_id = OBJECT_ID('dbo.PasswordResetTokens')
)
BEGIN
    CREATE INDEX IX_PasswordResetTokens_Token
    ON dbo.PasswordResetTokens(Token);
END
GO
