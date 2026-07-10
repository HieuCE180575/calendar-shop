import '../entities/admin_coupon.dart';
import '../repositories/admin_coupon_repository.dart';

class GetAdminCouponsUseCase {
  final AdminCouponRepository repository;

  GetAdminCouponsUseCase(this.repository);

  Future<List<AdminCoupon>> call() {
    return repository.getCoupons();
  }
}
