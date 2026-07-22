import '../entities/admin_discount.dart';

abstract class AdminDiscountRepository {
  Future<({List<AdminDiscount> items, int totalCount})> getDiscounts({
    String? searchQuery,
    int page = 1,
    int pageSize = 10,
    String? filterStatus,
    DateTime? filterStartDate,
    DateTime? filterEndDate,
    String? sortByDiscountValue,
  });

  Future<AdminDiscount> getDiscountById(int id);

  Future<AdminDiscount> createDiscount({
    required String name,
    required String discountType,
    required double discountValue,
    required DateTime startDate,
    required DateTime endDate,
    required String status,
    required String scope,
    required List<int> targetIds,
  });

  Future<void> updateDiscount(
    int id, {
    required String name,
    required String discountType,
    required double discountValue,
    required DateTime startDate,
    required DateTime endDate,
    required String status,
    required String scope,
    required List<int> targetIds,
  });

  Future<void> updateDiscountStatus(int id, String status);

  Future<void> deleteDiscount(int id);
}
