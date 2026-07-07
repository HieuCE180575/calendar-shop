USE CalendarShopDB;
GO

-- Xóa dữ liệu cũ nếu muốn làm sạch trước khi seed
DELETE FROM dbo.Reviews;
DELETE FROM dbo.CouponUsages;
DELETE FROM dbo.OrderStatusHistories;
DELETE FROM dbo.OrderItems;
DELETE FROM dbo.Orders;
GO

-- Reset identity columns
DBCC CHECKIDENT ('dbo.Orders', RESEED, 0);
DBCC CHECKIDENT ('dbo.OrderItems', RESEED, 0);
GO

-- Seed Orders
-- 1. Đơn hàng thành công tháng 5/2026
INSERT INTO dbo.Orders (UserId, CustomerName, CustomerPhone, ShippingAddress, SubTotal, DiscountAmount, ShippingFee, TotalAmount, PaymentMethod, Status, CreatedAt)
VALUES (2, N'Lý Thị I', '0911111111', N'123 Đường A, Quận 1, TP. HCM', 240000, 0, 0, 240000, 'COD', 'Delivered', '2026-05-15T10:00:00Z');

-- 2. Đơn hàng thành công tháng 6/2026
INSERT INTO dbo.Orders (UserId, CustomerName, CustomerPhone, ShippingAddress, SubTotal, DiscountAmount, ShippingFee, TotalAmount, PaymentMethod, Status, CreatedAt)
VALUES (2, N'Bùi Văn J', '0911111111', N'456 Đường B, Quận 3, TP. HCM', 180000, 0, 0, 180000, 'Banking', 'Delivered', '2026-06-20T14:30:00Z');

-- 3. Các đơn hàng tháng 7/2026
-- Đơn hàng 3: Thành công 01/07
INSERT INTO dbo.Orders (UserId, CustomerName, CustomerPhone, ShippingAddress, SubTotal, DiscountAmount, ShippingFee, TotalAmount, PaymentMethod, Status, CreatedAt)
VALUES (2, N'Nguyễn Văn A', '0911111111', N'789 Đường C, Bình Thạnh, TP. HCM', 370000, 0, 0, 370000, 'COD', 'Delivered', '2026-07-01T08:15:00Z');

-- Đơn hàng 4: Thành công 02/07
INSERT INTO dbo.Orders (UserId, CustomerName, CustomerPhone, ShippingAddress, SubTotal, DiscountAmount, ShippingFee, TotalAmount, PaymentMethod, Status, CreatedAt)
VALUES (2, N'Trần Thị B', '0922222222', N'Tòa nhà X, Cầu Giấy, Hà Nội', 275000, 0, 0, 275000, 'COD', 'Delivered', '2026-07-02T16:45:00Z');

-- Đơn hàng 5: Thành công 03/07
INSERT INTO dbo.Orders (UserId, CustomerName, CustomerPhone, ShippingAddress, SubTotal, DiscountAmount, ShippingFee, TotalAmount, PaymentMethod, Status, CreatedAt)
VALUES (2, N'Lê Văn C', '0933333333', N'Đường Số 5, Hải Châu, Đà Nẵng', 500000, 0, 0, 500000, 'Banking', 'Delivered', '2026-07-03T11:20:00Z');

-- Đơn hàng 6: Thành công 04/07
INSERT INTO dbo.Orders (UserId, CustomerName, CustomerPhone, ShippingAddress, SubTotal, DiscountAmount, ShippingFee, TotalAmount, PaymentMethod, Status, CreatedAt)
VALUES (2, N'Phạm Thị D', '0944444444', N'Ninh Kiều, Cần Thơ', 250000, 0, 0, 250000, 'Momo', 'Delivered', '2026-07-04T09:00:00Z');

-- Đơn hàng 7: Chờ xử lý 05/07
INSERT INTO dbo.Orders (UserId, CustomerName, CustomerPhone, ShippingAddress, SubTotal, DiscountAmount, ShippingFee, TotalAmount, PaymentMethod, Status, CreatedAt)
VALUES (2, N'Hoàng Văn E', '0955555555', N'Lê Chân, Hải Phòng', 120000, 0, 0, 120000, 'COD', 'Pending', '2026-07-05T15:10:00Z');

-- Đơn hàng 8: Đã hủy 06/07
INSERT INTO dbo.Orders (UserId, CustomerName, CustomerPhone, ShippingAddress, SubTotal, DiscountAmount, ShippingFee, TotalAmount, PaymentMethod, Status, CreatedAt)
VALUES (2, N'Nguyễn Thị F', '0966666666', N'Hạ Long, Quảng Ninh', 180000, 0, 0, 180000, 'COD', 'Cancelled', '2026-07-06T10:00:00Z');

