import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_coupon.freezed.dart';

@freezed
class AdminCoupon with _$AdminCoupon {
  const factory AdminCoupon({
    required int couponId,
    required String code,
    String? description,
    required String discountType,
    required double discountValue,
    required double minOrderValue,
    required DateTime startDate,
    required DateTime endDate,
    int? usageLimit,
    required int usedCount,
    required String status,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _AdminCoupon;
}
