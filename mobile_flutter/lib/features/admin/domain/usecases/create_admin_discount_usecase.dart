import '../entities/admin_discount.dart';
import '../repositories/admin_discount_repository.dart';

class CreateAdminDiscountUseCase {
  final AdminDiscountRepository repository;

  CreateAdminDiscountUseCase(this.repository);

  Future<AdminDiscount> call({
    required String name,
    required String discountType,
    required double discountValue,
    required DateTime startDate,
    required DateTime endDate,
    required String status,
    required String scope,
    required List<int> targetIds,
  }) {
    return repository.createDiscount(
      name: name,
      discountType: discountType,
      discountValue: discountValue,
      startDate: startDate,
      endDate: endDate,
      status: status,
      scope: scope,
      targetIds: targetIds,
    );
  }
}
