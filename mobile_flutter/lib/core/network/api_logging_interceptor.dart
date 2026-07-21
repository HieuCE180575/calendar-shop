import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ApiLoggingInterceptor extends Interceptor {
  final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.none,
    ),
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Log, hide the sensitive Headers
    final headers = Map<String, dynamic>.from(options.headers);
    if (headers.containsKey('Authorization')) {
      headers['Authorization'] = 'Bearer [MASKED_TOKEN]';
    }

    String bodyStr = '';
    if (options.data != null) {
      if (options.data is Map<String, dynamic>) {
        final maskedData = _maskSensitiveData(options.data as Map<String, dynamic>);
        bodyStr = '\nBody: ${jsonEncode(maskedData)}';
      } else {
        bodyStr = '\nBody: ${options.data}';
      }
    }

    _logger.i('--> ${options.method.toUpperCase()} ${options.uri}\nHeaders: $headers$bodyStr');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    String dataStr = '';
    if (response.data != null) {
      final responseString = jsonEncode(_maskSensitiveValue(response.data));
      if (responseString.length > 500) {
        dataStr = '\nData (Trimmed): ${responseString.substring(0, 500)}...';
      } else {
        dataStr = '\nData: $responseString';
      }
    }

    _logger.d('<-- ${response.statusCode} ${response.requestOptions.method.toUpperCase()} ${response.requestOptions.uri}$dataStr');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errDataStr = '';
    if (err.response?.data != null) {
      errDataStr = '\nError Data: ${jsonEncode(_maskSensitiveValue(err.response?.data))}';
    }

    _logger.e(
      '<-- ERROR ${err.response?.statusCode ?? 'No Code'} ${err.requestOptions.method.toUpperCase()} ${err.requestOptions.uri}\nMessage: ${err.message}$errDataStr',
    );
    super.onError(err, handler);
  }

  Map<String, dynamic> _maskSensitiveData(Map<String, dynamic> data) {
    return Map<String, dynamic>.fromEntries(
      data.entries.map((entry) => MapEntry(entry.key, _isSensitiveKey(entry.key) ? '***' : _maskSensitiveValue(entry.value))),
    );
  }

  dynamic _maskSensitiveValue(dynamic value) {
    if (value is Map) {
      return value.map((key, item) {
        final keyText = key.toString();
        return MapEntry(key, _isSensitiveKey(keyText) ? '***' : _maskSensitiveValue(item));
      });
    }
    if (value is List) {
      return value.map(_maskSensitiveValue).toList();
    }
    return value;
  }

  bool _isSensitiveKey(String key) {
    const sensitiveKeys = {
      'password',
      'oldpassword',
      'newpassword',
      'token',
      'accesstoken',
      'refreshtoken',
      'resettoken',
      'emailconfirmationtoken',
    };
    return sensitiveKeys.contains(key.toLowerCase());
  }
}
