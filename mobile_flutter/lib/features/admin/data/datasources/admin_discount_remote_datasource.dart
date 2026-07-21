import '../../../../core/network/api_client.dart';
import '../models/admin_discount_model.dart';

class AdminDiscountRemoteDataSource {
  final ApiClient apiClient;

  AdminDiscountRemoteDataSource(this.apiClient);

  Future<({List<AdminDiscountModel> items, int totalCount})> getDiscounts({
    String? searchQuery,
    int page = 1,
    int pageSize = 10,
    String? filterStatus,
    DateTime? filterStartDate,
    DateTime? filterEndDate,
    String? sortByDiscountValue,
  }) async {
    List<String> queryParams = [];
    queryParams.add('\$count=true');
    queryParams.add('\$skip=${(page - 1) * pageSize}');
    queryParams.add('\$top=$pageSize');
    
    List<String> filterConditions = [];
    if (searchQuery != null && searchQuery.isNotEmpty) {
      filterConditions.add('contains(tolower(Name), \'${searchQuery.toLowerCase()}\')');
    }
    if (filterStatus != null && filterStatus != 'All') {
      filterConditions.add('Status eq \'$filterStatus\'');
    }
    if (filterStartDate != null) {
      filterConditions.add('StartDate ge ${filterStartDate.toUtc().toIso8601String()}');
    }
    if (filterEndDate != null) {
      filterConditions.add('EndDate le ${filterEndDate.toUtc().toIso8601String()}');
    }

    if (filterConditions.isNotEmpty) {
      queryParams.add('\$filter=${filterConditions.join(' and ')}');
    }

    List<String> orderBys = [];
    if (sortByDiscountValue != null && sortByDiscountValue.isNotEmpty) orderBys.add('DiscountValue $sortByDiscountValue');
    
    if (orderBys.isNotEmpty) {
      queryParams.add('\$orderby=${orderBys.join(', ')}');
    }

    final url = '/discounts?${queryParams.join('&')}';
    final response = await apiClient.dio.get(url);
    
    final List data;
    int totalCount = 0;
    
    if (response.data is Map) {
      final mapData = response.data as Map;
      if (mapData.containsKey('value')) {
        data = mapData['value'] as List;
      } else {
        data = [];
      }
      if (mapData.containsKey('@odata.count')) {
        totalCount = mapData['@odata.count'] as int;
      }
    } else if (response.data is List) {
      data = response.data as List;
      totalCount = data.length;
    } else {
      data = [];
    }
    
    final items = data.map((e) => AdminDiscountModel.fromJson(e)).toList();
    return (items: items, totalCount: totalCount);
  }

  Future<AdminDiscountModel> getDiscountById(int id) async {
    final response = await apiClient.dio.get('/discounts/$id');
    return AdminDiscountModel.fromJson(response.data);
  }

  Future<AdminDiscountModel> createDiscount(Map<String, dynamic> data) async {
    final response = await apiClient.dio.post('/discounts', data: data);
    return AdminDiscountModel.fromJson(response.data);
  }

  Future<void> updateDiscount(int id, Map<String, dynamic> data) async {
    await apiClient.dio.put('/discounts/$id', data: data);
  }

  Future<void> deleteDiscount(int id) async {
    await apiClient.dio.delete('/discounts/$id');
  }

  Future<void> updateDiscountStatus(int id, String status) async {
    await apiClient.dio.put('/discounts/$id/status', data: {'status': status});
  }
}
