import '../entities/admin_discount.dart';
import '../repositories/admin_discount_repository.dart';

class GetAdminDiscountsUseCase {
  final AdminDiscountRepository repository;

  GetAdminDiscountsUseCase(this.repository);

  Future<({List<AdminDiscount> items, int totalCount})> call({
    String? searchQuery,
    int page = 1,
    int pageSize = 10,
    String? filterStatus,
    DateTime? filterStartDate,
    DateTime? filterEndDate,
    String? sortByDiscountValue,
  }) {
    return repository.getDiscounts(
      searchQuery: searchQuery,
      page: page,
      pageSize: pageSize,
      filterStatus: filterStatus,
      filterStartDate: filterStartDate,
      filterEndDate: filterEndDate,
      sortByDiscountValue: sortByDiscountValue,
    );
  }
}
