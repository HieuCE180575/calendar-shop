import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/admin_coupon_model.dart';

class AdminCouponRemoteDataSource {
  final ApiClient apiClient;

  AdminCouponRemoteDataSource(this.apiClient);

  Future<List<AdminCouponModel>> getCoupons() async {
    try {
      final response = await apiClient.dio.get(
        ApiConstants.coupons,
        queryParameters: {
          '\$orderby': 'CreatedAt desc',
        },
      );

      final List dataList;
      if (response.data is Map && (response.data as Map).containsKey('value')) {
        dataList = response.data['value'] as List;
      } else if (response.data is List) {
        dataList = response.data as List;
      } else {
        dataList = [];
      }

      return dataList.map((e) => AdminCouponModel.fromJson(e)).toList();
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<AdminCouponModel> getCouponById(int id) async {
    try {
      final response = await apiClient.dio.get('${ApiConstants.coupons}/$id');
      return AdminCouponModel.fromJson(response.data);
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<AdminCouponModel> createCoupon({
    required String code,
    String? description,
    required String discountType,
    required double discountValue,
    required double minOrderValue,
    required DateTime startDate,
    required DateTime endDate,
    int? usageLimit,
    required String status,
  }) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.coupons,
        data: {
          'code': code,
          'description': description,
          'discountType': discountType,
          'discountValue': discountValue,
          'minOrderValue': minOrderValue,
          'startDate': startDate.toUtc().toIso8601String(),
          'endDate': endDate.toUtc().toIso8601String(),
          'usageLimit': usageLimit,
          'status': status,
        },
      );
      return AdminCouponModel.fromJson(response.data);
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<void> updateCoupon(
    int id, {
    required String code,
    String? description,
    required String discountType,
    required double discountValue,
    required double minOrderValue,
    required DateTime startDate,
    required DateTime endDate,
    int? usageLimit,
    required String status,
  }) async {
    try {
      await apiClient.dio.put(
        '${ApiConstants.coupons}/$id',
        data: {
          'code': code,
          'description': description,
          'discountType': discountType,
          'discountValue': discountValue,
          'minOrderValue': minOrderValue,
          'startDate': startDate.toUtc().toIso8601String(),
          'endDate': endDate.toUtc().toIso8601String(),
          'usageLimit': usageLimit,
          'status': status,
        },
      );
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<void> updateCouponStatus(int id, String status) async {
    try {
      await apiClient.dio.patch(
        '${ApiConstants.coupons}/$id/status',
        data: {
          'status': status,
        },
      );
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }
}
