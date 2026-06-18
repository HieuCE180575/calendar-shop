# Calendar Shop - PRM393 Mobile App

Bộ source starter cho đề tài **Mobile App Bán Lịch Online**.

Project được chia thành 3 phần:

```text
calendar_shop_starter/
├── mobile_flutter/       # Flutter app mở bằng Android Studio
├── backend_api/          # ASP.NET Core Web API kết nối SQL Server
└── sql/                  # Script tạo database SQL Server
```

## Kiến trúc tổng quát

Mobile app không kết nối trực tiếp SQL Server. Luồng đúng là:

```text
Flutter Mobile App  --->  ASP.NET Core Web API  --->  SQL Server
```

Lý do: bảo mật tài khoản DB, dễ phân quyền, dễ validate dữ liệu, dễ deploy cho nhiều máy.

## Công nghệ

- Mobile: Flutter / Dart
- State management: Riverpod
- HTTP client: Dio
- Backend: ASP.NET Core Web API
- Database: SQL Server
- Auth: JWT token
- Architecture mobile: Clean Architecture theo từng feature

## Cách chạy database

1. Mở SQL Server Management Studio.
2. Chạy file:

```text
sql/CalendarShopDB.sql
```

Database mặc định: `CalendarShopDB`.

## Cách chạy backend

Mở thư mục:

```text
backend_api/CalendarShop.Api
```

Sửa connection string trong file:

```text
appsettings.Development.json
```

Ví dụ:

```json
"ConnectionStrings": {
  "DefaultConnection": "Server=localhost;Database=CalendarShopDB;Trusted_Connection=True;TrustServerCertificate=True"
}
```

Chạy backend:

```bash
dotnet restore
dotnet run
```

API mặc định có thể chạy ở:

```text
http://localhost:5000
```

Swagger:

```text
http://localhost:5000/swagger
```

## Cách chạy Flutter trong Android Studio

Mở thư mục:

```text
mobile_flutter
```

Nếu thư mục chưa có platform Android, chạy:

```bash
flutter create .
flutter pub get
flutter run
```

Khi chạy Android Emulator, base URL đã để sẵn:

```dart
http://10.0.2.2:5000/api
```

Nếu chạy bằng điện thoại thật, đổi `baseUrl` trong:

```text
mobile_flutter/lib/core/constants/api_constants.dart
```

thành IP máy tính của bạn, ví dụ:

```dart
http://192.168.1.10:5000/api
```

## Tài khoản seed mẫu

```text
Admin:
email: admin@calendarshop.com
password: 123456

Customer:
email: customer@gmail.com
password: 123456
```

Mật khẩu trong SQL đang hash theo SHA256 để tiện demo. Khi làm thật nên dùng BCrypt/ASP.NET Identity.

## Git cho nhóm

Sau khi giải nén source, bạn tạo repo và đẩy lên GitHub:

```bash
git init
git add .
git commit -m "Init Calendar Shop clean architecture starter"
git branch -M main
git remote add origin https://github.com/<your-team>/calendar-shop-prm393.git
git push -u origin main
```

## Chia branch cho từng người

```bash
git checkout -b feature/auth-profile
git checkout -b feature/product-category
git checkout -b feature/cart-order
git checkout -b feature/favorite-review
git checkout -b feature/admin-management
git checkout -b feature/coupon-dashboard
```

## Quy tắc làm việc nhóm

1. Mỗi người làm trên branch riêng.
2. Không commit trực tiếp vào `main`.
3. Tạo Pull Request để merge.
4. Khi lấy code mới:

```bash
git checkout main
git pull origin main
git checkout feature/ten-chuc-nang
git merge main
```

## Phạm vi code có sẵn

Starter này đã có:

- SQL Server database schema
- ASP.NET Core API structure
- Model, DbContext, Controller cơ bản
- JWT Auth flow
- Flutter Clean Architecture folder
- Login/Register screen
- Product list screen
- Cart/Order/Admin skeleton

Nhóm bạn tiếp tục đầy đủ từng màn hình, validation, UI, API detail và business rule.
