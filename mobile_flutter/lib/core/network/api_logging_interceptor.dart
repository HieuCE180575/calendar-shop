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
      final responseString = jsonEncode(response.data);
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
      errDataStr = '\nError Data: ${jsonEncode(err.response?.data)}';
    }

    _logger.e(
      '<-- ERROR ${err.response?.statusCode ?? 'No Code'} ${err.requestOptions.method.toUpperCase()} ${err.requestOptions.uri}\nMessage: ${err.message}$errDataStr',
    );
    super.onError(err, handler);
  }

  Map<String, dynamic> _maskSensitiveData(Map<String, dynamic> data) {
    final copy = Map<String, dynamic>.from(data);
    final sensitiveKeys = ['password', 'oldPassword', 'newPassword'];
    
    for (var key in copy.keys) {
      if (sensitiveKeys.contains(key.toLowerCase())) {
        copy[key] = '***';
      } else if (copy[key] is Map<String, dynamic>) {
        copy[key] = _maskSensitiveData(copy[key] as Map<String, dynamic>);
      }
    }
    return copy;
  }
}
