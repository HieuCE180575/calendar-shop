import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(baseUrl: 'http://localhost:51441/api'));
  try {
    final response = await dio.get('/api/coupons/stats');
    print('Success: ${response.statusCode}');
  } catch (e) {
    if (e is DioException) {
      print('URL requested: ${e.requestOptions.uri}');
      print('Status: ${e.response?.statusCode}');
    }
  }
}
