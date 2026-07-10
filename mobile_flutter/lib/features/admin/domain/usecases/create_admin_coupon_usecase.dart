import '../entities/admin_coupon.dart';
import '../repositories/admin_coupon_repository.dart';

class CreateAdminCouponUseCase {
  final AdminCouponRepository repository;

  CreateAdminCouponUseCase(this.repository);

  Future<AdminCoupon> call({
    required String code,
    String? description,
    required String discountType,
    required double discountValue,
    required double minOrderValue,
    required DateTime startDate,
    required DateTime endDate,
    int? usageLimit,
    required String status,
  }) {
    return repository.createCoupon(
      code: code,
      description: description,
      discountType: discountType,
      discountValue: discountValue,
      minOrderValue: minOrderValue,
      startDate: startDate,
      endDate: endDate,
      usageLimit: usageLimit,
      status: status,
    );
  }
}
