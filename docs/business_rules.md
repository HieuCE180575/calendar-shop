# Calendar Shop Business Rules and Use Cases

Tài liệu này tổng hợp các use case và business rule đang có trong hệ thống Calendar Shop. Mục tiêu là giúp giải thích với giảng viên: mỗi chức năng chạy theo luồng nào, rule nghiệp vụ nằm ở đâu, và có thể mở file nào để kiểm tra.

Ghi chú phạm vi:

- Hệ thống không đi theo mức enterprise đầy đủ như audit trail cho mọi thay đổi, nhưng các rule cốt lõi của shop đã được giữ: giá đơn hàng được chốt tại thời điểm đặt, tồn kho được trừ/hoàn, coupon usage được tăng/giảm, user/order/product có trạng thái rõ ràng.
- `OrderStatusHistories` có trong DB seed nhưng service hiện không ghi audit trail. Phần này được xem là ngoài phạm vi để giữ hệ thống gọn.
- Một số chuỗi tiếng Việt trong terminal PowerShell có thể hiện mojibake. Khi cần kiểm tra encoding, ưu tiên xem trực tiếp trong IDE hoặc dùng công cụ đọc UTF-8.

## Tổng Quan Luồng Kiến Trúc

Flow backend theo convention:

```text
Controller -> Service -> Repository -> Entity/Database
```

Flow frontend theo feature:

```text
Page -> Provider/Notifier -> UseCase -> Repository -> DataSource -> Backend API
```

Ví dụ cart coupon check hiện đi theo flow này:

- Page gọi `cartProvider.notifier.checkCoupon`: `mobile_flutter/lib/features/cart/presentation/pages/cart_page.dart:27`.
- Provider gọi use case/repository: `mobile_flutter/lib/features/cart/presentation/providers/cart_provider.dart:145`.
- Repository gọi datasource: `mobile_flutter/lib/features/cart/data/repositories/cart_repository_impl.dart:38`.
- DataSource gọi `/coupons/check`: `mobile_flutter/lib/features/cart/data/datasources/cart_remote_datasource.dart:69`.

## Auth and Account

### UC: Customer Register

Flow:

```text
AuthController.register -> AuthService.RegisterAsync -> Users + email confirmation token -> EmailService
```

Business rules:

- Email là bắt buộc để gửi mail xác nhận kích hoạt tài khoản.
- Email/phone không được trùng user khác.
- User mới là `Customer`, trạng thái `Pending`, chưa được login cho đến khi xác nhận email.
- Token xác nhận email hết hạn sau 24 giờ.

Evidence:

- Register entry point: `backend_api/CalendarShop.Api/Services/AuthService.cs:53`.
- Email confirmation timeout: `backend_api/CalendarShop.Api/Services/AuthService.cs:19`.
- Set token expired time: `backend_api/CalendarShop.Api/Services/AuthService.cs:82`.
- DB user role/status constraints: `sql/CalendarShopDB.sql:41`, `sql/CalendarShopDB.sql:42`.

### UC: Confirm Email / Resend Email Confirmation

Flow:

```text
AuthController.confirm-email/resend -> AuthService -> validate token/email -> activate user
```

Business rules:

- Token xác nhận phải tồn tại và chưa hết hạn.
- Khi xác nhận thành công: `IsEmailConfirmed = true`, xóa token, nếu status đang `Pending` thì chuyển `Active`.
- Resend tạo token mới và giữ user ở `Pending` cho đến khi xác nhận.

Evidence:

- Confirm email: `backend_api/CalendarShop.Api/Services/AuthService.cs:352`.
- Resend confirmation: `backend_api/CalendarShop.Api/Services/AuthService.cs:388`.
- Set lại token resend: `backend_api/CalendarShop.Api/Services/AuthService.cs:409`.

### UC: Login bằng email/số điện thoại

Flow:

```text
AuthController.login -> AuthService.LoginAsync -> PasswordService -> JwtService + RefreshToken
```

Business rules:

- Login có thể bằng email hoặc số điện thoại.
- Sai tài khoản/mật khẩu trả unauthorized.
- User `Locked` không được login.
- User chưa xác nhận email hoặc `Pending` không được login.
- Chỉ user `Active` mới login được.

Evidence:

- Login: `backend_api/CalendarShop.Api/Services/AuthService.cs:93`.
- Login guard: `backend_api/CalendarShop.Api/Services/AuthService.cs:462`.
- Refresh token created after successful login: `backend_api/CalendarShop.Api/Services/AuthService.cs:105`.

### UC: Logout / Refresh Token

Flow:

```text
AuthController.logout/refresh -> AuthService -> RefreshToken repository
```

Business rules:

- Logout không truyền refresh token thì revoke tất cả active refresh token của user.
- Logout truyền refresh token thì chỉ revoke token đó.
- Refresh token phải tồn tại, chưa revoke, chưa hết hạn, và user vẫn được phép login.
- Refresh thành công thì token cũ bị revoke và tạo refresh token mới.

Evidence:

- Logout: `backend_api/CalendarShop.Api/Services/AuthService.cs:191`.
- Refresh: `backend_api/CalendarShop.Api/Services/AuthService.cs:214`.
- Revoke token helper: `backend_api/CalendarShop.Api/Services/AuthService.cs:444`.

### UC: Forgot / Verify / Reset Password

Flow:

```text
forgot-password -> generate OTP -> email
verify-reset-code -> validate OTP
reset-password -> update password -> revoke refresh tokens
```

Business rules:

- OTP reset password hết hạn sau 30 phút.
- Nếu account không tồn tại, hệ thống trả message chung để tránh lộ tài khoản.
- Account locked không được reset password.
- Account chưa xác nhận email không được forgot password.
- Reset password thành công thì token được đánh dấu used và revoke refresh tokens.

Evidence:

- Password reset timeout: `backend_api/CalendarShop.Api/Services/AuthService.cs:18`.
- Forgot password: `backend_api/CalendarShop.Api/Services/AuthService.cs:254`.
- OTP expiry creation: `backend_api/CalendarShop.Api/Services/AuthService.cs:292`.
- Verify reset code: `backend_api/CalendarShop.Api/Services/AuthService.cs:310`.
- Reset password and revoke token: `backend_api/CalendarShop.Api/Services/AuthService.cs:330`, `backend_api/CalendarShop.Api/Services/AuthService.cs:348`.

### UC: Profile View/Edit / Change Password

Flow:

```text
AuthController.me/profile/change-password -> AuthService -> User repository
```

Business rules:

- Profile phải thuộc user đang login.
- Email hoặc phone là bắt buộc.
- Email/phone không được trùng user khác.
- Nếu đổi email thì account quay về `Pending`, email phải xác nhận lại, refresh token bị revoke.
- Change password yêu cầu old password đúng, sau đó revoke refresh tokens.

Evidence:

- Update profile: `backend_api/CalendarShop.Api/Services/AuthService.cs:119`.
- Email change requires confirmation and revokes token: `backend_api/CalendarShop.Api/Services/AuthService.cs:159`, `backend_api/CalendarShop.Api/Services/AuthService.cs:162`.
- Change password: `backend_api/CalendarShop.Api/Services/AuthService.cs:174`.
- Revoke after password change: `backend_api/CalendarShop.Api/Services/AuthService.cs:187`.

## User Management

### UC: User Management - list/detail/search

Flow:

```text
UsersController -> UserService.GetUsersQuery/GetUserByIdAsync
```

Business rules:

- Chỉ admin được gọi controller user management.
- Search theo full name, email, phone.
- Có filter role/status.

Evidence:

- Admin-only controller: `backend_api/CalendarShop.Api/Controllers/UsersController.cs:9`.
- Search/filter query: `backend_api/CalendarShop.Api/Services/UserService.cs:27`.

### UC: User Permission - lock/unlock, role Customer/Admin

Flow:

```text
UsersController.status/role -> UserService -> User repository + RefreshToken repository
```

Business rules:

- Status hợp lệ: `Active`, `Locked`, `Pending`.
- Role hợp lệ: `Customer`, `Admin`.
- Admin không được tự khóa chính mình.
- Admin không được tự hạ quyền chính mình.
- Khi lock user, refresh tokens còn hiệu lực bị revoke.

Evidence:

- Update status: `backend_api/CalendarShop.Api/Services/UserService.cs:71`.
- Self-lock guard: `backend_api/CalendarShop.Api/Services/UserService.cs:76`.
- Revoke tokens when locked: `backend_api/CalendarShop.Api/Services/UserService.cs:87`.
- Update role: `backend_api/CalendarShop.Api/Services/UserService.cs:93`.
- Self-demote guard: `backend_api/CalendarShop.Api/Services/UserService.cs:98`.
- Normalize valid status/role: `backend_api/CalendarShop.Api/Services/UserService.cs:133`, `backend_api/CalendarShop.Api/Services/UserService.cs:144`.

## Product and Category

### UC: Product list/search/filter/sort/by category

Flow:

```text
ProductsController.GetAll -> ProductService.GetAllProductsQuery -> OData query
```

Business rules:

- Public user chỉ thấy product chưa xóa, status `Active`, category `Active`.
- `includeHidden=true` chỉ có tác dụng với admin.
- Giá trả về là giá đã áp discount nếu discount đang active và còn hiệu lực.

Evidence:

- Public includeHidden blocked unless admin: `backend_api/CalendarShop.Api/Controllers/ProductsController.cs:22`.
- Public filter active product/category: `backend_api/CalendarShop.Api/Services/ProductService.cs:40`, `backend_api/CalendarShop.Api/Services/ProductService.cs:42`.
- Discounted price in list: `backend_api/CalendarShop.Api/Services/ProductService.cs:49`.
- Discount calculation: `backend_api/CalendarShop.Api/Services/DiscountService.cs:27`.

### UC: Product detail

Flow:

```text
ProductsController.GetById -> ProductService.GetProductByIdAsync
```

Business rules:

- Public user không xem được product hidden/deleted hoặc product thuộc category hidden.
- Admin có thể xem product hidden để quản lý.
- Detail cũng trả giá sau discount nếu discount hợp lệ.

Evidence:

- Controller passes admin flag: `backend_api/CalendarShop.Api/Controllers/ProductsController.cs:29`.
- Product detail filters by `IsDeleted`: `backend_api/CalendarShop.Api/Services/ProductService.cs:67`.
- Public detail filters active product/category: `backend_api/CalendarShop.Api/Services/ProductService.cs:69`, `backend_api/CalendarShop.Api/Services/ProductService.cs:71`.

### UC: Product CRUD

Flow:

```text
ProductsController admin endpoints -> ProductService -> Product repository
```

Business rules:

- Product CRUD là admin-only.
- Create/update product phải có category hợp lệ.
- Product không thể `Active` nếu category đang hidden.
- Product `Active` với stock 0 tự chuyển `OutOfStock`.
- Không cho set `OutOfStock` nếu stock vẫn còn.
- Delete product là soft delete: `IsDeleted = true`, `Status = Hidden`.