-- Đơn hàng 9: Đã xác nhận 06/07
INSERT INTO dbo.Orders (UserId, CustomerName, CustomerPhone, ShippingAddress, SubTotal, DiscountAmount, ShippingFee, TotalAmount, PaymentMethod, Status, CreatedAt)
VALUES (2, N'Vũ Văn G', '0977777777', N'Thành phố Vinh, Nghệ An', 130000, 0, 0, 130000, 'VNPay', 'Confirmed', '2026-07-06T18:25:00Z');

-- Đơn hàng 10: Đang giao 07/07
INSERT INTO dbo.Orders (UserId, CustomerName, CustomerPhone, ShippingAddress, SubTotal, DiscountAmount, ShippingFee, TotalAmount, PaymentMethod, Status, CreatedAt)
VALUES (2, N'Đặng Văn H', '0988888888', N'Thành phố Huế, Thừa Thiên Huế', 190000, 0, 0, 190000, 'COD', 'Shipping', '2026-07-07T13:40:00Z');
GO

-- Seed Order Items
-- Đơn hàng 1: Lý Thị I (2 Product 1)
INSERT INTO dbo.OrderItems (OrderId, ProductId, ProductName, ProductImageUrl, UnitPrice, Quantity, TotalPrice)
VALUES (1, 1, N'Lịch treo tường 2026 phong cảnh Việt Nam', NULL, 120000, 2, 240000);

-- Đơn hàng 2: Bùi Văn J (1 Product 3)
INSERT INTO dbo.OrderItems (OrderId, ProductId, ProductName, ProductImageUrl, UnitPrice, Quantity, TotalPrice)
VALUES (2, 3, N'Lịch bloc đại 2026', NULL, 180000, 1, 180000);

-- Đơn hàng 3: Nguyễn Văn A (2 Product 1 + 2 Product 2)
INSERT INTO dbo.OrderItems (OrderId, ProductId, ProductName, ProductImageUrl, UnitPrice, Quantity, TotalPrice)
VALUES 
(3, 1, N'Lịch treo tường 2026 phong cảnh Việt Nam', NULL, 120000, 2, 240000),
(3, 2, N'Lịch để bàn mini 2026', NULL, 65000, 2, 130000);

-- Đơn hàng 4: Trần Thị B (1 Product 3 + 1 Product 4)
INSERT INTO dbo.OrderItems (OrderId, ProductId, ProductName, ProductImageUrl, UnitPrice, Quantity, TotalPrice)
VALUES 
(4, 3, N'Lịch bloc đại 2026', NULL, 180000, 1, 180000),
(4, 4, N'Planner học tập 2026', NULL, 95000, 1, 95000);

-- Đơn hàng 5: Lê Văn C (2 Product 5)
INSERT INTO dbo.OrderItems (OrderId, ProductId, ProductName, ProductImageUrl, UnitPrice, Quantity, TotalPrice)
VALUES (5, 5, N'Lịch custom ảnh gia đình', NULL, 250000, 2, 500000);

-- Đơn hàng 6: Phạm Thị D (1 Product 5)
INSERT INTO dbo.OrderItems (OrderId, ProductId, ProductName, ProductImageUrl, UnitPrice, Quantity, TotalPrice)
VALUES (6, 5, N'Lịch custom ảnh gia đình', NULL, 250000, 1, 250000);

-- Đơn hàng 7: Hoàng Văn E (1 Product 1)
INSERT INTO dbo.OrderItems (OrderId, ProductId, ProductName, ProductImageUrl, UnitPrice, Quantity, TotalPrice)
VALUES (7, 1, N'Lịch treo tường 2026 phong cảnh Việt Nam', NULL, 120000, 1, 120000);

-- Đơn hàng 8: Nguyễn Thị F (1 Product 3)
INSERT INTO dbo.OrderItems (OrderId, ProductId, ProductName, ProductImageUrl, UnitPrice, Quantity, TotalPrice)
VALUES (8, 3, N'Lịch bloc đại 2026', NULL, 180000, 1, 180000);

-- Đơn hàng 9: Vũ Văn G (2 Product 2)
INSERT INTO dbo.OrderItems (OrderId, ProductId, ProductName, ProductImageUrl, UnitPrice, Quantity, TotalPrice)
VALUES (9, 2, N'Lịch để bàn mini 2026', NULL, 65000, 2, 130000);

-- Đơn hàng 10: Đặng Văn H (2 Product 4)
INSERT INTO dbo.OrderItems (OrderId, ProductId, ProductName, ProductImageUrl, UnitPrice, Quantity, TotalPrice)
VALUES (10, 4, N'Planner học tập 2026', NULL, 95000, 2, 190000);
GO
