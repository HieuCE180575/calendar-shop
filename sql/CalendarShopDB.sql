USE master;
GO

IF DB_ID(N'CalendarShopDB') IS NOT NULL
BEGIN
    ALTER DATABASE CalendarShopDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE CalendarShopDB;
END
GO

CREATE DATABASE CalendarShopDB;
GO

USE CalendarShopDB;
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

CREATE TABLE dbo.Users (
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255) NULL,
    Phone NVARCHAR(20) NULL,
    PasswordHash NVARCHAR(500) NOT NULL,
    AvatarUrl NVARCHAR(500) NULL,
    Gender NVARCHAR(20) NULL,
    DateOfBirth DATE NULL,
    Role NVARCHAR(20) NOT NULL DEFAULT 'Customer',
    Status NVARCHAR(20) NOT NULL DEFAULT 'Active',
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL,
    CONSTRAINT CK_Users_EmailOrPhone CHECK (Email IS NOT NULL OR Phone IS NOT NULL),
    CONSTRAINT CK_Users_Role CHECK (Role IN ('Customer', 'Admin')),
    CONSTRAINT CK_Users_Status CHECK (Status IN ('Active', 'Locked'))
);
GO

CREATE UNIQUE INDEX UX_Users_Email ON dbo.Users(Email) WHERE Email IS NOT NULL;
CREATE UNIQUE INDEX UX_Users_Phone ON dbo.Users(Phone) WHERE Phone IS NOT NULL;
GO

CREATE TABLE dbo.UserAddresses (
    AddressId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    ReceiverName NVARCHAR(100) NOT NULL,
    ReceiverPhone NVARCHAR(20) NOT NULL,
    Province NVARCHAR(100) NOT NULL,
    District NVARCHAR(100) NOT NULL,
    Ward NVARCHAR(100) NULL,
    AddressLine NVARCHAR(255) NOT NULL,
    IsDefault BIT NOT NULL DEFAULT 0,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL,
    CONSTRAINT FK_UserAddresses_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId)
);
GO

CREATE TABLE dbo.RefreshTokens (
    RefreshTokenId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    Token NVARCHAR(500) NOT NULL,
    ExpiredAt DATETIME2 NOT NULL,
    IsRevoked BIT NOT NULL DEFAULT 0,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_RefreshTokens_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId)
);
GO

CREATE TABLE dbo.PasswordResetTokens (
    ResetTokenId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    Token NVARCHAR(500) NOT NULL,
    ExpiredAt DATETIME2 NOT NULL,
    IsUsed BIT NOT NULL DEFAULT 0,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_PasswordResetTokens_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId)
);
GO

CREATE TABLE dbo.Categories (
    CategoryId INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(500) NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Active',
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL,
    CONSTRAINT CK_Categories_Status CHECK (Status IN ('Active', 'Hidden'))
);
GO

CREATE TABLE dbo.Products (
    ProductId INT IDENTITY(1,1) PRIMARY KEY,
    CategoryId INT NOT NULL,
    ProductName NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    Price DECIMAL(18,2) NOT NULL,
    StockQuantity INT NOT NULL DEFAULT 0,
    ImageUrl NVARCHAR(500) NULL,
    CalendarType NVARCHAR(50) NOT NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Active',
    IsDeleted BIT NOT NULL DEFAULT 0,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL,
    CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryId) REFERENCES dbo.Categories(CategoryId),
    CONSTRAINT CK_Products_Price CHECK (Price >= 0),
    CONSTRAINT CK_Products_Stock CHECK (StockQuantity >= 0),
    CONSTRAINT CK_Products_Status CHECK (Status IN ('Active', 'OutOfStock', 'Hidden'))
);
GO

CREATE TABLE dbo.ProductImages (
    ProductImageId INT IDENTITY(1,1) PRIMARY KEY,
    ProductId INT NOT NULL,
    ImageUrl NVARCHAR(500) NOT NULL,
    IsMain BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_ProductImages_Products FOREIGN KEY (ProductId) REFERENCES dbo.Products(ProductId)
);
GO

