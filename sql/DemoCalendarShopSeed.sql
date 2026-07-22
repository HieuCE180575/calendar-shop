-- DemoCalendarShopSeed.sql
-- Run this file only after the schema exists and the target demo tables are empty.
-- CalendarShopDB.sql already contains the same demo seed for a fresh database rebuild.
USE CalendarShopDB;
GO

SET IDENTITY_INSERT dbo.Categories ON;
INSERT INTO dbo.Categories
    (CategoryId, CategoryName, Description, Status)
VALUES
    (1, N'Lịch treo tường', N'Lịch treo tường dùng cho gia đình, văn phòng và trang trí không gian sống', N'Active'),
    (2, N'Lịch để bàn', N'Lịch để bàn nhỏ gọn cho bàn học, bàn làm việc và quầy lễ tân', N'Active'),
    (3, N'Lịch bloc', N'Lịch bloc truyền thống với nhiều kích thước dùng hằng ngày', N'Active'),
    (4, N'Planner', N'Sổ planner và lịch kế hoạch cho học tập, công việc, tài chính cá nhân', N'Active'),
    (5, N'Lịch custom', N'Lịch thiết kế theo ảnh cá nhân, gia đình hoặc nhận diện thương hiệu', N'Active');
SET IDENTITY_INSERT dbo.Categories OFF;
GO

SET IDENTITY_INSERT dbo.Discounts ON;
INSERT INTO dbo.Discounts
    (DiscountId, Name, DiscountType, DiscountValue, StartDate, EndDate, Status, CreatedAt)
VALUES
    (1, N'Giảm 20% lịch để bàn mùa tựu trường', 'Percent', 20, '2026-01-01', '2026-12-31', 'Active', '2026-01-01T00:00:00Z'),
    (2, N'Giảm thẳng 50k cho lịch bloc', 'FixedAmount', 50000, '2026-01-01', '2026-12-31', 'Active', '2026-01-02T00:00:00Z'),
    (3, N'Ưu đãi 15% lịch treo tường 2026', 'Percent', 15, '2026-01-01', '2026-12-31', 'Active', '2026-01-03T00:00:00Z'),
    (4, N'Khuyến mãi planner đã kết thúc', 'FixedAmount', 30000, '2026-01-01', '2026-03-31', 'Inactive', '2026-01-04T00:00:00Z'),
    (5, N'Giảm 10% lịch custom gia đình', 'Percent', 10, '2026-01-01', '2026-12-31', 'Active', '2026-01-05T00:00:00Z'),
    (6, N'Ưu đãi doanh nghiệp 25%', 'Percent', 25, '2026-01-01', '2026-12-31', 'Active', '2026-01-06T00:00:00Z');
SET IDENTITY_INSERT dbo.Discounts OFF;
GO

SET IDENTITY_INSERT dbo.Products ON;
INSERT INTO dbo.Products
    (ProductId, CategoryId, DiscountId, ProductName, Description, Price, StockQuantity, ImageUrl, CalendarType, Status)
