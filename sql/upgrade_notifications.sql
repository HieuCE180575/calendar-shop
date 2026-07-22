-- Nâng cấp cơ sở dữ liệu để sửa lỗi thiếu bảng Discounts/Coupons và thêm chức năng thông báo
USE CalendarShopDB;
GO

-- 1. Tạo bảng Discounts nếu chưa tồn tại
IF OBJECT_ID(N'dbo.Discounts', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Discounts (
        DiscountId INT IDENTITY(1,1) PRIMARY KEY,
        Name NVARCHAR(200) NOT NULL,
        DiscountType NVARCHAR(20) NOT NULL DEFAULT 'Percent',
        DiscountValue DECIMAL(18,2) NOT NULL,
        StartDate DATETIME2 NOT NULL,
        EndDate DATETIME2 NOT NULL,
        Status NVARCHAR(20) NOT NULL DEFAULT 'Active',
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT CK_Discounts_DiscountType CHECK (DiscountType IN ('Percent', 'FixedAmount')),
        CONSTRAINT CK_Discounts_Status CHECK (Status IN ('Active', 'Inactive')),
        CONSTRAINT CK_Discounts_Date CHECK (StartDate <= EndDate)
    );
END
GO

-- 2. Thêm cột DiscountId vào bảng Products nếu chưa tồn tại
IF NOT EXISTS (
    SELECT * FROM sys.columns 
    WHERE object_id = OBJECT_ID(N'dbo.Products') AND name = N'DiscountId'
)
BEGIN
    ALTER TABLE dbo.Products ADD DiscountId INT NULL;
END
GO

-- 3. Tạo ràng buộc khóa ngoại FK_Products_Discounts nếu chưa tồn tại
IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys 
    WHERE name = N'FK_Products_Discounts' AND parent_object_id = OBJECT_ID(N'dbo.Products')
)
BEGIN
    ALTER TABLE dbo.Products 
    ADD CONSTRAINT FK_Products_Discounts FOREIGN KEY (DiscountId) 
    REFERENCES dbo.Discounts(DiscountId) ON DELETE SET NULL;
END
GO

-- 4. Tạo bảng Coupons nếu chưa tồn tại
IF OBJECT_ID(N'dbo.Coupons', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Coupons (
        CouponId INT IDENTITY(1,1) PRIMARY KEY,
        Code NVARCHAR(50) NOT NULL UNIQUE,
        Description NVARCHAR(500) NULL,
        DiscountType NVARCHAR(20) NOT NULL,
        DiscountValue DECIMAL(18,2) NOT NULL,
        MinOrderValue DECIMAL(18,2) NOT NULL DEFAULT 0,
        StartDate DATETIME2 NOT NULL,
        EndDate DATETIME2 NOT NULL,
        UsageLimit INT NULL,
        UsedCount INT NOT NULL DEFAULT 0,
        Status NVARCHAR(20) NOT NULL DEFAULT 'Active',
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        UpdatedAt DATETIME2 NULL,
        CONSTRAINT CK_Coupons_DiscountType CHECK (DiscountType IN ('Percent', 'Amount')),
        CONSTRAINT CK_Coupons_Status CHECK (Status IN ('Active', 'Inactive')),
        CONSTRAINT CK_Coupons_Date CHECK (StartDate < EndDate)
    );
END
GO

-- 5. Thêm cột CouponId vào bảng Orders nếu chưa tồn tại
IF NOT EXISTS (
    SELECT * FROM sys.columns 
    WHERE object_id = OBJECT_ID(N'dbo.Orders') AND name = N'CouponId'
)
BEGIN
    ALTER TABLE dbo.Orders ADD CouponId INT NULL;
END
GO

-- 6. Tạo ràng buộc khóa ngoại FK_Orders_Coupons nếu chưa tồn tại
IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys 
    WHERE name = N'FK_Orders_Coupons' AND parent_object_id = OBJECT_ID(N'dbo.Orders')
)
BEGIN
    ALTER TABLE dbo.Orders 
    ADD CONSTRAINT FK_Orders_Coupons FOREIGN KEY (CouponId) 
    REFERENCES dbo.Coupons(CouponId) ON DELETE SET NULL;
END
GO

-- 7. Tạo bảng CouponUsages nếu chưa tồn tại
IF OBJECT_ID(N'dbo.CouponUsages', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.CouponUsages (
        CouponUsageId INT IDENTITY(1,1) PRIMARY KEY,
        CouponId INT NOT NULL,
        UserId INT NOT NULL,
        OrderId INT NOT NULL,
        UsedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_CouponUsages_Coupons FOREIGN KEY (CouponId) REFERENCES dbo.Coupons(CouponId),
        CONSTRAINT FK_CouponUsages_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId),
        CONSTRAINT FK_CouponUsages_Orders FOREIGN KEY (OrderId) REFERENCES dbo.Orders(OrderId)
    );
END
GO

-- 8. Thêm cột FcmToken vào bảng Users nếu chưa tồn tại
IF NOT EXISTS (
    SELECT * FROM sys.columns 
    WHERE object_id = OBJECT_ID(N'dbo.Users') AND name = N'FcmToken'
)
BEGIN
    ALTER TABLE dbo.Users ADD FcmToken NVARCHAR(500) NULL;
END
GO

-- 9. Tạo bảng Notifications nếu chưa tồn tại
IF OBJECT_ID(N'dbo.Notifications', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Notifications (
        NotificationId INT IDENTITY(1,1) PRIMARY KEY,
        UserId INT NOT NULL,
        Title NVARCHAR(200) NOT NULL,
        Content NVARCHAR(1000) NOT NULL,
        Type NVARCHAR(50) NOT NULL, -- 'Holiday', 'OrderUpdate', 'Discount', 'System'
        IsRead BIT NOT NULL DEFAULT 0,
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_Notifications_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId) ON DELETE CASCADE
    );

    CREATE INDEX IX_Notifications_UserId ON dbo.Notifications(UserId);
    CREATE INDEX IX_Notifications_CreatedAt ON dbo.Notifications(CreatedAt);
END
GO
