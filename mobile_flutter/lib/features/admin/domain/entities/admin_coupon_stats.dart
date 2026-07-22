class AdminCouponStats {
  final int totalCoupons;
  final double totalCouponsGrowth;
  final int activeCoupons;
  final double activeCouponsGrowth;

  const AdminCouponStats({
    required this.totalCoupons,
    this.totalCouponsGrowth = 0.0,
    required this.activeCoupons,
    this.activeCouponsGrowth = 0.0,
  });
}
