IF DB_ID(N'CalendarShopDB') IS NULL
BEGIN
    CREATE DATABASE CalendarShopDB;
END
GO

USE CalendarShopDB;
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.Reviews', 'U') IS NOT NULL DROP TABLE dbo.Reviews;
IF OBJECT_ID('dbo.CouponUsages', 'U') IS NOT NULL DROP TABLE dbo.CouponUsages;
IF OBJECT_ID('dbo.OrderStatusHistories', 'U') IS NOT NULL DROP TABLE dbo.OrderStatusHistories;
IF OBJECT_ID('dbo.OrderItems', 'U') IS NOT NULL DROP TABLE dbo.OrderItems;
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.Coupons', 'U') IS NOT NULL DROP TABLE dbo.Coupons;
IF OBJECT_ID('dbo.Favorites', 'U') IS NOT NULL DROP TABLE dbo.Favorites;
IF OBJECT_ID('dbo.CartItems', 'U') IS NOT NULL DROP TABLE dbo.CartItems;
IF OBJECT_ID('dbo.ProductImages', 'U') IS NOT NULL DROP TABLE dbo.ProductImages;
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL DROP TABLE dbo.Products;
IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL DROP TABLE dbo.Categories;
IF OBJECT_ID('dbo.PasswordResetTokens', 'U') IS NOT NULL DROP TABLE dbo.PasswordResetTokens;
IF OBJECT_ID('dbo.RefreshTokens', 'U') IS NOT NULL DROP TABLE dbo.RefreshTokens;
IF OBJECT_ID('dbo.UserAddresses', 'U') IS NOT NULL DROP TABLE dbo.UserAddresses;
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;
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
SELECT CAST(CreatedAt AS DATE) AS RevenueDate, SUM(TotalAmount) AS TotalRevenue, COUNT(*) AS TotalOrders
FROM dbo.Orders
WHERE Status = 'Delivered'
GROUP BY CAST(CreatedAt AS DATE);
GO

CREATE OR ALTER VIEW dbo.v_RevenueByMonth
AS
SELECT YEAR(CreatedAt) AS RevenueYear, MONTH(CreatedAt) AS RevenueMonth, SUM(TotalAmount) AS TotalRevenue, COUNT(*) AS TotalOrders
FROM dbo.Orders
WHERE Status = 'Delivered'
GROUP BY YEAR(CreatedAt), MONTH(CreatedAt);
GO

CREATE OR ALTER VIEW dbo.v_BestSellingProducts
AS
SELECT p.ProductId, p.ProductName, p.CalendarType, SUM(oi.Quantity) AS TotalSold, SUM(oi.TotalPrice) AS TotalRevenue
FROM dbo.OrderItems oi
JOIN dbo.Orders o ON oi.OrderId = o.OrderId
JOIN dbo.Products p ON oi.ProductId = p.ProductId
WHERE o.Status = 'Delivered'
GROUP BY p.ProductId, p.ProductName, p.CalendarType;
GO

-- Password demo: SHA256('123456') = 8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92
INSERT INTO dbo.Users (FullName, Email, Phone, PasswordHash, Role, Status)
VALUES
(N'Admin Calendar Shop', N'admin@calendarshop.com', N'0900000000', N'8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', N'Admin', N'Active'),
(N'Nguyễn Văn A', N'customer@gmail.com', N'0911111111', N'8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', N'Customer', N'Active');
GO

INSERT INTO dbo.Categories (CategoryName, Description, Status)
VALUES
(N'Lịch treo tường', N'Lịch treo tường dùng cho gia đình và văn phòng', N'Active'),
(N'Lịch để bàn', N'Lịch để bàn nhỏ gọn', N'Active'),
(N'Lịch bloc', N'Lịch bloc truyền thống', N'Active'),
(N'Planner', N'Sổ planner và lịch kế hoạch', N'Active'),
(N'Lịch custom', N'Lịch thiết kế theo yêu cầu', N'Active');
GO

INSERT INTO dbo.Products (CategoryId, ProductName, Description, Price, StockQuantity, ImageUrl, CalendarType, Status)
VALUES
(1, N'Lịch treo tường 2026 phong cảnh Việt Nam', N'Lịch treo tường 12 tháng.', 120000, 50, NULL, N'Wall Calendar', N'Active'),
(2, N'Lịch để bàn mini 2026', N'Lịch để bàn nhỏ gọn.', 65000, 100, NULL, N'Desk Calendar', N'Active'),
(3, N'Lịch bloc đại 2026', N'Lịch bloc truyền thống khổ lớn.', 180000, 30, NULL, N'Bloc Calendar', N'Active'),
(4, N'Planner học tập 2026', N'Planner ghi chú kế hoạch học tập.', 95000, 80, NULL, N'Planner', N'Active'),
(5, N'Lịch custom ảnh gia đình', N'Lịch thiết kế theo ảnh cá nhân.', 250000, 20, NULL, N'Custom Calendar', N'Active');
GO

INSERT INTO dbo.Coupons (Code, Description, DiscountType, DiscountValue, MinOrderValue, StartDate, EndDate, UsageLimit, Status)
VALUES
(N'WELCOME10', N'Giảm 10% cho khách hàng mới', N'Percent', 10, 100000, '2026-01-01', '2026-12-31', 1000, N'Active'),
(N'GIAM50K', N'Giảm 50.000đ cho đơn từ 500.000đ', N'Amount', 50000, 500000, '2026-01-01', '2026-12-31', 500, N'Active');
GO
