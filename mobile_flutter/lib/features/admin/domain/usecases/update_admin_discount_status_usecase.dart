import '../repositories/admin_discount_repository.dart';

class UpdateAdminDiscountStatusUseCase {
  final AdminDiscountRepository repository;

  UpdateAdminDiscountStatusUseCase(this.repository);

  Future<void> call(int id, String status) {
    return repository.updateDiscountStatus(id, status);
  }
}
