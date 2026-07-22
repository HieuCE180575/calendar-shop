import '../../domain/entities/admin_coupon_stats.dart';

class AdminCouponStatsModel {
  final int totalCoupons;
  final double totalCouponsGrowth;
  final int activeCoupons;
  final double activeCouponsGrowth;

  const AdminCouponStatsModel({
    required this.totalCoupons,
    this.totalCouponsGrowth = 0.0,
    required this.activeCoupons,
    this.activeCouponsGrowth = 0.0,
  });

  factory AdminCouponStatsModel.fromJson(Map<String, dynamic> json) {
    return AdminCouponStatsModel(
      totalCoupons: json['totalCoupons'] as int? ?? 0,
      totalCouponsGrowth: (json['totalCouponsGrowth'] as num?)?.toDouble() ?? 0.0,
      activeCoupons: json['activeCoupons'] as int? ?? 0,
      activeCouponsGrowth: (json['activeCouponsGrowth'] as num?)?.toDouble() ?? 0.0,
    );
  }

  AdminCouponStats toEntity() {
    return AdminCouponStats(
      totalCoupons: totalCoupons,
      totalCouponsGrowth: totalCouponsGrowth,
      activeCoupons: activeCoupons,
      activeCouponsGrowth: activeCouponsGrowth,
    );
  }
}
