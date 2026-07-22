import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/order_model.dart';
import '../models/create_order_request.dart';

/// Lớp chịu trách nhiệm gọi các API thô liên quan đến đơn hàng từ Server.
class OrderRemoteDataSource {
  final ApiClient apiClient;

  OrderRemoteDataSource(this.apiClient);

  /// Lấy danh sách đơn hàng của người dùng hiện tại (API dạng OData)
  Future<List<OrderModel>> getMyOrders() async {
    try {
      final response = await apiClient.dio.get('${ApiConstants.orders}/mine');

      // Vì OData bọc danh sách trong thuộc tính "value", ta cần bóc tách dữ liệu
      final List dataList;
      if (response.data is Map && (response.data as Map).containsKey('value')) {
        dataList = response.data['value'] as List;
      } else if (response.data is List) {
        dataList = response.data as List;
      } else {
        dataList = [];
      }

      return dataList.map((e) => OrderModel.fromJson(e)).toList();
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  /// Lấy chi tiết một đơn hàng theo ID
  Future<OrderModel> getOrderById(int id) async {
    try {
      final response = await apiClient.dio.get('${ApiConstants.orders}/$id');
      return OrderModel.fromJson(response.data);
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  /// Hủy đơn hàng đang ở trạng thái Pending
  Future<void> cancelOrder(int id, String? reason) async {
    try {
      await apiClient.dio.put('${ApiConstants.orders}/$id/cancel', data: {
        'reason': reason,
      });
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  /// Tạo một đơn hàng mới
  Future<OrderModel> createOrder(CreateOrderRequest request) async {
    try {
      final response = await apiClient.dio.post(ApiConstants.orders, data: request.toJson());
      return OrderModel.fromJson(response.data);
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  /// Lấy VNPay Payment URL
  Future<String> getVNPayUrl(int orderId) async {
    try {
      final response = await apiClient.dio.get('/payment/vnpay/$orderId');
      return response.data['url'] as String;
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  /// Mua lại đơn hàng
  Future<void> reorder(int orderId) async {
    try {
      await apiClient.dio.post('${ApiConstants.orders}/$orderId/reorder');
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }
}