VALUES
    (1, 1, 3, N'Lịch treo tường 2026 phong cảnh Việt Nam', N'Lịch 12 tháng in phong cảnh Việt Nam, giấy couche dày, phù hợp phòng khách và văn phòng.', 120000, 50, N'http://localhost:51441/images/demo-products/calendar-01.png', N'Wall Calendar', N'Active'),
    (2, 2, 1, N'Lịch để bàn mini 2026', N'Lịch để bàn nhỏ gọn, thiết kế tối giản, phù hợp bàn học và góc làm việc cá nhân.', 65000, 100, N'http://localhost:51441/images/demo-products/calendar-02.png', N'Desk Calendar', N'Active'),
    (3, 3, 2, N'Lịch bloc đại 2026', N'Lịch bloc đại khổ lớn, xé từng ngày, kèm thông tin âm lịch và ngày lễ.', 180000, 30, N'http://localhost:51441/images/demo-products/calendar-03.png', N'Bloc Calendar', N'Active'),
    (4, 4, NULL, N'Planner học tập 2026', N'Planner ghi chú học tập theo tuần, có trang mục tiêu tháng và theo dõi deadline.', 95000, 80, N'http://localhost:51441/images/demo-products/calendar-04.png', N'Planner', N'Active'),
    (5, 5, 5, N'Lịch custom ảnh gia đình', N'Lịch custom 13 tờ dùng ảnh gia đình, có thể thêm lời chúc và ngày kỷ niệm riêng.', 250000, 20, N'http://localhost:51441/images/demo-products/calendar-05.png', N'Custom Calendar', N'Active'),
    (6, 1, NULL, N'Lịch treo tường 2026 hoa sen Việt', N'Lịch treo tường chủ đề hoa sen, màu sắc trang nhã, phù hợp biếu tặng gia đình.', 135000, 45, N'http://localhost:51441/images/demo-products/calendar-06.png', N'Wall Calendar', N'Active'),
    (7, 1, 6, N'Lịch treo tường doanh nghiệp 2026 cao cấp', N'Lịch treo tường giấy mỹ thuật, bố cục sang trọng, phù hợp in logo doanh nghiệp.', 220000, 25, N'http://localhost:51441/images/demo-products/calendar-07.png', N'Wall Calendar', N'Active'),
    (8, 2, NULL, N'Lịch để bàn gỗ tối giản 2026', N'Lịch để bàn kèm đế gỗ, phong cách tối giản, dễ đặt trên bàn làm việc.', 145000, 35, N'http://localhost:51441/images/demo-products/calendar-08.png', N'Desk Calendar', N'Active'),
    (9, 2, 1, N'Lịch để bàn quote truyền cảm hứng 2026', N'Lịch để bàn mỗi tuần một câu quote, phù hợp học sinh, sinh viên và nhân viên văn phòng.', 79000, 90, N'http://localhost:51441/images/demo-products/calendar-09.png', N'Desk Calendar', N'Active'),
    (10, 3, 2, N'Lịch bloc siêu đại Phúc Lộc Thọ 2026', N'Lịch bloc siêu đại chủ đề Phúc Lộc Thọ, bìa đỏ vàng, thích hợp treo phòng khách.', 260000, 18, N'http://localhost:51441/images/demo-products/calendar-10.png', N'Bloc Calendar', N'Active'),
    (11, 3, NULL, N'Lịch bloc văn phòng 2026', N'Lịch bloc cỡ trung cho văn phòng, rõ ngày dương lịch, âm lịch và ghi chú nhanh.', 150000, 40, N'http://localhost:51441/images/demo-products/calendar-11.png', N'Bloc Calendar', N'Active'),
    (12, 4, NULL, N'Planner công việc 2026 bìa da', N'Planner bìa da mềm, chia mục tiêu quý, kế hoạch tuần và checklist công việc.', 175000, 60, N'http://localhost:51441/images/demo-products/calendar-12.png', N'Planner', N'Active'),
    (13, 4, 4, N'Planner tài chính cá nhân 2026', N'Planner theo dõi thu chi, ngân sách tháng và mục tiêu tiết kiệm cá nhân.', 125000, 55, N'http://localhost:51441/images/demo-products/calendar-13.png', N'Planner', N'Active'),
    (14, 5, NULL, N'Lịch custom logo công ty 2026', N'Lịch thiết kế theo bộ nhận diện thương hiệu, phù hợp quà tặng khách hàng doanh nghiệp.', 320000, 15, N'http://localhost:51441/images/demo-products/calendar-14.png', N'Custom Calendar', N'Active'),
    (15, 5, 5, N'Lịch custom ảnh cưới 2026', N'Lịch custom ảnh cưới, tông màu nhẹ, có thể thêm ngày kỷ niệm và lời nhắn riêng.', 280000, 12, N'http://localhost:51441/images/demo-products/calendar-15.png', N'Custom Calendar', N'Active'),
    (16, 1, NULL, N'Lịch treo tường 2026 ẩm thực Việt', N'Lịch treo tường chủ đề món ăn Việt Nam, phù hợp bếp gia đình và quán ăn.', 128000, 0, N'http://localhost:51441/images/demo-products/calendar-16.png', N'Wall Calendar', N'OutOfStock'),
    (17, 2, NULL, N'Lịch để bàn tranh Đông Hồ 2026', N'Lịch để bàn minh họa tranh Đông Hồ, màu sắc truyền thống, phù hợp làm quà tặng.', 99000, 0, N'http://localhost:51441/images/demo-products/calendar-17.png', N'Desk Calendar', N'OutOfStock'),
    (18, 3, NULL, N'Lịch bloc trung 2026 thư pháp', N'Lịch bloc cỡ trung chủ đề thư pháp Việt, dễ treo trong phòng làm việc.', 99000, 70, N'http://localhost:51441/images/demo-products/calendar-18.png', N'Bloc Calendar', N'Active'),
    (19, 1, 3, N'Lịch treo tường thiên nhiên bốn mùa 2026', N'Lịch treo tường chủ đề thiên nhiên bốn mùa, hình ảnh sáng, phù hợp phòng khách.', 155000, 34, N'http://localhost:51441/images/demo-products/calendar-19.png', N'Wall Calendar', N'Active'),
    (20, 4, NULL, N'Planner giáo viên 2026', N'Planner dành cho giáo viên, có lịch giảng dạy, kế hoạch bài học và ghi chú lớp.', 115000, 50, N'http://localhost:51441/images/demo-products/calendar-20.png', N'Planner', N'Active');
