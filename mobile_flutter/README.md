# Flutter Client App - Calendar Shop Mobile

Dự án ứng dụng di động dành cho khách hàng được xây dựng bằng **Flutter (Dart)**. Mã nguồn được tổ chức theo kiến trúc sạch **Clean Architecture** phân lớp theo từng tính năng (Feature-based), giúp hệ thống dễ bảo trì, mở rộng và viết Unit Test độc lập.

---

## 🛠️ Yêu Cầu Hệ Thống

Đảm bảo bạn đã cài đặt các công cụ sau:

1.  **Flutter SDK** (Phiên bản `>= 3.4.0 < 4.0.0`).
2.  **Android Studio** hoặc **Visual Studio Code** đã cài đặt plugin Dart & Flutter.
3.  **Android Emulator** (Máy ảo) hoặc thiết bị Android thật để chạy và test ứng dụng.

---

## ⚙️ Các Lệnh Khởi Chạy Quan Trọng

Sau khi mở thư mục `mobile_flutter` bằng IDE của bạn, hãy mở terminal và thực hiện các lệnh sau:

### 1. Cài đặt các gói thư viện

Tải toàn bộ các package cần thiết đã khai báo trong `pubspec.yaml`:

```bash
flutter pub get
```

### 2. Sinh mã nguồn tự động (Freezed & JSON)

Vì dự án sử dụng bộ sinh code Freezed cho các class Immutable Model/Entity, bạn bắt buộc phải chạy lệnh này trước để tạo ra các file `.freezed.dart` và `.g.dart`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

_(Nếu muốn tự động cập nhật code mỗi khi lưu file mà không cần gõ lại lệnh, dùng `watch` thay cho `build`)_

### 3. Chạy ứng dụng trên thiết bị

Khởi động máy ảo hoặc kết nối thiết bị thật, sau đó thực thi lệnh:

```bash
flutter run
```

### 4. Kiểm tra chất lượng Code (Static Linter)

Chạy bộ phân tích tĩnh đảm bảo code sạch, không có lỗi hoặc cảnh báo viết sai chuẩn:

```bash
flutter analyze
```

---

## 🌐 Cấu Hình Địa Chỉ API (Base URL)

Địa chỉ kết nối đến Backend API được cấu hình tập trung tại file:
👉 [api_constants.dart](file:///e:/D/study/HK8/PRM393/.FinalProject/calendar-shop/mobile_flutter/lib/core/constants/api_constants.dart)

- **Android Emulator:** Cổng mặc định là `http://10.0.2.2:5000/api` hoặc cổng của IIS/Kestrel cụ thể (ví dụ: `http://10.0.2.2:52441/api`).
- **Thiết bị Android thật / iOS Simulators:** Bạn phải đổi `10.0.2.2` thành địa chỉ IP cục bộ máy tính của bạn (Ví dụ: `http://192.168.1.15:52441/api`), và đảm bảo điện thoại kết nối cùng mạng WiFi với máy tính chạy server backend.

---

## 📂 Tổng Quan Kiến Trúc Từng Feature

Mỗi tính năng trong thư mục `lib/features/` (ví dụ `product`, `auth`, `cart`) được phân chia thành 3 lớp riêng biệt:

1.  **Domain Layer (Lõi nghiệp vụ):**
    - `entities/`: Các lớp thực thể sạch (Freezed Class).
    - `repositories/`: Định nghĩa interface giao tiếp dữ liệu.
2.  **Data Layer (Triển khai lấy dữ liệu):**
    - `models/`: Các DTO Model hỗ trợ parse JSON từ API (`freezed` + `json_serializable`).
    - `datasources/`: Gọi trực tiếp REST API qua Dio.
    - `repositories/`: Cụ thể hóa interface lớp Domain, ánh xạ DTO sang Entity qua hàm `.toEntity()`.
3.  **Presentation Layer (Giao diện hiển thị):**
    - `pages/`: Chứa các màn hình hiển thị (UI Screen).
    - `providers/`: Quản lý trạng thái và tiêm phụ thuộc (Dependency Injection) bằng Riverpod.
