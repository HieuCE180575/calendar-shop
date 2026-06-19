import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../errors/app_exception.dart';
import '../storage/token_storage.dart';
import 'api_logging_interceptor.dart';

class ApiClient {
  final Dio dio;
  final TokenStorage tokenStorage;

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
        onError: (error, handler) {
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
      if (data is Map && data['message'] != null)
        return AppException(data['message'].toString());
      return AppException(error.message ?? 'Có lỗi kết nối API');
    }
    return AppException(error.toString());
  }
}
