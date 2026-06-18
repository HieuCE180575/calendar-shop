# Chia task cho nhóm

## Người 1: Auth + Profile

Mobile:

```text
mobile_flutter/lib/features/auth
mobile_flutter/lib/features/profile
```

Backend:

```text
backend_api/CalendarShop.Api/Controllers/AuthController.cs
```

Task:

- Login bằng email/số điện thoại
- Register
- Logout
- Lưu trạng thái login bằng token
- Forgot/change password
- CRUD profile

## Người 2: Product + Category Customer

Mobile:

```text
mobile_flutter/lib/features/product
mobile_flutter/lib/features/category
```

Backend:

```text
ProductsController.cs
CategoriesController.cs
```

Task:

- Danh sách sản phẩm
- Tìm kiếm theo tên lịch
- Lọc theo giá
- Lọc theo loại lịch
- Sort giá tăng/giảm, mới nhất
- Chi tiết sản phẩm

## Người 3: Cart + Order Customer

Mobile:

```text
mobile_flutter/lib/features/cart
mobile_flutter/lib/features/order
```

Backend:

```text
CartController.cs
OrdersController.cs
```

Task:

- Thêm vào giỏ
- Tăng/giảm số lượng
- Chọn/bỏ chọn sản phẩm
- Tính tổng tiền
- Kiểm tra tồn kho trước khi đặt hàng
- Xem đơn hàng
- Hủy đơn Pending
- Mua lại đơn cũ

## Người 4: Favorite + Review

Mobile:

```text
mobile_flutter/lib/features/favorite
mobile_flutter/lib/features/review
```

Backend cần tạo thêm:

```text
FavoritesController.cs
ReviewsController.cs
```

Task:

- Yêu thích sản phẩm
- Xem danh sách yêu thích
- Xóa yêu thích
- Đánh giá sao 1-5
- Bình luận
- Chỉ đánh giá sản phẩm đã mua

## Người 5: Admin Management

Mobile:

```text
mobile_flutter/lib/features/admin
```

Backend:

```text
ProductsController.cs
CategoriesController.cs
OrdersController.cs
AdminDashboardController.cs
```

Task:

- Admin CRUD sản phẩm
- Admin CRUD danh mục
- Admin quản lý đơn hàng
- Admin cập nhật trạng thái đơn
- Quản lý user
- Quản lý coupon
- Dashboard thống kê