SET IDENTITY_INSERT dbo.Products OFF;
GO

INSERT INTO dbo.ProductImages
    (ProductId, ImageUrl, IsMain)
VALUES
    (1, N'http://localhost:51441/images/demo-products/calendar-01.png', 1),
    (2, N'http://localhost:51441/images/demo-products/calendar-02.png', 1),
    (3, N'http://localhost:51441/images/demo-products/calendar-03.png', 1),
    (4, N'http://localhost:51441/images/demo-products/calendar-04.png', 1),
    (5, N'http://localhost:51441/images/demo-products/calendar-05.png', 1),
    (6, N'http://localhost:51441/images/demo-products/calendar-06.png', 1),
    (7, N'http://localhost:51441/images/demo-products/calendar-07.png', 1),
    (8, N'http://localhost:51441/images/demo-products/calendar-08.png', 1),
    (9, N'http://localhost:51441/images/demo-products/calendar-09.png', 1),
    (10, N'http://localhost:51441/images/demo-products/calendar-10.png', 1),
    (11, N'http://localhost:51441/images/demo-products/calendar-11.png', 1),
    (12, N'http://localhost:51441/images/demo-products/calendar-12.png', 1),
    (13, N'http://localhost:51441/images/demo-products/calendar-13.png', 1),
    (14, N'http://localhost:51441/images/demo-products/calendar-14.png', 1),
    (15, N'http://localhost:51441/images/demo-products/calendar-15.png', 1),
    (16, N'http://localhost:51441/images/demo-products/calendar-16.png', 1),
    (17, N'http://localhost:51441/images/demo-products/calendar-17.png', 1),
    (18, N'http://localhost:51441/images/demo-products/calendar-18.png', 1),
    (19, N'http://localhost:51441/images/demo-products/calendar-19.png', 1),
    (20, N'http://localhost:51441/images/demo-products/calendar-20.png', 1);
GO

SET IDENTITY_INSERT dbo.Coupons ON;
INSERT INTO dbo.Coupons
    (CouponId, Code, Description, DiscountType, DiscountValue, MinOrderValue, StartDate, EndDate, UsageLimit, UsedCount, Status)
VALUES
    (1, N'WELCOME10', N'Giảm 10 phần trăm cho khách hàng mới, áp dụng đơn từ 100,000 VND', N'Percent', 10, 100000, '2026-01-01', '2026-12-31', 1000, 14, N'Active'),
    (2, N'GIAM50K', N'Giảm 50,000 VND cho đơn từ 500,000 VND', N'Amount', 50000, 500000, '2026-01-01', '2026-12-31', 500, 9, N'Active'),
    (3, N'SUMMER15', N'Giảm 15 phần trăm cho đơn mua mùa hè', N'Percent', 15, 300000, '2026-06-01', '2026-08-31', 300, 25, N'Inactive'),
    (4, N'VIP100K', N'Giảm 100,000 VND cho đơn từ 1,000,000 VND', N'Amount', 100000, 1000000, '2026-01-01', '2026-12-31', NULL, 3, N'Active'),
    (5, N'FREESHIP30', N'Giảm 30,000 VND cho đơn từ 300,000 VND, dùng để demo coupon còn lượt', N'Amount', 30000, 300000, '2026-01-01', '2026-12-31', 200, 18, N'Active');
SET IDENTITY_INSERT dbo.Coupons OFF;
GO

SET IDENTITY_INSERT dbo.Favorites ON;
INSERT INTO dbo.Favorites
    (FavoriteId, UserId, ProductId, CreatedAt)
VALUES
    (1, 2, 2, '2026-07-01T09:00:00Z'),
    (2, 2, 7, '2026-07-02T09:00:00Z'),
    (3, 2, 15, '2026-07-03T09:00:00Z'),
    (4, 2, 19, '2026-07-04T09:00:00Z');
SET IDENTITY_INSERT dbo.Favorites OFF;
GO