CREATE TABLE dbo.CartItems (
    CartItemId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    ProductId INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 1,
    IsSelected BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL,
    CONSTRAINT FK_CartItems_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId),
    CONSTRAINT FK_CartItems_Products FOREIGN KEY (ProductId) REFERENCES dbo.Products(ProductId),
    CONSTRAINT CK_CartItems_Quantity CHECK (Quantity > 0),
    CONSTRAINT UQ_CartItems_User_Product UNIQUE (UserId, ProductId)
);
GO

CREATE TABLE dbo.Favorites (
    FavoriteId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    ProductId INT NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Favorites_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId),
    CONSTRAINT FK_Favorites_Products FOREIGN KEY (ProductId) REFERENCES dbo.Products(ProductId),
    CONSTRAINT UQ_Favorites_User_Product UNIQUE (UserId, ProductId)
);
GO

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
GO

CREATE TABLE dbo.Orders (
    OrderId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    CouponId INT NULL,
    CustomerName NVARCHAR(100) NOT NULL,
    CustomerPhone NVARCHAR(20) NOT NULL,
    ShippingAddress NVARCHAR(500) NOT NULL,
    SubTotal DECIMAL(18,2) NOT NULL DEFAULT 0,
    DiscountAmount DECIMAL(18,2) NOT NULL DEFAULT 0,
    ShippingFee DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalAmount DECIMAL(18,2) NOT NULL DEFAULT 0,
    PaymentMethod NVARCHAR(50) NOT NULL DEFAULT 'COD',
    Status NVARCHAR(20) NOT NULL DEFAULT 'Pending',
    Note NVARCHAR(500) NULL,
    CancelReason NVARCHAR(500) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL,
    CONSTRAINT FK_Orders_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId),
    CONSTRAINT FK_Orders_Coupons FOREIGN KEY (CouponId) REFERENCES dbo.Coupons(CouponId),
    CONSTRAINT CK_Orders_Status CHECK (Status IN ('Pending', 'Confirmed', 'Shipping', 'Delivered', 'Cancelled')),
    CONSTRAINT CK_Orders_PaymentMethod CHECK (PaymentMethod IN ('COD', 'Banking', 'Momo', 'VNPay')),
    CONSTRAINT UQ_Orders_Order_User UNIQUE (OrderId, UserId)
);
GO

CREATE TABLE dbo.OrderItems (
    OrderItemId INT IDENTITY(1,1) PRIMARY KEY,
    OrderId INT NOT NULL,
    ProductId INT NOT NULL,
    ProductName NVARCHAR(200) NOT NULL,
    ProductImageUrl NVARCHAR(500) NULL,
    UnitPrice DECIMAL(18,2) NOT NULL,
    Quantity INT NOT NULL,
    TotalPrice DECIMAL(18,2) NOT NULL,
    CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (OrderId) REFERENCES dbo.Orders(OrderId),
    CONSTRAINT FK_OrderItems_Products FOREIGN KEY (ProductId) REFERENCES dbo.Products(ProductId),
    CONSTRAINT CK_OrderItems_Quantity CHECK (Quantity > 0),
    CONSTRAINT CK_OrderItems_Price CHECK (UnitPrice >= 0 AND TotalPrice >= 0),
    CONSTRAINT UQ_OrderItems_Item_Order_Product UNIQUE (OrderItemId, OrderId, ProductId)
);
GO

CREATE TABLE dbo.OrderStatusHistories (
    HistoryId INT IDENTITY(1,1) PRIMARY KEY,
    OrderId INT NOT NULL,
    OldStatus NVARCHAR(20) NULL,
    NewStatus NVARCHAR(20) NOT NULL,
    ChangedByUserId INT NULL,
    Note NVARCHAR(500) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_OrderStatusHistories_Orders FOREIGN KEY (OrderId) REFERENCES dbo.Orders(OrderId),
    CONSTRAINT FK_OrderStatusHistories_Users FOREIGN KEY (ChangedByUserId) REFERENCES dbo.Users(UserId)
);
GO

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
GO

