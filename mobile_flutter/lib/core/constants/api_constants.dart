import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConstants {
  // Dynamically resolve localhost depending on the platform/environment:
  // - iOS Simulator / Web: localhost
  // - Android Emulator: 10.0.2.2 (special loopback to host localhost)
  // - Real Device (LAN): Replace with host computer's local Wi-Fi IP (e.g., 'http://192.168.1.100:52441/api')
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:51441/api';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:51441/api';
    }
    return 'http://localhost:51441/api';
  }

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String me = '/auth/me';
  static const String products = '/products';
  static const String categories = '/categories';
  static const String cart = '/cart';
  static const String orders = '/orders';
}
