# Ghi chú merge chức năng Email/Auth/User Management vào nhánh `dev`

## Thông tin merge

- Source Git nền: nhánh `dev`, commit `fde97cd`.
- Source chức năng email/debug SMTP được xác định phát triển từ commit `d9844f2`.
- Commit feature trung gian: `41750a9`.
- Cách gộp: merge ba chiều để giữ nguyên phần Dashboard/Statistics đã được thêm sau commit `d9844f2`.

## Xung đột đã xử lý thủ công

### `mobile_flutter/lib/core/routes/app_router.dart`

Giữ đồng thời:

- Route Dashboard: `/admin/statistics`.
- Route quản lý user: `/admin/users`, `/admin/users/:id`.
- Route auth mới: `/forgot-password`, `/reset-password`, `/confirm-email`, `/profile`, `/change-password`.

### `sql/CalendarShopDB.sql`

Giữ đồng thời:

- Dữ liệu seed và ID cố định phục vụ Dashboard/Order.
- Các cột xác nhận email trong bảng `Users`.
- Bảng `PasswordResetTokens`.
- User seed được đánh dấu `IsEmailConfirmed = 1` để tài khoản demo vẫn đăng nhập được.

## Backend — class/file đã sửa

### Controllers

- `AuthController.cs`
  - Đăng ký tài khoản chờ xác nhận email.
  - Xác nhận email bằng link hoặc token.
  - Gửi lại email xác nhận.
  - Logout và thu hồi refresh token.
  - Xem/cập nhật profile.
  - Đổi mật khẩu.
  - Quên/đặt lại mật khẩu.

### Data, DTO, Mapping, Model

- `AppDbContext.cs`
  - Thêm `DbSet<PasswordResetToken>`.
  - Thêm index token xác nhận email.
  - Cấu hình quan hệ `User` — `PasswordResetToken`.
- `AuthDtos.cs`
  - Bổ sung request/response cho register, logout, profile, forgot/reset password, confirm email và quản lý user.
- `AuthMappingProfile.cs`
  - User mới mặc định `Pending`, chưa xác nhận email.
- `User.cs`
  - Thêm trạng thái xác nhận email và collection reset token.

### Middleware, Program, Service, Validator

- `RequestLoggingMiddleware.cs`
  - Che password, access token, refresh token, reset token và email confirmation token trong body/query log.
- `Program.cs`
  - Đăng ký `EmailSettings`, `IEmailService`, `IUserService`, `IHttpContextAccessor`.
- `AuthService.cs`
  - Toàn bộ logic đăng ký/xác nhận email/profile/logout/đổi mật khẩu/quên mật khẩu/reset mật khẩu.
- `IAuthService.cs`
  - Bổ sung contract cho các chức năng auth mới.
- `AuthValidators.cs`
  - Bổ sung validator cho các request mới.
- `appsettings.Development.json`
  - Thêm cấu hình SMTP nhưng để trống credential và `Enabled=false` để không commit secret.

## Backend — class/file thêm mới

- `Controllers/UsersController.cs`
- `Models/PasswordResetToken.cs`
- `Options/EmailSettings.cs`
- `Services/IEmailService.cs`
- `Services/SmtpEmailService.cs`
- `Services/IUserService.cs`
- `Services/UserService.cs`

## Flutter — class/file đã sửa

### Core

- `api_constants.dart`
  - Base URL theo platform và endpoint auth/user mới.
- `api_client.dart`
  - Sửa refresh URL từ `/api/Auth/refresh` thành `/auth/refresh` theo `baseUrl` hiện tại.
  - Reset hàng đợi refresh khi refresh không thành công.
- `api_logging_interceptor.dart`
  - Che token/password trong request, response và error log.
- `app_router.dart`
  - Gộp route Dashboard hiện có với route Auth/Profile/User Management mới.

### Auth và Admin

- `admin_home_page.dart`
  - Giữ menu thống kê, thêm quản lý user, profile và logout.
- `auth_remote_datasource.dart`
- `auth_repository_impl.dart`
- `auth_repository.dart`
- `register_usecase.dart`
- `auth_provider.dart`
- `login_page.dart`
- `register_page.dart`

### Sửa tương thích khác

- `category_remote_datasource.dart`
  - Hỗ trợ response OData `{ value: [...] }` và list thuần.
- `product_list_page.dart`
  - Thêm nút profile, vẫn giữ toàn bộ logic product/dashboard cũ.

## Flutter — class/file thêm mới

### Quản lý người dùng

- `admin_user_model.dart`
- `admin_user_remote_datasource.dart`
- `admin_user_provider.dart`
- `admin_user_list_page.dart`
- `admin_user_detail_page.dart`

### Auth/Profile

- `forgot_password_page.dart`
- `reset_password_page.dart`
- `confirm_email_page.dart`
- `profile_page.dart`
- `change_password_page.dart`

## SQL và tài liệu

- `sql/CalendarShopDB.sql`
  - Schema đầy đủ cho email confirmation/reset password và giữ dữ liệu Dashboard.
- `sql/upgrade_email_verification.sql`
  - Nâng cấp database cũ, gồm cả tạo bảng/index `PasswordResetTokens`.
- `EMAIL_SETUP_NOTE.md`
- `EMAIL_TROUBLESHOOTING_NOTE.md`

## File Dashboard được giữ nguyên

Không xóa hoặc ghi đè 18 file Dashboard Flutter đã có trên nhánh `dev`, gồm:

- `admin_statistics_page.dart`
- `admin_dashboard_provider.dart`
- `admin_dashboard_remote_datasource.dart`
- Các model/repository/use case dashboard.
- Các widget biểu đồ, tổng quan, trạng thái và best-selling.

Backend Dashboard cũng giữ nguyên `RevenueByDay`, `RevenueByMonth` và logic thống kê hiện tại.

## Thay đổi từ source feature đã chủ động không lấy

- Không lấy `.vs/`, `bin/`, `obj/`, `.dart_tool/`, `build/`, `.idea/` và file generated/local.
- Không lấy thay đổi `withOpacity` → `withValues` ở các trang product vì không liên quan tính năng và có thể làm giảm tương thích Flutter SDK.
- Không lấy bản `pubspec.lock` bị downgrade package transitive.
- Không giữ Gmail/App Password xuất hiện trong file upload. Credential đã được xóa khỏi source merge.

## Cấu hình bắt buộc sau merge

1. Nếu database đã tồn tại, chạy `sql/upgrade_email_verification.sql`.
2. Cấu hình SMTP bằng environment variables hoặc User Secrets, không commit password vào Git.
3. Chạy `dotnet build` và `flutter analyze` trên máy có .NET 8/Flutter SDK.
4. Gmail App Password từng nằm trong file upload cần được thu hồi và tạo lại trước khi sử dụng.
