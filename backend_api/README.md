# ASP.NET Core Web API - Calendar Shop Backend

Mã nguồn dịch vụ Backend được xây dựng bằng **ASP.NET Core Web API (.NET 8)**, sử dụng **Entity Framework Core** để giao tiếp với SQL Server Database. Dự án áp dụng mô hình kiến trúc phân lớp Enterprise (Controllers -> Services -> Repositories -> DB Context) cùng các cơ chế bảo mật JWT và truy vấn linh hoạt OData.

---

## 🛠️ Yêu Cầu Hệ Thống

Để chạy được dự án này, máy tính của bạn cần được cài đặt sẵn:
1.  **SDK .NET 8.0** hoặc phiên bản mới hơn.
2.  **Microsoft SQL Server** (LocalDB hoặc SQL Express).
3.  **Visual Studio 2022** (có cài workload `.NET desktop development` & `ASP.NET and web development`) hoặc **VS Code** (cài C# Extension).

---

## ⚙️ Cấu Hình Ban Đầu & Khởi Động

### Bước 1: Khởi tạo Cơ sở dữ liệu
1.  Mở file script SQL [CalendarShopDB.sql](file:///e:/D/study/HK8/PRM393/.FinalProject/calendar-shop/sql/CalendarShopDB.sql) bằng **SSMS** hoặc công cụ quản trị SQL Server.
2.  Chạy script để tạo database `CalendarShopDB` cùng các bảng và dữ liệu thử nghiệm.

### Bước 2: Cấu hình Connection String
Mở file [appsettings.Development.json](file:///e:/D/study/HK8/PRM393/.FinalProject/calendar-shop/backend_api/CalendarShop.Api/appsettings.Development.json) và chỉnh sửa thông tin kết nối SQL Server cho phù hợp với máy của bạn.
*   **Ví dụ sử dụng xác thực Windows (Windows Authentication):**
    ```json
    "ConnectionStrings": {
      "DefaultConnection": "Server=localhost;Database=CalendarShopDB;Trusted_Connection=True;TrustServerCertificate=True"
    }
    ```
*   **Ví dụ sử dụng tài khoản SQL Server (SQL Server Authentication):**
    ```json
    "ConnectionStrings": {
      "DefaultConnection": "Server=localhost;Database=CalendarShopDB;User Id=sa;Password=your_password;TrustServerCertificate=True"
    }
    ```

### Bước 3: Khởi chạy API qua Terminal
Mở terminal và di chuyển vào thư mục API dự án:
```bash
cd backend_api/CalendarShop.Api
dotnet restore
dotnet run
```
Sau khi chạy thành công, console sẽ hiển thị cổng kết nối (Port) mà API đang lắng nghe (Ví dụ: `http://localhost:52441` và `https://localhost:52440`).

---

## 🧪 Kiểm Thử API & Xác Thực JWT bằng Swagger

### 1. Truy cập Swagger UI
Mở trình duyệt và truy cập:
👉 [http://localhost:52441/swagger](http://localhost:52441/swagger) (Thay thế cổng `52441` bằng cổng hiển thị trên console của bạn).

### 2. Thực hiện Đăng nhập lấy Token
1.  Tìm đến API `/api/Auth/login` (POST).
2.  Nhấp vào **Try it out** và truyền dữ liệu đăng nhập:
    *   **Admin:** `{"login": "admin@calendarshop.com", "password": "123456"}`
    *   **Customer:** `{"login": "customer@gmail.com", "password": "123456"}`
3.  Thực thi (Execute), copy chuỗi mã JWT Token trả về trong Response Body (ở trường `"token"`).

### 3. Cấu hình Authenticate
1.  Cuộn lên đầu trang Swagger UI, nhấp vào nút **Authorize** màu xanh lá.
2.  Dán trực tiếp chuỗi Token bạn vừa copy vào ô nhập liệu (Không cần gõ thêm chữ `"Bearer "`).
3.  Nhấp vào **Authorize** để xác thực thành công. Bây giờ bạn có thể test toàn bộ các API yêu cầu quyền Admin hoặc Customer.

---

## 🏗️ Cấu Trúc Mã Nguồn Backend

Mã nguồn được cấu trúc theo phân lớp rõ ràng:
*   **Controllers:** Chỉ chứa các Endpoint giao tiếp HTTP, kiểm tra phân quyền và điều hướng dữ liệu. Mọi API truy vấn dạng danh sách đều dùng `[EnableQuery]` để bật OData.
*   **Services:** Chứa 100% logic nghiệp vụ (business logic) của dự án. Không trực tiếp xử lý HTTP status code mà bắn Exception khi gặp lỗi.
*   **Repositories:** Triển khai các lớp `IRepository<T>` phục vụ việc truy xuất dữ liệu độc lập từ Database (ngăn cấm tiêm `AppDbContext` trực tiếp vào lớp `Services`).
*   **Data / DbContext:** Cấu hình EF Core Entities và quan hệ bảng.
*   **Mappings (AutoMapper Profiles):** Chứa các cấu hình ánh xạ giữa thực thể Entity trong DB và các DTO chuyển tải dữ liệu.
*   **Validators (FluentValidation):** Tự động bắt lỗi các Request Body gửi lên trước khi chuyển giao vào Controller.
*   **Middlewares / Global Exception Handler:** Bắt lỗi runtime tập trung và xuất ra định dạng lỗi chuẩn RFC 7807 ProblemDetails.
