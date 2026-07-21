# Email confirmation + forgot password setup

> **Bảo mật:** Không commit Gmail App Password vào Git. Hãy dùng .NET User Secrets hoặc biến môi trường như `Email__Enabled`, `Email__UserName`, `Email__Password`, `Email__FromEmail`. Nếu một App Password đã từng xuất hiện trong file ZIP/source, hãy thu hồi và tạo lại.


Đã bổ sung backend SMTP để dùng 1 email admin gửi mail cho user.

## API mới/cập nhật

- `POST /api/auth/register`
  - Tạo user trạng thái `Pending`
  - Gửi email xác nhận tài khoản
  - Không tự login cho tới khi user xác nhận email

- `GET /api/auth/confirm-email?token=...`
  - Link trong email kích hoạt tài khoản trực tiếp trên trình duyệt

- `POST /api/auth/confirm-email`
  - Body: `{ "token": "..." }`
  - Cho Flutter nhập token xác nhận thủ công

- `POST /api/auth/resend-email-confirmation`
  - Body: `{ "email": "user@example.com" }`
  - Gửi lại email kích hoạt

- `POST /api/auth/forgot-password`
  - Gửi reset token về email của tài khoản
  - Không trả token trong response nữa

- `POST /api/auth/reset-password`
  - Body: `{ "resetToken": "...", "newPassword": "..." }`

## File backend đã thêm/sửa chính

- `Models/User.cs`
- `Dtos/AuthDtos.cs`
- `Controllers/AuthController.cs`
- `Services/IAuthService.cs`
- `Services/AuthService.cs`
- `Services/IEmailService.cs`
- `Services/SmtpEmailService.cs`
- `Options/EmailSettings.cs`
- `Data/AppDbContext.cs`
- `Program.cs`
- `Validators/AuthValidators.cs`
- `Services/UserService.cs`
- `appsettings.Development.json`
- `sql/CalendarShopDB.sql`
- `sql/upgrade_email_verification.sql`

## File Flutter đã thêm/sửa chính

- `lib/core/constants/api_constants.dart`
- `lib/core/routes/app_router.dart`
- `lib/features/auth/data/datasources/auth_remote_datasource.dart`
- `lib/features/auth/data/repositories/auth_repository_impl.dart`
- `lib/features/auth/domain/repositories/auth_repository.dart`
- `lib/features/auth/domain/usecases/register_usecase.dart`
- `lib/features/auth/presentation/providers/auth_provider.dart`
- `lib/features/auth/presentation/pages/register_page.dart`
- `lib/features/auth/presentation/pages/login_page.dart`
- `lib/features/auth/presentation/pages/forgot_password_page.dart`
- `lib/features/auth/presentation/pages/reset_password_page.dart`
- `lib/features/auth/presentation/pages/confirm_email_page.dart`
- `lib/features/admin/data/models/admin_user_model.dart`
- `lib/features/admin/presentation/pages/admin_user_list_page.dart`
- `lib/features/admin/presentation/pages/admin_user_detail_page.dart`

## Cấu hình SMTP

Mở `backend_api/CalendarShop.Api/appsettings.Development.json` và sửa phần:

```json
"Email": {
  "Enabled": true,
  "Host": "smtp.gmail.com",
  "Port": 587,
  "EnableSsl": true,
  "UserName": "admin-calendar-shop@gmail.com",
  "Password": "APP_PASSWORD_CUA_EMAIL_ADMIN",
  "FromEmail": "admin-calendar-shop@gmail.com",
  "FromName": "Calendar Shop Admin",
  "ApiBaseUrl": "http://localhost:51441",
  "AppBaseUrl": "http://localhost:3000"
}
```

Với Gmail, không dùng mật khẩu đăng nhập Gmail thường. Hãy bật xác minh 2 bước và tạo App Password.

## Cập nhật database đang có

Nếu bạn đã có database cũ, chạy script này trong SQL Server Management Studio:

```sql
sql/upgrade_email_verification.sql
```

Nếu tạo lại database từ đầu thì chạy:

```sql
sql/CalendarShopDB.sql
```

## Luồng test

1. Chạy backend.
2. Đăng ký tài khoản mới bằng email thật.
3. Check email, bấm link xác nhận.
4. Login lại bằng email hoặc số điện thoại.
5. Test quên mật khẩu: nhập email/số điện thoại, check email lấy reset token, nhập token ở màn hình đặt lại mật khẩu.

Nếu `Email.Enabled = false`, backend sẽ không gửi mail thật mà log nội dung email ra console để test local.