CREATE TABLE dbo.Reviews (
    ReviewId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    ProductId INT NOT NULL,
    OrderId INT NOT NULL,
    OrderItemId INT NOT NULL,
    Rating INT NOT NULL,
    Comment NVARCHAR(1000) NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Visible',
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL,
    CONSTRAINT FK_Reviews_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId),
    CONSTRAINT FK_Reviews_Products FOREIGN KEY (ProductId) REFERENCES dbo.Products(ProductId),
    CONSTRAINT FK_Reviews_Order_User FOREIGN KEY (OrderId, UserId) REFERENCES dbo.Orders(OrderId, UserId),
    CONSTRAINT FK_Reviews_OrderItem FOREIGN KEY (OrderItemId, OrderId, ProductId) REFERENCES dbo.OrderItems(OrderItemId, OrderId, ProductId),
    CONSTRAINT CK_Reviews_Rating CHECK (Rating BETWEEN 1 AND 5),
    CONSTRAINT CK_Reviews_Status CHECK (Status IN ('Visible', 'Hidden')),
    CONSTRAINT UQ_Reviews_User_Product_OrderItem UNIQUE (UserId, ProductId, OrderItemId)
);
GO

CREATE INDEX IX_Products_CategoryId ON dbo.Products(CategoryId);
CREATE INDEX IX_Products_Name ON dbo.Products(ProductName);
CREATE INDEX IX_Products_Price ON dbo.Products(Price);
CREATE INDEX IX_Orders_UserId ON dbo.Orders(UserId);
CREATE INDEX IX_Orders_Status ON dbo.Orders(Status);
CREATE INDEX IX_Orders_CreatedAt ON dbo.Orders(CreatedAt);
GO

CREATE OR ALTER VIEW dbo.v_RevenueByDay
AS
SELECT
    CAST(CreatedAt AS DATE) AS RevenueDate,
    SUM(TotalAmount) AS TotalRevenue,
    COUNT(*) AS TotalOrders
FROM dbo.Orders
WHERE Status = 'Delivered'
GROUP BY CAST(CreatedAt AS DATE);
GO

CREATE OR ALTER VIEW dbo.v_RevenueByMonth
AS
SELECT
    YEAR(CreatedAt) AS RevenueYear,
    MONTH(CreatedAt) AS RevenueMonth,
    SUM(TotalAmount) AS TotalRevenue,
    COUNT(*) AS TotalOrders
FROM dbo.Orders
WHERE Status = 'Delivered'
GROUP BY YEAR(CreatedAt), MONTH(CreatedAt);
GO

CREATE OR ALTER VIEW dbo.v_BestSellingProducts
AS
SELECT
    p.ProductId,
    p.ProductName,
    p.CalendarType,
    SUM(oi.Quantity) AS TotalSold,
    SUM(oi.TotalPrice) AS TotalRevenue
FROM dbo.OrderItems oi
JOIN dbo.Orders o ON oi.OrderId = o.OrderId
JOIN dbo.Products p ON oi.ProductId = p.ProductId
WHERE o.Status = 'Delivered'
GROUP BY p.ProductId, p.ProductName, p.CalendarType;
GO

-- Password demo: SHA256('123456')
SET IDENTITY_INSERT dbo.Users ON;
INSERT INTO dbo.Users (
    UserId,
    FullName,
    Email,
    Phone,
    PasswordHash,
    Role,
    Status
)
VALUES
    (1, N'Admin Calendar Shop', N'admin@calendarshop.com', N'0900000000', N'8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', N'Admin', N'Active'),
    (2, N'Nguyen Van A', N'customer@gmail.com', N'0911111111', N'8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', N'Customer', N'Active');
SET IDENTITY_INSERT dbo.Users OFF;
GO

SET IDENTITY_INSERT dbo.Categories ON;
INSERT INTO dbo.Categories (
    CategoryId,
    CategoryName,
    Description,
    Status
)
VALUES
    (1, N'Lich treo tuong', N'Lich treo tuong dung cho gia dinh va van phong', N'Active'),
    (2, N'Lich de ban', N'Lich de ban nho gon', N'Active'),
    (3, N'Lich bloc', N'Lich bloc truyen thong', N'Active'),
    (4, N'Planner', N'So planner va lich ke hoach', N'Active'),
    (5, N'Lich custom', N'Lich thiet ke theo yeu cau', N'Active');
