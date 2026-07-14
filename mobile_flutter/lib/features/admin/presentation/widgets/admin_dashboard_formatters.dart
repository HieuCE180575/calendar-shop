import 'package:intl/intl.dart';

class AdminDashboardFormatters {
  AdminDashboardFormatters._();

  static final currency = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'd',
    decimalDigits: 0,
  );

  static final number = NumberFormat('#,###', 'vi_VN');

  static String compactRevenue(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }
}