Evidence:

- Admin-only create/update/stock/status/delete: `backend_api/CalendarShop.Api/Controllers/ProductsController.cs:33`, `backend_api/CalendarShop.Api/Controllers/ProductsController.cs:41`, `backend_api/CalendarShop.Api/Controllers/ProductsController.cs:49`, `backend_api/CalendarShop.Api/Controllers/ProductsController.cs:57`, `backend_api/CalendarShop.Api/Controllers/ProductsController.cs:65`.
- Create product rules: `backend_api/CalendarShop.Api/Services/ProductService.cs:92`, `backend_api/CalendarShop.Api/Services/ProductService.cs:95`, `backend_api/CalendarShop.Api/Services/ProductService.cs:96`.
- Update product rules: `backend_api/CalendarShop.Api/Services/ProductService.cs:102`, `backend_api/CalendarShop.Api/Services/ProductService.cs:111`, `backend_api/CalendarShop.Api/Services/ProductService.cs:112`.
- Stock/status rules: `backend_api/CalendarShop.Api/Services/ProductService.cs:118`, `backend_api/CalendarShop.Api/Services/ProductService.cs:129`, `backend_api/CalendarShop.Api/Services/ProductService.cs:141`, `backend_api/CalendarShop.Api/Services/ProductService.cs:154`, `backend_api/CalendarShop.Api/Services/ProductService.cs:156`, `backend_api/CalendarShop.Api/Services/ProductService.cs:159`.
- Soft delete: `backend_api/CalendarShop.Api/Services/ProductService.cs:167`, `backend_api/CalendarShop.Api/Services/ProductService.cs:175`.
- DB constraints: `sql/CalendarShopDB.sql:140`, `sql/CalendarShopDB.sql:141`, `sql/CalendarShopDB.sql:142`.

### UC: Category CRUD

Flow:

```text
CategoriesController -> CategoryService -> Category/Product repositories
```

Business rules:

- Category create/update/delete là admin-only.
- Delete category là hide category, không xóa cứng.
- Khi category bị hidden, các product active trong category cũng bị hidden.

Evidence:

- Category service methods: `backend_api/CalendarShop.Api/Services/CategoryService.cs:34`, `backend_api/CalendarShop.Api/Services/CategoryService.cs:42`, `backend_api/CalendarShop.Api/Services/CategoryService.cs:62`.
- Hide active products after category hidden/delete: `backend_api/CalendarShop.Api/Services/CategoryService.cs:56`, `backend_api/CalendarShop.Api/Services/CategoryService.cs:73`, `backend_api/CalendarShop.Api/Services/CategoryService.cs:78`.
- DB category status constraint: `sql/CalendarShopDB.sql:103`.

## Discount and Coupon

### UC: Discount CRUD / Status / Settings

Flow:

```text
DiscountsController admin -> DiscountService -> Product/Discount repositories
```

Business rules:

- Discount là admin-only.
- Discount type chỉ được `Percent` hoặc `FixedAmount`.
- Percent không được vượt quá 100.
- StartDate phải trước EndDate.
- Status chỉ `Active` hoặc `Inactive`.
- Discount chỉ gán vào product chưa xóa và không hidden.
- Không cho product có nhiều discount active bị overlap thời gian.
- FixedAmount giảm quá giá sản phẩm thì giá sau giảm được clamp về 0, không âm.
- Delete discount là hard delete, product FK dùng `ON DELETE SET NULL`, order cũ vẫn đúng vì order item đã snapshot giá.

Evidence:

- Admin-only discounts controller: `backend_api/CalendarShop.Api/Controllers/DiscountsController.cs:9`.
- Validator type/value/date/status: `backend_api/CalendarShop.Api/Validators/DiscountValidators.cs:13`, `backend_api/CalendarShop.Api/Validators/DiscountValidators.cs:20`, `backend_api/CalendarShop.Api/Validators/DiscountValidators.cs:25`, `backend_api/CalendarShop.Api/Validators/DiscountValidators.cs:28`.
- Create/update/status/delete service: `backend_api/CalendarShop.Api/Services/DiscountService.cs:72`, `backend_api/CalendarShop.Api/Services/DiscountService.cs:93`, `backend_api/CalendarShop.Api/Services/DiscountService.cs:119`, `backend_api/CalendarShop.Api/Services/DiscountService.cs:161`.
- Filter target products: `backend_api/CalendarShop.Api/Services/DiscountService.cs:173`, `backend_api/CalendarShop.Api/Services/DiscountService.cs:185`.
- Overlap check when status active: `backend_api/CalendarShop.Api/Services/DiscountService.cs:129`, `backend_api/CalendarShop.Api/Services/DiscountService.cs:136`, `backend_api/CalendarShop.Api/Services/DiscountService.cs:149`.
- Overlap check when assign targets: `backend_api/CalendarShop.Api/Services/DiscountService.cs:192`, `backend_api/CalendarShop.Api/Services/DiscountService.cs:195`, `backend_api/CalendarShop.Api/Services/DiscountService.cs:208`.
- Clamp discounted price: `backend_api/CalendarShop.Api/Services/DiscountService.cs:44`, `backend_api/CalendarShop.Api/Services/DiscountService.cs:46`.
- DB product discount FK set null: `sql/CalendarShopDB.sql:139`.

### UC: Coupon Status / Settings / Check Coupon

Flow:

```text
CouponsController admin/check -> CouponService -> Coupon repository
```

Business rules:

- Coupon CRUD/status là admin-only, riêng `check` cho phép anonymous để cart/checkout kiểm mã.
- Coupon code được normalize `Trim + Uppercase`.
- Coupon code unique.
- Discount type chỉ `Percent` hoặc `Amount`.
- Percent không quá 100.
- Min order value >= 0.
- Usage limit nếu có thì > 0.
- Không được update usage limit nhỏ hơn số lượt đã dùng.
- Check coupon yêu cầu subtotal > 0, coupon active, đúng thời gian, đạt min order, chưa hết usage limit.

Evidence:

- Admin-only coupons controller: `backend_api/CalendarShop.Api/Controllers/CouponsController.cs:9`.
- Check coupon anonymous: `backend_api/CalendarShop.Api/Controllers/CouponsController.cs:26`, `backend_api/CalendarShop.Api/Controllers/CouponsController.cs:27`.
- Create/update normalize + unique: `backend_api/CalendarShop.Api/Services/CouponService.cs:43`, `backend_api/CalendarShop.Api/Services/CouponService.cs:45`, `backend_api/CalendarShop.Api/Services/CouponService.cs:46`, `backend_api/CalendarShop.Api/Services/CouponService.cs:67`, `backend_api/CalendarShop.Api/Services/CouponService.cs:68`, `backend_api/CalendarShop.Api/Services/CouponService.cs:142`.
- Usage limit cannot go below used count: `backend_api/CalendarShop.Api/Services/CouponService.cs:74`.
- Check coupon rules: `backend_api/CalendarShop.Api/Services/CouponService.cs:97`, `backend_api/CalendarShop.Api/Services/CouponService.cs:99`, `backend_api/CalendarShop.Api/Services/CouponService.cs:106`, `backend_api/CalendarShop.Api/Services/CouponService.cs:113`, `backend_api/CalendarShop.Api/Services/CouponService.cs:118`, `backend_api/CalendarShop.Api/Services/CouponService.cs:123`.
- Validator rules: `backend_api/CalendarShop.Api/Validators/CouponValidators.cs:17`, `backend_api/CalendarShop.Api/Validators/CouponValidators.cs:25`, `backend_api/CalendarShop.Api/Validators/CouponValidators.cs:28`, `backend_api/CalendarShop.Api/Validators/CouponValidators.cs:31`, `backend_api/CalendarShop.Api/Validators/CouponValidators.cs:35`, `backend_api/CalendarShop.Api/Validators/CouponValidators.cs:39`.

## Cart and Checkout

### UC: Cart List / Total

Flow:

```text
CartController.Get -> CartService.GetCartQuery -> product discount calculation -> DTO
```

Business rules:

- Cart chỉ lấy item của user đang login.
- Cart line total được tính bằng giá hiện tại sau discount nhân quantity.
- Cart total ở frontend chỉ cộng item được selected.

Evidence:

- Cart auth controller: `backend_api/CalendarShop.Api/Controllers/CartController.cs:10`.
- Cart query by user: `backend_api/CalendarShop.Api/Services/CartService.cs:29`.
- Line total discounted: `backend_api/CalendarShop.Api/Services/CartService.cs:47`.
- Frontend selected total: `mobile_flutter/lib/features/cart/presentation/providers/cart_provider.dart:151`.

### UC: Cart Add / Quantity / Select / Remove

Flow:

```text
CartController -> CartService -> CartItem repository
```

Business rules:

- Chỉ user login mới thao tác cart.
- Add/update cart chỉ với product chưa xóa, status `Active`, category `Active`.
- Quantity phải > 0.
- Không được vượt quá tồn kho.
- Cùng user + product chỉ có một cart item, add thêm sẽ cộng quantity nếu không vượt tồn.
- Remove cart chỉ xóa item thuộc user hiện tại.

Evidence:

- Quantity validator: `backend_api/CalendarShop.Api/Validators/CartValidators.cs:13`, `backend_api/CalendarShop.Api/Validators/CartValidators.cs:22`.
- Add cart product/category check: `backend_api/CalendarShop.Api/Services/CartService.cs:54`, `backend_api/CalendarShop.Api/Services/CartService.cs:62`.
- Add cart stock check: `backend_api/CalendarShop.Api/Services/CartService.cs:66`, `backend_api/CalendarShop.Api/Services/CartService.cs:80`.
- Update cart product/category/stock check: `backend_api/CalendarShop.Api/Services/CartService.cs:92`, `backend_api/CalendarShop.Api/Services/CartService.cs:107`, `backend_api/CalendarShop.Api/Services/CartService.cs:111`.
- Update select state: `backend_api/CalendarShop.Api/Services/CartService.cs:117`.
- Delete cart item: `backend_api/CalendarShop.Api/Services/CartService.cs:123`.
- DB unique cart item: `sql/CalendarShopDB.sql:168`.

### UC: Checkout / Create Order

Flow:

```text
OrdersController.Create -> OrderService.CreateOrderAsync -> selected cart -> stock/coupon validation -> create order/order items -> subtract stock -> clear selected cart
```

Business rules:

- User phải login.
- Chỉ checkout selected cart items.
- Cart không được rỗng.
- Product phải active, chưa xóa, category active.
- Stock phải đủ tại thời điểm checkout.
- Giá order item được snapshot tại lúc đặt hàng.
- Order tổng tiền được snapshot: subtotal, discount amount, shipping fee, total amount.
- Coupon code được normalize uppercase.
- Coupon phải active, đúng thời gian, đạt min order, chưa hết usage limit.
- Coupon fixed amount không được làm tổng tiền âm.
- Shipping fee hiện rule: subtotal >= 300000 thì free ship, ngược lại 30000.
- Sau khi đặt: trừ stock, nếu stock <= 0 thì product thành `OutOfStock`.
- Coupon used count tăng 1.
- Selected cart items bị remove.