SET IDENTITY_INSERT dbo.Categories OFF;
GO

SET IDENTITY_INSERT dbo.Products ON;
INSERT INTO dbo.Products (
    ProductId,
    CategoryId,
    ProductName,
    Description,
    Price,
    StockQuantity,
    ImageUrl,
    CalendarType,
    Status
)
VALUES
    (1, 1, N'Lich treo tuong 2026 phong canh Viet Nam', N'Lich treo tuong 12 thang.', 120000, 50, NULL, N'Wall Calendar', N'Active'),
    (2, 2, N'Lich de ban mini 2026', N'Lich de ban nho gon.', 65000, 100, NULL, N'Desk Calendar', N'Active'),
    (3, 3, N'Lich bloc dai 2026', N'Lich bloc truyen thong kho lon.', 180000, 30, NULL, N'Bloc Calendar', N'Active'),
    (4, 4, N'Planner hoc tap 2026', N'Planner ghi chu ke hoach hoc tap.', 95000, 80, NULL, N'Planner', N'Active'),
    (5, 5, N'Lich custom anh gia dinh', N'Lich thiet ke theo anh ca nhan.', 250000, 20, NULL, N'Custom Calendar', N'Active');
SET IDENTITY_INSERT dbo.Products OFF;
GO

SET IDENTITY_INSERT dbo.Coupons ON;
INSERT INTO dbo.Coupons (
    CouponId,
    Code,
    Description,
    DiscountType,
    DiscountValue,
    MinOrderValue,
    StartDate,
    EndDate,
    UsageLimit,
    UsedCount,
    Status
)
VALUES
    (1, N'WELCOME10', N'Giam 10 phan tram cho khach hang moi', N'Percent', 10, 100000, '2026-01-01', '2026-12-31', 1000, 0, N'Active'),
    (2, N'GIAM50K', N'Giam 50,000 VND cho don tu 500,000 VND', N'Amount', 50000, 500000, '2026-01-01', '2026-12-31', 500, 0, N'Active');
SET IDENTITY_INSERT dbo.Coupons OFF;
GO

SET IDENTITY_INSERT dbo.Orders ON;
INSERT INTO dbo.Orders (
    OrderId,
    UserId,
    CouponId,
    CustomerName,
    CustomerPhone,
    ShippingAddress,
    SubTotal,
    DiscountAmount,
    ShippingFee,
    TotalAmount,
    PaymentMethod,
    Status,
    Note,
    CancelReason,
    CreatedAt,
    UpdatedAt
)
VALUES
    (1, 2, NULL, N'Ly Thi I', '0911111111', N'123 Duong A, Quan 1, TP HCM', 240000, 0, 0, 240000, 'COD', 'Delivered', NULL, NULL, '2026-05-15T10:00:00Z', NULL),
    (2, 2, NULL, N'Bui Van J', '0911111112', N'456 Duong B, Quan 3, TP HCM', 180000, 0, 0, 180000, 'Banking', 'Delivered', NULL, NULL, '2026-06-20T14:30:00Z', NULL),
    (3, 2, NULL, N'Nguyen Van A', '0911111113', N'789 Duong C, Binh Thanh, TP HCM', 370000, 0, 0, 370000, 'COD', 'Delivered', NULL, NULL, '2026-07-01T08:15:00Z', NULL),
    (4, 2, NULL, N'Tran Thi B', '0922222222', N'Toa nha X, Cau Giay, Ha Noi', 275000, 0, 0, 275000, 'COD', 'Delivered', NULL, NULL, '2026-07-02T16:45:00Z', NULL),
    (5, 2, NULL, N'Le Van C', '0933333333', N'Duong So 5, Hai Chau, Da Nang', 500000, 0, 0, 500000, 'Banking', 'Delivered', NULL, NULL, '2026-07-03T11:20:00Z', NULL),
    (6, 2, NULL, N'Pham Thi D', '0944444444', N'Ninh Kieu, Can Tho', 250000, 0, 0, 250000, 'Momo', 'Delivered', NULL, NULL, '2026-07-04T09:00:00Z', NULL),
    (7, 2, NULL, N'Hoang Van E', '0955555555', N'Le Chan, Hai Phong', 120000, 0, 0, 120000, 'COD', 'Pending', NULL, NULL, '2026-07-05T15:10:00Z', NULL),
    (8, 2, NULL, N'Nguyen Thi F', '0966666666', N'Ha Long, Quang Ninh', 180000, 0, 0, 180000, 'COD', 'Cancelled', NULL, N'Khong can nua', '2026-07-06T10:00:00Z', NULL),
    (9, 2, NULL, N'Vu Van G', '0977777777', N'Thanh pho Vinh, Nghe An', 130000, 0, 0, 130000, 'VNPay', 'Confirmed', NULL, NULL, '2026-07-06T18:25:00Z', NULL),
    (10, 2, NULL, N'Dang Van H', '0988888888', N'Thanh pho Hue, Thua Thien Hue', 190000, 0, 0, 190000, 'COD', 'Shipping', NULL, NULL, '2026-07-07T13:40:00Z', NULL);
