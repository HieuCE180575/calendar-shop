import '../entities/admin_discount.dart';
import '../repositories/admin_discount_repository.dart';

class GetAdminDiscountByIdUseCase {
  final AdminDiscountRepository repository;

  GetAdminDiscountByIdUseCase(this.repository);

  Future<AdminDiscount> call(int id) {
    return repository.getDiscountById(id);
  }
}