Evidence:

- Create order entry: `backend_api/CalendarShop.Api/Services/OrderService.cs:54`.
- Selected cart only: `backend_api/CalendarShop.Api/Services/OrderService.cs:54`.
- Product/category/stock checks: `backend_api/CalendarShop.Api/Services/OrderService.cs:76`, `backend_api/CalendarShop.Api/Services/OrderService.cs:80`.
- Coupon normalize and active lookup: `backend_api/CalendarShop.Api/Services/OrderService.cs:90`, `backend_api/CalendarShop.Api/Services/OrderService.cs:92`, `backend_api/CalendarShop.Api/Services/OrderService.cs:93`.
- Coupon min/date/usage checks: `backend_api/CalendarShop.Api/Services/OrderService.cs:113`, `backend_api/CalendarShop.Api/Services/OrderService.cs:118`, `backend_api/CalendarShop.Api/Services/OrderService.cs:123`.
- Coupon discount clamp: `backend_api/CalendarShop.Api/Services/OrderService.cs:127`, `backend_api/CalendarShop.Api/Services/OrderService.cs:129`.
- Order snapshot fields: `backend_api/CalendarShop.Api/Services/OrderService.cs:122`, `backend_api/CalendarShop.Api/Services/OrderService.cs:127`, `backend_api/CalendarShop.Api/Services/OrderService.cs:128`, `backend_api/CalendarShop.Api/Services/OrderService.cs:129`, `backend_api/CalendarShop.Api/Services/OrderService.cs:130`, `backend_api/CalendarShop.Api/Services/OrderService.cs:131`.
- Order item snapshot and stock subtract: `backend_api/CalendarShop.Api/Services/OrderService.cs:149`, `backend_api/CalendarShop.Api/Services/OrderService.cs:150`.
- DB amount check: `sql/CalendarShopDB.sql:227`.

## Order and Payment

### UC: Order History / Detail

Flow:

```text
OrdersController.mine/{id} -> OrderService -> Order repository
```

Business rules:

- Customer chỉ xem đơn của chính mình.
- Order history sort mới nhất trước.
- Order detail kiểm `OrderId` + `UserId`.

Evidence:

- Get my orders: `backend_api/CalendarShop.Api/Services/OrderService.cs:170`.
- Get order by user/id: `backend_api/CalendarShop.Api/Services/OrderService.cs:178`.

### UC: Cancel Order

Flow:

```text
OrdersController.cancel -> OrderService.CancelOrderAsync -> restore stock/coupon -> notification
```

Business rules:

- Customer chỉ cancel order của chính mình.
- Chỉ được cancel khi order còn `Pending`.
- Cancel đổi status thành `Cancelled`, lưu cancel reason.
- Hoàn stock cho order items.
- Nếu product hết hàng được hoàn stock, chỉ bật lại `Active` nếu category vẫn active, nếu không thì hidden.
- Nếu order có coupon, trả lại used count.

Evidence:

- Cancel own order: `backend_api/CalendarShop.Api/Services/OrderService.cs:193`.
- Pending-only cancel: `backend_api/CalendarShop.Api/Services/OrderService.cs:202`.
- Set cancelled/reason: `backend_api/CalendarShop.Api/Services/OrderService.cs:207`.
- Restore stock/category-aware status: `backend_api/CalendarShop.Api/Services/OrderService.cs:219`, `backend_api/CalendarShop.Api/Services/OrderService.cs:220`, `backend_api/CalendarShop.Api/Services/OrderService.cs:222`.
- Restore coupon usage: `backend_api/CalendarShop.Api/Services/OrderService.cs:228`, `backend_api/CalendarShop.Api/Services/OrderService.cs:427`.

### UC: Admin Order Management / Search / Filter / Update Status

Flow:

```text
OrdersController.admin -> OrderService.AdminGetAllOrdersQuery/AdminUpdateOrderStatusAsync
```

Business rules:

- Admin-only.
- Admin list tất cả order, frontend/OData có thể search/filter.
- Status transition hợp lệ: `Pending -> Confirmed`, `Confirmed -> Shipping`, `Shipping -> Delivered`, `Pending -> Cancelled`.
- Không cho nhảy trạng thái ngược hoặc bỏ bước.
- Admin cancel pending order cũng hoàn stock và coupon usage.
- Update status tạo notification cho customer.

Evidence:

- Admin endpoints: `backend_api/CalendarShop.Api/Controllers/OrdersController.cs:55`, `backend_api/CalendarShop.Api/Controllers/OrdersController.cs:64`.
- Admin list: `backend_api/CalendarShop.Api/Services/OrderService.cs:239`.
- Valid transitions: `backend_api/CalendarShop.Api/Services/OrderService.cs:258`, `backend_api/CalendarShop.Api/Services/OrderService.cs:259`, `backend_api/CalendarShop.Api/Services/OrderService.cs:260`, `backend_api/CalendarShop.Api/Services/OrderService.cs:261`.
- Admin cancel restores stock/coupon: `backend_api/CalendarShop.Api/Services/OrderService.cs:270`, `backend_api/CalendarShop.Api/Services/OrderService.cs:272`.
- Notification content by status: `backend_api/CalendarShop.Api/Services/OrderService.cs:286`.

### UC: Re-order

Flow:

```text
OrdersController.reorder -> OrderService.ReorderAsync -> add old items back to cart
```

Business rules:

- User chỉ reorder đơn của chính mình.
- Product đã xóa, hidden, inactive, hoặc category hidden thì bỏ qua.
- Quantity reorder được cap theo stock hiện tại.
- Nếu cart đã có product thì cộng quantity nhưng không vượt stock.

Evidence:

- Reorder entry: `backend_api/CalendarShop.Api/Services/OrderService.cs:516`.
- Product/category guard: `backend_api/CalendarShop.Api/Services/OrderService.cs:537`.
- Cap quantity by stock: `backend_api/CalendarShop.Api/Services/OrderService.cs:548`, `backend_api/CalendarShop.Api/Services/OrderService.cs:555`.

### UC: VNPay Payment

Flow:

```text
Checkout creates VNPay order -> PaymentController.GenerateVNPayUrl -> VNPay -> PaymentController.VNPayReturn -> OrderService.HandlePaymentCallbackAsync
```

Business rules:

- Chỉ order thuộc user hiện tại được tạo payment URL.
- Chỉ order `PaymentMethod = VNPay` và `Status = Pending` được thanh toán VNPay.
- Callback validate chữ ký VNPay.
- Callback validate terminal code nếu cấu hình có `VNPay:TmnCode`.
- Callback validate amount bằng order total.
- Success chuyển order `Pending -> Confirmed`.
- Fail/cancel chuyển order `Pending -> Cancelled`, hoàn stock và coupon usage.
- VNPay pending quá 15 phút tự expire/cancel.
- Callback trễ sau khi order đã không còn Pending không báo success giả trừ khi order đã Confirmed.

Evidence:

- Generate VNPay URL: `backend_api/CalendarShop.Api/Controllers/PaymentController.cs:26`.
- Only VNPay and Pending: `backend_api/CalendarShop.Api/Controllers/PaymentController.cs:33`, `backend_api/CalendarShop.Api/Controllers/PaymentController.cs:38`.
- Callback route: `backend_api/CalendarShop.Api/Controllers/PaymentController.cs:48`.
- Signature validation: `backend_api/CalendarShop.Api/Services/OrderService.cs:320`.
- Terminal code validation: `backend_api/CalendarShop.Api/Services/OrderService.cs:338`.
- Non-VNPay callback rejected: `backend_api/CalendarShop.Api/Services/OrderService.cs:361`.
- Expired order rejected/cancelled: `backend_api/CalendarShop.Api/Services/OrderService.cs:367`, `backend_api/CalendarShop.Api/Services/OrderService.cs:370`.
- Amount validation: `backend_api/CalendarShop.Api/Services/OrderService.cs:375`.
- Status not pending handling: `backend_api/CalendarShop.Api/Services/OrderService.cs:381`, `backend_api/CalendarShop.Api/Services/OrderService.cs:384`.
- Success/fail status update: `backend_api/CalendarShop.Api/Services/OrderService.cs:391`, `backend_api/CalendarShop.Api/Services/OrderService.cs:395`.
- Pending timeout: `backend_api/CalendarShop.Api/Services/OrderService.cs:17`, `backend_api/CalendarShop.Api/Services/OrderService.cs:445`, `backend_api/CalendarShop.Api/Services/OrderService.cs:447`.
- Background cleanup service: `backend_api/CalendarShop.Api/Infrastructure/VNPayPendingOrderCleanupService.cs:5`, `backend_api/CalendarShop.Api/Infrastructure/VNPayPendingOrderCleanupService.cs:31`.

## Review

### UC: Review Rating / Comment / List / Permission

Flow:

```text
ReviewsController -> ReviewService -> OrderItem/Order/Product/Review repositories
```

Business rules:

- Chỉ user login mới tạo/sửa/xóa review của mình.
- Public có thể xem review visible của product.
- Chỉ được review sản phẩm trong order của chính user.
- Chỉ order `Delivered` mới được review.
- Rating từ 1 đến 5.
- Mỗi user/product/order item chỉ có một review.
- Review delete là soft delete sang `Hidden`.
- Nếu review hidden được tạo lại cho cùng order item thì khôi phục sang `Visible` và cập nhật nội dung.

Evidence:

- Create review: `backend_api/CalendarShop.Api/Services/ReviewService.cs:32`.
- Order ownership check: `backend_api/CalendarShop.Api/Services/ReviewService.cs:51`.
- Existing review/unique logic: `backend_api/CalendarShop.Api/Services/ReviewService.cs:63`, `backend_api/CalendarShop.Api/Services/ReviewService.cs:69`.
- Restore hidden review: `backend_api/CalendarShop.Api/Services/ReviewService.cs:77`, `backend_api/CalendarShop.Api/Services/ReviewService.cs:78`.
- New review visible: `backend_api/CalendarShop.Api/Services/ReviewService.cs:102`, `backend_api/CalendarShop.Api/Services/ReviewService.cs:105`.
- Update own visible review: `backend_api/CalendarShop.Api/Services/ReviewService.cs:121`, `backend_api/CalendarShop.Api/Services/ReviewService.cs:138`.
- Soft delete review: `backend_api/CalendarShop.Api/Services/ReviewService.cs:156`, `backend_api/CalendarShop.Api/Services/ReviewService.cs:172`.
- Public visible list and summary: `backend_api/CalendarShop.Api/Services/ReviewService.cs:179`, `backend_api/CalendarShop.Api/Services/ReviewService.cs:197`.
- Rating validator/DB check: `backend_api/CalendarShop.Api/Validators/ReviewValidators.cs:13`, `sql/CalendarShopDB.sql:293`.
- Unique review DB constraint: `sql/CalendarShopDB.sql:295`.

