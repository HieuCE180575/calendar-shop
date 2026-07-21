import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/order_model.dart';

class OrderRemoteDataSource {
  final ApiClient apiClient;

  OrderRemoteDataSource(this.apiClient);

  Future<List<OrderModel>> getMyOrders() async {
    final response = await apiClient.dio.get(
      '${ApiConstants.orders}/mine',
      queryParameters: {'\$orderby': 'CreatedAt desc'},
    );

    final List dataList;
    if (response.data is Map && (response.data as Map).containsKey('value')) {
      dataList = response.data['value'] as List;
    } else if (response.data is List) {
      dataList = response.data as List;
    } else {
      dataList = [];
    }

    return dataList.map((e) => OrderModel.fromJson(e)).toList();
  }

  Future<void> reorder(int orderId) async {
    await apiClient.dio.post('${ApiConstants.orders}/$orderId/reorder');
  }
}
