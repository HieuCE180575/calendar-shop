# Calendar Shop Mobile

Flutter app theo Clean Architecture, dùng trong Android Studio.

## Chạy app

```bash
flutter create .
flutter pub get
flutter run
```

## Đổi API URL

Mở file:

```text
lib/core/constants/api_constants.dart
```

Android Emulator:

```dart
static const String baseUrl = 'http://10.0.2.2:5000/api';
```

Điện thoại thật:

```dart
static const String baseUrl = 'http://<IP-MAY-TINH>:5000/api';
```

## Clean Architecture

Mỗi feature chia thành:

```text
feature/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── pages/
    ├── providers/
    └── widgets/
```