## Favorite

### UC: Favorite CRUD

Flow:

```text
FavoritesController -> FavoriteService -> Favorite/Product repositories
```

Business rules:

- User phải login.
- Chỉ favorite product tồn tại, chưa xóa, không hidden, category active.
- Không favorite trùng cùng user/product.
- Remove favorite chỉ xóa favorite của chính user.

Evidence:

- Add favorite: `backend_api/CalendarShop.Api/Services/FavoriteService.cs:26`.
- Product/category guard: `backend_api/CalendarShop.Api/Services/FavoriteService.cs:38`.
- Duplicate guard: `backend_api/CalendarShop.Api/Services/FavoriteService.cs:45`.
- Remove own favorite: `backend_api/CalendarShop.Api/Services/FavoriteService.cs:71`.
- DB unique favorite: `sql/CalendarShopDB.sql:180`.

## Address

### UC: Address CRUD / Default Address

Flow:

```text
AddressesController -> AddressService -> UserAddress repository
```

Business rules:

- User chỉ thao tác địa chỉ của chính mình.
- Địa chỉ đầu tiên tự động thành default.
- Khi tạo/update một địa chỉ thành default, địa chỉ default cũ bị bỏ default.
- Không cho user không còn default nếu vẫn còn địa chỉ khác.
- Xóa default address thì địa chỉ còn lại mới nhất được set default.

Evidence:

- Query own addresses: `backend_api/CalendarShop.Api/Services/AddressService.cs:23`.
- Ownership check detail/update/delete: `backend_api/CalendarShop.Api/Services/AddressService.cs:31`, `backend_api/CalendarShop.Api/Services/AddressService.cs:67`, `backend_api/CalendarShop.Api/Services/AddressService.cs:112`.
- First address default: `backend_api/CalendarShop.Api/Services/AddressService.cs:45`.
- Replace existing default: `backend_api/CalendarShop.Api/Services/AddressService.cs:49`, `backend_api/CalendarShop.Api/Services/AddressService.cs:78`.
- Keep at least one default: `backend_api/CalendarShop.Api/Services/AddressService.cs:94`.
- Delete default assigns new default: `backend_api/CalendarShop.Api/Services/AddressService.cs:118`.
- Set default: `backend_api/CalendarShop.Api/Services/AddressService.cs:137`.

## Notification

### UC: Notification Center / Read / Register Token / Holiday Trigger

Flow:

```text
NotificationsController -> NotificationService -> Notification/User repositories
```

Business rules:

- User chỉ xem và mark read notification của chính mình.
- Mark all read chỉ tác động unread notification của user hiện tại.
- Create notification phải có user tồn tại.
- FCM token không được rỗng.
- FCM hiện chỉ log mô phỏng, notification center trong app là phần thật.
- Holiday reminder chỉ gửi cho user `Active`, không gửi trùng cùng ngày/type/title.
- Admin mới được trigger holiday reminder thủ công.

Evidence:

- User notification query: `backend_api/CalendarShop.Api/Services/NotificationService.cs:26`.
- Mark one read by user: `backend_api/CalendarShop.Api/Services/NotificationService.cs:34`.
- Mark all read by user: `backend_api/CalendarShop.Api/Services/NotificationService.cs:49`.
- Create notification requires user: `backend_api/CalendarShop.Api/Services/NotificationService.cs:66`.
- FCM simulation log: `backend_api/CalendarShop.Api/Services/NotificationService.cs:84`.
- Register FCM token: `backend_api/CalendarShop.Api/Services/NotificationService.cs:98`.
- Holiday active users and duplicate guard: `backend_api/CalendarShop.Api/Services/NotificationService.cs:128`, `backend_api/CalendarShop.Api/Services/NotificationService.cs:136`.
- Admin trigger endpoint: `backend_api/CalendarShop.Api/Controllers/NotificationsController.cs:48`, `backend_api/CalendarShop.Api/Controllers/NotificationsController.cs:49`.

## Admin Dashboard and Export

### UC: Statistics Dashboard / Statistics Detail / Admin Dashboard / Export Revenue

Flow:

```text
AdminDashboardController -> AdminDashboardService -> Order/OrderItem/User/Product repositories -> DTO/Excel
```

Business rules:

- Admin-only.
- Revenue chỉ tính order `Delivered`.
- Products sold/best selling chỉ tính order item thuộc order `Delivered`.
- Orders by status lấy tất cả trạng thái để dashboard theo dõi vận hành.
- Low stock là product chưa xóa có stock < 10.
- Export revenue dùng cùng data dashboard và export delivered orders.

Evidence:

- Admin-only controller: `backend_api/CalendarShop.Api/Controllers/AdminDashboardController.cs:7`.
- Dashboard entry: `backend_api/CalendarShop.Api/Services/AdminDashboardService.cs:32`.
- Delivered revenue: `backend_api/CalendarShop.Api/Services/AdminDashboardService.cs:34`.
- Sold/best-selling delivered only: `backend_api/CalendarShop.Api/Services/AdminDashboardService.cs:38`, `backend_api/CalendarShop.Api/Services/AdminDashboardService.cs:47`.
- Revenue by day/month delivered only: `backend_api/CalendarShop.Api/Services/AdminDashboardService.cs:55`, `backend_api/CalendarShop.Api/Services/AdminDashboardService.cs:67`.
- Low stock: `backend_api/CalendarShop.Api/Services/AdminDashboardService.cs:81`.
- Export endpoint: `backend_api/CalendarShop.Api/Controllers/AdminDashboardController.cs:24`.
- Export delivered orders: `backend_api/CalendarShop.Api/Services/AdminDashboardService.cs:116`, `backend_api/CalendarShop.Api/Services/AdminDashboardService.cs:191`.

