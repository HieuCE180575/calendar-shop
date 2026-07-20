import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/repositories/admin_discount_repository_impl.dart';
import '../../domain/entities/admin_discount.dart';
import '../../domain/repositories/admin_discount_repository.dart';

part 'admin_discount_provider.g.dart';

@riverpod
AdminDiscountRepository adminDiscountRepository(AdminDiscountRepositoryRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AdminDiscountRepositoryImpl(apiClient.dio);
}

class AdminDiscountFilterState {
  final String? searchQuery;
  final int page;
  final int pageSize;
  final String? filterStatus;
  final DateTime? filterStartDate;
  final DateTime? filterEndDate;
  final String? sortByDiscountValue;

  AdminDiscountFilterState({
    this.searchQuery,
    this.page = 1,
    this.pageSize = 10,
    this.filterStatus,
    this.filterStartDate,
    this.filterEndDate,
    this.sortByDiscountValue,
  });

  AdminDiscountFilterState copyWith({
    String? searchQuery,
    int? page,
    int? pageSize,
    String? filterStatus,
    DateTime? filterStartDate,
    DateTime? filterEndDate,
    String? sortByDiscountValue,
  }) {
    return AdminDiscountFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      filterStatus: filterStatus ?? this.filterStatus,
      filterStartDate: filterStartDate ?? this.filterStartDate,
      filterEndDate: filterEndDate ?? this.filterEndDate,
      sortByDiscountValue: sortByDiscountValue ?? this.sortByDiscountValue,
    );
  }
}

@riverpod
class AdminDiscountFilter extends _$AdminDiscountFilter {
  @override
  AdminDiscountFilterState build() {
    return AdminDiscountFilterState();
  }

  void updateSearchQuery(String? query) {
    state = state.copyWith(searchQuery: query, page: 1);
  }

  void updatePage(int page) {
    state = state.copyWith(page: page);
  }

  void updateFilterAndSort({
    String? filterStatus,
    DateTime? filterStartDate,
    DateTime? filterEndDate,
    String? sortByDiscountValue,
  }) {
    state = AdminDiscountFilterState(
      searchQuery: state.searchQuery,
      page: 1,
      pageSize: state.pageSize,
      filterStatus: filterStatus,
      filterStartDate: filterStartDate,
      filterEndDate: filterEndDate,
      sortByDiscountValue: sortByDiscountValue,
    );
  }

  void resetFilter() {
    state = AdminDiscountFilterState(pageSize: state.pageSize);
  }
}

@riverpod
Future<({List<AdminDiscount> items, int totalCount})> adminDiscountList(AdminDiscountListRef ref) {
  final filter = ref.watch(adminDiscountFilterProvider);
  return ref.watch(adminDiscountRepositoryProvider).getDiscounts(
    searchQuery: filter.searchQuery,
    page: filter.page,
    pageSize: filter.pageSize,
    filterStatus: filter.filterStatus,
    filterStartDate: filter.filterStartDate,
    filterEndDate: filter.filterEndDate,
    sortByDiscountValue: filter.sortByDiscountValue,
  );
}

@riverpod
Future<AdminDiscount> adminDiscountDetail(AdminDiscountDetailRef ref, int id) {
  return ref.watch(adminDiscountRepositoryProvider).getDiscountById(id);
}

@riverpod
class AdminDiscountActionNotifier extends _$AdminDiscountActionNotifier {
  @override
  bool build() {
    return false; // isLoading
  }

  Future<bool> createDiscount({
    required String name,
    required String discountType,
    required double discountValue,
    required DateTime startDate,
    required DateTime endDate,
    required String status,
    required String scope,
    required List<int> targetIds,
  }) async {
    state = true;
    try {
      await ref.read(adminDiscountRepositoryProvider).createDiscount(
            name: name,
            discountType: discountType,
            discountValue: discountValue,
            startDate: startDate,
            endDate: endDate,
            status: status,
            scope: scope,
            targetIds: targetIds,
          );
      ref.invalidate(adminDiscountListProvider);
      state = false;
      return true;
    } catch (e) {
      state = false;
      return false;
    }
  }

  Future<bool> updateDiscount(
    int id, {
    required String name,
    required String discountType,
    required double discountValue,
    required DateTime startDate,
    required DateTime endDate,
    required String status,
    required String scope,
    required List<int> targetIds,
  }) async {
    state = true;
    try {
      await ref.read(adminDiscountRepositoryProvider).updateDiscount(
            id,
            name: name,
            discountType: discountType,
            discountValue: discountValue,
            startDate: startDate,
            endDate: endDate,
            status: status,
            scope: scope,
            targetIds: targetIds,
          );
      ref.invalidate(adminDiscountListProvider);
      ref.invalidate(adminDiscountDetailProvider(id));
      state = false;
      return true;
    } catch (e) {
      state = false;
      return false;
    }
  }

  Future<bool> deleteDiscount(int id) async {
    state = true;
    try {
      await ref.read(adminDiscountRepositoryProvider).deleteDiscount(id);
      ref.invalidate(adminDiscountListProvider);
      state = false;
      return true;
    } catch (e) {
      state = false;
      return false;
    }
  }
}
