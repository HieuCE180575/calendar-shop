import '../repositories/admin_coupon_repository.dart';

class UpdateAdminCouponStatusUseCase {
  final AdminCouponRepository repository;

  UpdateAdminCouponStatusUseCase(this.repository);

  Future<void> call(int id, String status) {
    return repository.updateCouponStatus(id, status);
  }
}