SET IDENTITY_INSERT dbo.Orders OFF;
GO

SET IDENTITY_INSERT dbo.OrderItems ON;
INSERT INTO dbo.OrderItems (
    OrderItemId,
    OrderId,
    ProductId,
    ProductName,
    ProductImageUrl,
    UnitPrice,
    Quantity,
    TotalPrice
)
VALUES
    (1, 1, 1, N'Lich treo tuong 2026 phong canh Viet Nam', NULL, 120000, 2, 240000),
    (2, 2, 3, N'Lich bloc dai 2026', NULL, 180000, 1, 180000),
    (3, 3, 1, N'Lich treo tuong 2026 phong canh Viet Nam', NULL, 120000, 2, 240000),
    (4, 3, 2, N'Lich de ban mini 2026', NULL, 65000, 2, 130000),
    (5, 4, 3, N'Lich bloc dai 2026', NULL, 180000, 1, 180000),
    (6, 4, 4, N'Planner hoc tap 2026', NULL, 95000, 1, 95000),
    (7, 5, 5, N'Lich custom anh gia dinh', NULL, 250000, 2, 500000),
    (8, 6, 5, N'Lich custom anh gia dinh', NULL, 250000, 1, 250000),
    (9, 7, 1, N'Lich treo tuong 2026 phong canh Viet Nam', NULL, 120000, 1, 120000),
    (10, 8, 3, N'Lich bloc dai 2026', NULL, 180000, 1, 180000),
    (11, 9, 2, N'Lich de ban mini 2026', NULL, 65000, 2, 130000),
    (12, 10, 4, N'Planner hoc tap 2026', NULL, 95000, 2, 190000);
SET IDENTITY_INSERT dbo.OrderItems OFF;
GO

INSERT INTO dbo.OrderStatusHistories (OrderId, OldStatus, NewStatus, ChangedByUserId, Note, CreatedAt)
VALUES
    (1, NULL, 'Delivered', 1, N'Seeded order history', '2026-05-15T10:05:00Z'),
    (2, NULL, 'Delivered', 1, N'Seeded order history', '2026-06-20T14:35:00Z'),
    (3, NULL, 'Delivered', 1, N'Seeded order history', '2026-07-01T08:20:00Z'),
    (4, NULL, 'Delivered', 1, N'Seeded order history', '2026-07-02T16:50:00Z'),
    (5, NULL, 'Delivered', 1, N'Seeded order history', '2026-07-03T11:25:00Z'),
    (6, NULL, 'Delivered', 1, N'Seeded order history', '2026-07-04T09:05:00Z'),
    (7, NULL, 'Pending', 1, N'Seeded order history', '2026-07-05T15:15:00Z'),
    (8, NULL, 'Cancelled', 1, N'Seeded order history', '2026-07-06T10:05:00Z'),
    (9, NULL, 'Confirmed', 1, N'Seeded order history', '2026-07-06T18:30:00Z'),
    (10, NULL, 'Shipping', 1, N'Seeded order history', '2026-07-07T13:45:00Z');
GO