SET IDENTITY_INSERT dbo.CartItems ON;
INSERT INTO dbo.CartItems
    (CartItemId, UserId, ProductId, Quantity, IsSelected, CreatedAt)
VALUES
    (1, 2, 8, 1, 1, '2026-07-08T08:00:00Z'),
    (2, 2, 18, 2, 1, '2026-07-08T08:05:00Z'),
    (3, 2, 19, 1, 0, '2026-07-08T08:10:00Z');
SET IDENTITY_INSERT dbo.CartItems OFF;
GO

SET IDENTITY_INSERT dbo.Orders ON;
INSERT INTO dbo.Orders
    (OrderId, UserId, CouponId, CustomerName, CustomerPhone, ShippingAddress, SubTotal, DiscountAmount, ShippingFee, TotalAmount, PaymentMethod, Status, Note, CancelReason, CreatedAt, UpdatedAt)
VALUES
    (1, 2, NULL, N'Lý Thị I', '0911111111', N'123 Đường A, Quận 1, TP HCM', 204000, 0, 0, 204000, 'COD', 'Delivered', N'Giao giờ hành chính', NULL, '2026-05-15T10:00:00Z', NULL),
    (2, 2, NULL, N'Bùi Văn J', '0911111112', N'456 Đường B, Quận 3, TP HCM', 130000, 0, 30000, 160000, 'Banking', 'Delivered', NULL, NULL, '2026-06-20T14:30:00Z', NULL),
    (3, 2, 1, N'Nguyễn Văn A', '0911111113', N'789 Đường C, Bình Thạnh, TP HCM', 167200, 16720, 30000, 180480, 'COD', 'Delivered', N'Áp dụng WELCOME10', NULL, '2026-07-01T08:15:00Z', NULL),
    (4, 2, 2, N'Trần Thị B', '0922222222', N'Tòa nhà X, Cầu Giấy, Hà Nội', 477000, 50000, 0, 427000, 'COD', 'Delivered', N'Quà tặng gia đình', NULL, '2026-07-02T16:45:00Z', NULL),
    (5, 2, NULL, N'Lê Văn C', '0933333333', N'Đường Số 5, Hải Châu, Đà Nẵng', 485000, 0, 0, 485000, 'Banking', 'Delivered', NULL, NULL, '2026-07-03T11:20:00Z', NULL),
    (6, 2, 1, N'Phạm Thị D', '0944444444', N'Ninh Kiều, Cần Thơ', 365000, 36500, 0, 328500, 'Momo', 'Delivered', N'Mua planner cho lớp học', NULL, '2026-07-04T09:00:00Z', NULL),
    (7, 2, NULL, N'Hoàng Văn E', '0955555555', N'Lê Chân, Hải Phòng', 131750, 0, 30000, 161750, 'COD', 'Pending', NULL, NULL, '2026-07-05T15:10:00Z', NULL),
    (8, 2, NULL, N'Nguyễn Thị F', '0966666666', N'Hạ Long, Quảng Ninh', 130000, 0, 30000, 160000, 'COD', 'Cancelled', NULL, N'Khách đổi sang mẫu khác', '2026-07-06T10:00:00Z', NULL),
    (9, 2, NULL, N'Vũ Văn G', '0977777777', N'Thành phố Vinh, Nghệ An', 104000, 0, 30000, 134000, 'VNPay', 'Confirmed', N'Đã thanh toán VNPay', NULL, '2026-07-06T18:25:00Z', NULL),
    (10, 2, NULL, N'Đặng Văn H', '0988888888', N'Thành phố Huế, Thừa Thiên Huế', 408000, 0, 0, 408000, 'COD', 'Shipping', NULL, NULL, '2026-07-07T13:40:00Z', NULL);
SET IDENTITY_INSERT dbo.Orders OFF;
GO

SET IDENTITY_INSERT dbo.OrderItems ON;
INSERT INTO dbo.OrderItems
    (OrderItemId, OrderId, ProductId, ProductName, ProductImageUrl, UnitPrice, Quantity, TotalPrice)
