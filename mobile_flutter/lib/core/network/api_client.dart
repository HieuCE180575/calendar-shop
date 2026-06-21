import 'dart:async';
import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../errors/app_exception.dart';
import '../storage/token_storage.dart';
import 'api_logging_interceptor.dart';

class ApiClient {
  final Dio dio;
  final TokenStorage tokenStorage;
  bool _isRefreshing = false;
  final List<Completer<String?>> _refreshCompleters = [];

  ApiClient({required this.tokenStorage})
    : dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await tokenStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final options = error.requestOptions;

            if (_isRefreshing) {
              final completer = Completer<String?>();
              _refreshCompleters.add(completer);
              try {
                final newToken = await completer.future;
                if (newToken != null) {
                  options.headers['Authorization'] = 'Bearer $newToken';
                  final response = await dio.fetch(options);
                  return handler.resolve(response);
                }
              } catch (_) {}
              return handler.next(error);
            }

            _isRefreshing = true;
            final completer = Completer<String?>();
            _refreshCompleters.add(completer);

            try {
              final oldToken = await tokenStorage.getToken();
              final refreshToken = await tokenStorage.getRefreshToken();

              if (refreshToken != null && oldToken != null) {
                final refreshDio = Dio(
                  BaseOptions(
                    baseUrl: ApiConstants.baseUrl,
                    headers: {'Content-Type': 'application/json'},
                  ),
                );
                
                final response = await refreshDio.post(
                  '/api/Auth/refresh',
                  data: {
                    'token': oldToken,
                    'refreshToken': refreshToken,
                  },
                );

                if (response.statusCode == 200 && response.data != null) {
                  final data = response.data;
                  final newToken = data['token'] as String;
                  final newRefreshToken = data['refreshToken'] as String;

                  await tokenStorage.saveToken(newToken);
                  await tokenStorage.saveRefreshToken(newRefreshToken);

                  for (var c in _refreshCompleters) {
                    c.complete(newToken);
                  }
                  _refreshCompleters.clear();
                  _isRefreshing = false;

                  options.headers['Authorization'] = 'Bearer $newToken';
                  final retryResponse = await dio.fetch(options);
                  return handler.resolve(retryResponse);
                }
              }
            } catch (e) {
              for (var c in _refreshCompleters) {
                c.complete(null);
              }
              _refreshCompleters.clear();
              _isRefreshing = false;

              await tokenStorage.clearTokens();
              return handler.next(error);
            }
          }
          handler.next(error);
        },
      ),
    );
    dio.interceptors.add(ApiLoggingInterceptor());
  }

  AppException handleError(Object error) {
    if (error is DioException) {
      final data = error.response?.data;

      if (data is String) return AppException(data);

      if (data is Map) {
        // 1. Validation errors (ValidationProblemDetails)
        if (data['errors'] != null && data['errors'] is Map) {
          final errorsMap = data['errors'] as Map;
          final errorMessages = <String>[];
          for (var value in errorsMap.values) {
            if (value is List) {
              errorMessages.addAll(value.map((e) => e.toString()));
            } else {
              errorMessages.add(value.toString());
            }
          }
          if (errorMessages.isNotEmpty) {
            return AppException(errorMessages.join('\n'));
          }
        }

        // 2. Specific domain/business exception details
        if (data['detail'] != null) {
          return AppException(data['detail'].toString());
        }

        // 3. General error title
        if (data['title'] != null) {
          return AppException(data['title'].toString());
        }
      }

      return AppException(error.message ?? 'Có lỗi kết nối API');
    }
    return AppException(error.toString());
  }
}
