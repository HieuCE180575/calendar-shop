import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('\n=== [API REQUEST] ===');
    debugPrint('--> ${options.method.toUpperCase()} ${options.uri}');

    // Log, hide the sensitive Headers
    final headers = Map<String, dynamic>.from(options.headers);
    if (headers.containsKey('Authorization')) {
      headers['Authorization'] = 'Bearer [MASKED_TOKEN]';
    }
    debugPrint('Headers: $headers');

      // Log, filter out the Body
    if (options.data != null) {
      if (options.data is Map<String, dynamic>) {
        final maskedData = _maskSensitiveData(options.data as Map<String, dynamic>);
        debugPrint('Body: ${jsonEncode((maskedData))}');
      } else {
        debugPrint('Body: ${options.data}');
      }
    }
    debugPrint('=====================\n');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('\n=== [API RESPONSE] ===');
    debugPrint('<-- ${response.statusCode} ${response.requestOptions.method.toUpperCase()} ${response.requestOptions.uri}');

    // If big data then summary
    if (response.data != null) {
      final responseString = jsonEncode(response.data);
      if (responseString.length > 500) {
        debugPrint('Data (Trimmed): ${responseString.substring(0, 500)}...');
      } else {
        debugPrint('Data: $responseString');
      }
    }
    debugPrint('======================\n');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('\n=== [API ERROR] ===');
    debugPrint('<-- ERROR ${err.response?.statusCode ?? 'No Code'} ${err.requestOptions.method.toUpperCase()} ${err.requestOptions.uri}');
    debugPrint('Message: ${err.message}');
    if (err.response?.data != null) {
      debugPrint('Error Data: ${jsonEncode(err.response?.data)}');
    }
    debugPrint('====================\n');
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
