import 'package:dio/dio.dart';
import '../../domain/entities/admin_discount.dart';
import '../../domain/repositories/admin_discount_repository.dart';
import '../models/admin_discount_model.dart';

class AdminDiscountRepositoryImpl implements AdminDiscountRepository {
  final Dio _dio;

  AdminDiscountRepositoryImpl(this._dio);

  @override
  Future<({List<AdminDiscount> items, int totalCount})> getDiscounts({
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
    final response = await _dio.get(url);
    
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
    
    final items = data.map((e) => AdminDiscountModel.fromJson(e).toEntity()).toList();
    return (items: items, totalCount: totalCount);
  }

  @override
  Future<AdminDiscount> getDiscountById(int id) async {
    final response = await _dio.get('/discounts/$id');
    return AdminDiscountModel.fromJson(response.data).toEntity();
  }

  @override
  Future<AdminDiscount> createDiscount({
    required String name,
    required String discountType,
    required double discountValue,
    required DateTime startDate,
    required DateTime endDate,
    required String status,
    required String scope,
    required List<int> targetIds,
  }) async {
    final response = await _dio.post('/discounts', data: {
      'name': name,
      'discountType': discountType,
      'discountValue': discountValue,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
      'scope': scope,
      'targetIds': targetIds,
    });
    
    if (response.data == null || response.data == '') {
      return AdminDiscount(
        discountId: 0,
        name: name,
        discountType: discountType,
        discountValue: discountValue,
        startDate: startDate,
        endDate: endDate,
        status: status,
        createdAt: DateTime.now(),
        productIds: scope == 'Product' ? targetIds : [],
        categoryIds: scope == 'Category' ? targetIds : [],
      );
    }
    
    return AdminDiscountModel.fromJson(response.data).toEntity();
  }

  @override
  Future<void> updateDiscount(
    int id, {
    required String name,
    required String discountType,
    required double discountValue,
    required DateTime startDate,
    required DateTime endDate,
    required String status,
    required String scope,
    required List<int> targetIds,
  }) async {
    await _dio.put('/discounts/$id', data: {
      'name': name,
      'discountType': discountType,
      'discountValue': discountValue,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
      'scope': scope,
      'targetIds': targetIds,
    });
  }

  @override
  Future<void> deleteDiscount(int id) async {
    await _dio.delete('/discounts/$id');
  }
}