VALUES
    (1, 1, 1, N'Lịch treo tường 2026 phong cảnh Việt Nam', N'http://localhost:51441/images/demo-products/calendar-01.png', 102000, 2, 204000),
    (2, 2, 3, N'Lịch bloc đại 2026', N'http://localhost:51441/images/demo-products/calendar-03.png', 130000, 1, 130000),
    (3, 3, 2, N'Lịch để bàn mini 2026', N'http://localhost:51441/images/demo-products/calendar-02.png', 52000, 2, 104000),
    (4, 3, 9, N'Lịch để bàn quote truyền cảm hứng 2026', N'http://localhost:51441/images/demo-products/calendar-09.png', 63200, 1, 63200),
    (5, 4, 5, N'Lịch custom ảnh gia đình', N'http://localhost:51441/images/demo-products/calendar-05.png', 225000, 1, 225000),
    (6, 4, 15, N'Lịch custom ảnh cưới 2026', N'http://localhost:51441/images/demo-products/calendar-15.png', 252000, 1, 252000),
    (7, 5, 7, N'Lịch treo tường doanh nghiệp 2026 cao cấp', N'http://localhost:51441/images/demo-products/calendar-07.png', 165000, 1, 165000),
    (8, 5, 14, N'Lịch custom logo công ty 2026', N'http://localhost:51441/images/demo-products/calendar-14.png', 320000, 1, 320000),
    (9, 6, 4, N'Planner học tập 2026', N'http://localhost:51441/images/demo-products/calendar-04.png', 95000, 2, 190000),
    (10, 6, 12, N'Planner công việc 2026 bìa da', N'http://localhost:51441/images/demo-products/calendar-12.png', 175000, 1, 175000),
    (11, 7, 19, N'Lịch treo tường thiên nhiên bốn mùa 2026', N'http://localhost:51441/images/demo-products/calendar-19.png', 131750, 1, 131750),
    (12, 8, 3, N'Lịch bloc đại 2026', N'http://localhost:51441/images/demo-products/calendar-03.png', 130000, 1, 130000),
    (13, 9, 2, N'Lịch để bàn mini 2026', N'http://localhost:51441/images/demo-products/calendar-02.png', 52000, 2, 104000),
    (14, 10, 10, N'Lịch bloc siêu đại Phúc Lộc Thọ 2026', N'http://localhost:51441/images/demo-products/calendar-10.png', 210000, 1, 210000),
    (15, 10, 18, N'Lịch bloc trung 2026 thư pháp', N'http://localhost:51441/images/demo-products/calendar-18.png', 99000, 2, 198000);
SET IDENTITY_INSERT dbo.OrderItems OFF;
GO

INSERT INTO dbo.OrderStatusHistories
    (OrderId, OldStatus, NewStatus, ChangedByUserId, Note, CreatedAt)
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

SET IDENTITY_INSERT dbo.Notifications ON;
INSERT INTO dbo.Notifications
    (NotificationId, UserId, Title, Content, Type, IsRead, CreatedAt)
VALUES
    (1, 2, N'Đơn hàng đã được xác nhận', N'Đơn hàng #9 của bạn đã được xác nhận sau khi thanh toán VNPay.', N'Order', 0, '2026-07-06T18:35:00Z'),
    (2, 2, N'Đơn hàng đang giao', N'Đơn hàng #10 đang được giao đến địa chỉ của bạn.', N'Order', 0, '2026-07-07T13:50:00Z'),
    (3, 2, N'Ưu đãi lịch để bàn', N'Lịch để bàn mini 2026 đang giảm 20 phần trăm trong tháng này.', N'Promotion', 1, '2026-07-08T09:00:00Z');
SET IDENTITY_INSERT dbo.Notifications OFF;
GO

SET IDENTITY_INSERT dbo.Reviews ON;
INSERT INTO dbo.Reviews
    (ReviewId, UserId, ProductId, OrderId, OrderItemId, Rating, Comment, Status, CreatedAt)
VALUES
    (1, 2, 1, 1, 1, 5, N'Ảnh in rõ, màu phong cảnh rất đẹp, treo phòng khách nhìn sang.', N'Visible', '2026-05-20T09:00:00Z'),
    (2, 2, 3, 2, 2, 4, N'Lịch bloc chắc chắn, giấy dày, giao hàng đúng hẹn.', N'Visible', '2026-06-25T10:00:00Z'),
    (3, 2, 2, 3, 3, 5, N'Lịch nhỏ gọn đúng như mô tả, rất hợp để trên bàn làm việc.', N'Visible', '2026-07-03T11:00:00Z'),
    (4, 2, 5, 4, 5, 5, N'Ảnh gia đình lên màu đẹp, đóng gói cẩn thận.', N'Visible', '2026-07-05T14:00:00Z'),
    (5, 2, 12, 6, 10, 4, N'Planner bìa da đẹp, bố cục dễ ghi chú công việc hằng tuần.', N'Visible', '2026-07-06T08:00:00Z');
SET IDENTITY_INSERT dbo.Reviews OFF;
GO
