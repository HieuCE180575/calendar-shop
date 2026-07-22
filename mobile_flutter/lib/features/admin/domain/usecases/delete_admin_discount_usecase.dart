import '../repositories/admin_discount_repository.dart';

class DeleteAdminDiscountUseCase {
  final AdminDiscountRepository repository;

  DeleteAdminDiscountUseCase(this.repository);

  Future<void> call(int id) {
    return repository.deleteDiscount(id);
  }
}
