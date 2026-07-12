import '../entities/admin_coupon.dart';

abstract class AdminCouponRepository {
  Future<List<AdminCoupon>> getCoupons();

  Future<AdminCoupon> getCouponById(int id);

  Future<AdminCoupon> createCoupon({
    required String code,
    String? description,
    required String discountType,
    required double discountValue,
    required double minOrderValue,
    required DateTime startDate,
    required DateTime endDate,
    int? usageLimit,
    required String status,
  });

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
  });

  Future<void> updateCouponStatus(int id, String status);
}
