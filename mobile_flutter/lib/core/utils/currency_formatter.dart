import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final _formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  static String vnd(num value) => _formatter.format(value);
}
