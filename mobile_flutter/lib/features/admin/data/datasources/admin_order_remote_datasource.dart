import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/admin_order_model.dart';

class AdminOrderRemoteDataSource {
  final ApiClient apiClient;

  AdminOrderRemoteDataSource(this.apiClient);

  Future<List<AdminOrderModel>> getOrders({
    String? search,
    String? status,
  }) async {
    final List<String> filters = [];
    if (search != null && search.isNotEmpty) {
      final escapedSearch = search.replaceAll("'", "''").toLowerCase();
      filters.add("(contains(tolower(CustomerName), '$escapedSearch') or contains(CustomerPhone, '$escapedSearch'))");
    }
    if (status != null && status.isNotEmpty && status != 'All') {
      filters.add("Status eq '$status'");
    }

    final String? filterQuery = filters.isNotEmpty ? filters.join(' and ') : null;

    final response = await apiClient.dio.get('${ApiConstants.orders}/admin', queryParameters: {
      if (filterQuery != null) '\$filter': filterQuery,
      '\$orderby': 'CreatedAt desc',
    });

    final List dataList;
    if (response.data is Map && (response.data as Map).containsKey('value')) {
      dataList = response.data['value'] as List;
    } else if (response.data is List) {
      dataList = response.data as List;
    } else {
      dataList = [];
    }

    return dataList.map((e) => AdminOrderModel.fromJson(e)).toList();
  }

  Future<void> updateOrderStatus(int id, String status, {String? note}) async {
    await apiClient.dio.put('${ApiConstants.orders}/admin/$id/status', data: {
      'status': status,
      'note': note,
    });
  }
}
