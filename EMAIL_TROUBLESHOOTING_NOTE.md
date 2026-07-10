# Fix gửi email SMTP Gmail

> **Bảo mật:** Không commit Gmail App Password vào Git. Hãy dùng .NET User Secrets hoặc biến môi trường như `Email__Enabled`, `Email__UserName`, `Email__Password`, `Email__FromEmail`. Nếu một App Password đã từng xuất hiện trong file ZIP/source, hãy thu hồi và tạo lại.


Bản này đã sửa `SmtpEmailService` để:

- Tự bỏ dấu cách trong Gmail App Password.
- Log cấu hình email lúc backend start: `Email SMTP config loaded...`
- Log khi bắt đầu gửi mail và khi gửi thành công.
- Nếu Gmail/SMTP lỗi, console backend sẽ hiện rõ lỗi SMTP.

## Cấu hình bắt buộc

Mở file:

```text
backend_api/CalendarShop.Api/appsettings.Development.json
```

Sửa phần `Email`:

```json
"Email": {
  "Enabled": true,
  "Host": "smtp.gmail.com",
  "Port": 587,
  "EnableSsl": true,
  "UserName": "gmail-admin-cua-ban@gmail.com",
  "Password": "app-password-16-ky-tu",
  "FromEmail": "gmail-admin-cua-ban@gmail.com",
  "FromName": "Calendar Shop Admin",
  "ApiBaseUrl": "http://localhost:51441",
  "AppBaseUrl": "http://localhost:3000"
}
```

`UserName` và `FromEmail` nên là cùng một Gmail. `Password` là Gmail App Password, không phải mật khẩu đăng nhập Gmail.

## Chạy lại backend

```powershell
taskkill /IM CalendarShop.Api.exe /F
cd backend_api\CalendarShop.Api
dotnet clean
dotnet build
dotnet run --urls "http://localhost:51441"
```

Khi backend chạy, console phải có dòng:

```text
Email SMTP config loaded. Environment=Development, Enabled=True
```

Nếu vẫn là `Enabled=False` thì bạn đang sửa nhầm file hoặc còn backend cũ đang chạy.

Khi đăng ký tài khoản, nếu gửi thành công sẽ có dòng:

```text
SMTP email sent successfully
```