## ChatBot API

### UC: Chatbot hỏi sản phẩm, giá, tồn kho, coupon, bán gần đây

Flow:

```text
ChatController.ask -> ChatAssistantService -> Product/Coupon/Order repositories -> optional LocalLlmService
```

Business rules:

- Message không được rỗng.
- Query được normalize: lower case, bỏ dấu, map synonym, bỏ ký tự nhiễu.
- Chatbot chỉ lấy product chưa xóa và không hidden.
- Chatbot tìm product bằng score theo name/description/category/calendar type.
- Coupon candidate chỉ lấy coupon active và còn trong thời gian hiệu lực.
- Nếu câu hỏi chung về list/stock/price range/recent sales thì backend tự trả lời aggregate, không cần LLM.
- Nếu có nhiều kết quả gần nhau thì yêu cầu user làm rõ.
- Prompt bắt LLM chỉ trả lời theo context, không tự bịa giá/tồn kho/coupon.

Evidence:

- Ask entry and empty guard: `backend_api/CalendarShop.Api/Services/ChatAssistantService.cs:75`.
- Query normalization/tokenize: `backend_api/CalendarShop.Api/Services/ChatAssistantService.cs:81`.
- Product data scope: `backend_api/CalendarShop.Api/Services/ChatAssistantService.cs:85`.
- Aggregate answer before LLM: `backend_api/CalendarShop.Api/Services/ChatAssistantService.cs:90`.
- Product/coupon candidate scoring: `backend_api/CalendarShop.Api/Services/ChatAssistantService.cs:113`, `backend_api/CalendarShop.Api/Services/ChatAssistantService.cs:114`.
- Clarification rule: `backend_api/CalendarShop.Api/Services/ChatAssistantService.cs:127`.
- Coupon active/date filter: `backend_api/CalendarShop.Api/Services/ChatAssistantService.cs:298`.
- Product scoring: `backend_api/CalendarShop.Api/Services/ChatAssistantService.cs:310`.
- Prompt anti-hallucination rules: `backend_api/CalendarShop.Api/Services/ChatAssistantService.cs:425`.
- Normalize text implementation: `backend_api/CalendarShop.Api/Services/ChatAssistantService.cs:446`.

## Database Constraints

Các rule ở tầng DB giúp chặn dữ liệu sai kể cả khi code lỗi:

- User phải có email hoặc phone: `sql/CalendarShopDB.sql:40`.
- Role user chỉ `Customer/Admin`: `sql/CalendarShopDB.sql:41`.
- Status user chỉ `Active/Locked/Pending`: `sql/CalendarShopDB.sql:42`.
- Category status chỉ `Active/Hidden`: `sql/CalendarShopDB.sql:103`.
- Discount type/status/date hợp lệ: `sql/CalendarShopDB.sql:117`, `sql/CalendarShopDB.sql:118`, `sql/CalendarShopDB.sql:119`.
- Product price/stock/status hợp lệ: `sql/CalendarShopDB.sql:140`, `sql/CalendarShopDB.sql:141`, `sql/CalendarShopDB.sql:142`.
- Cart quantity > 0 và unique user/product: `sql/CalendarShopDB.sql:167`, `sql/CalendarShopDB.sql:168`.
- Favorite unique user/product: `sql/CalendarShopDB.sql:180`.
- Coupon type/status/date hợp lệ: `sql/CalendarShopDB.sql:199`, `sql/CalendarShopDB.sql:200`, `sql/CalendarShopDB.sql:201`.
- Order status/payment/amount hợp lệ: `sql/CalendarShopDB.sql:225`, `sql/CalendarShopDB.sql:226`, `sql/CalendarShopDB.sql:227`.
- Order item quantity/price hợp lệ: `sql/CalendarShopDB.sql:244`, `sql/CalendarShopDB.sql:245`.
- Review rating/status/unique hợp lệ: `sql/CalendarShopDB.sql:293`, `sql/CalendarShopDB.sql:294`, `sql/CalendarShopDB.sql:295`.

## UC Có Trong Code Nhưng Không Nằm Rõ Trong Backlog

Các chức năng này nên ghi thêm vào backlog/report nếu muốn đầy đủ hơn:

- Email confirmation / resend email confirmation.
- Refresh token / auto refresh authentication.
- Profile update.
- User address CRUD/default address.
- Notification center/read/read all/register FCM token/holiday reminder.
- VNPay return callback và pending-payment cleanup.
- Re-order.
- Chatbot hỏi sản phẩm, tồn kho, giá, coupon, đơn bán gần đây.
- Admin low-stock/recent orders trong dashboard.
- Product detail public/admin behavior.
- Coupon check public endpoint dùng cho cart/checkout.

## Điểm Có Thể Giải Thích Khi Bị Hỏi

- Order không xóa: order là chứng từ giao dịch, chỉ update status/cancel.
- Product không xóa cứng: product delete là soft delete để không làm hỏng order/review/favorite cũ.
- Coupon không có delete endpoint trong controller; nếu order đang reference coupon, DB FK cũng bảo vệ không xóa bừa.
- Discount delete hard-delete được chấp nhận trong scope project vì order đã snapshot giá cuối cùng trong `OrderItems.UnitPrice`, `OrderItems.TotalPrice`, `Orders.TotalAmount`.
- Notification FCM hiện là mô phỏng bằng log; phần notification center trong app mới là phần hoàn chỉnh để demo.
