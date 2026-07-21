import '../../../../core/network/api_client.dart';
import '../../domain/entities/admin_discount.dart';
import '../../domain/repositories/admin_discount_repository.dart';
import '../datasources/admin_discount_remote_datasource.dart';
import '../models/admin_discount_model.dart';

class AdminDiscountRepositoryImpl implements AdminDiscountRepository {
  final AdminDiscountRemoteDataSource remoteDataSource;
  final ApiClient apiClient;

  AdminDiscountRepositoryImpl({
    required this.remoteDataSource,
    required this.apiClient,
  });

  @override
  Future<({List<AdminDiscount> items, int totalCount})> getDiscounts({
    String? searchQuery,
    int page = 1,
    int pageSize = 10,
    String? filterStatus,
    DateTime? filterStartDate,
    DateTime? filterEndDate,
    String? sortByDiscountValue,
  }) async {
    try {
      final result = await remoteDataSource.getDiscounts(
        searchQuery: searchQuery,
        page: page,
        pageSize: pageSize,
        filterStatus: filterStatus,
        filterStartDate: filterStartDate,
        filterEndDate: filterEndDate,
        sortByDiscountValue: sortByDiscountValue,
      );
      final items = result.items.map((e) => e.toEntity()).toList();
      return (items: items, totalCount: result.totalCount);
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  @override
  Future<AdminDiscount> getDiscountById(int id) async {
    try {
      final model = await remoteDataSource.getDiscountById(id);
      return model.toEntity();
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  @override
  Future<AdminDiscount> createDiscount({
    required String name,
    required String discountType,
    required double discountValue,
    required DateTime startDate,
    required DateTime endDate,
    required String status,
    required String scope,
    required List<int> targetIds,
  }) async {
    try {
      final data = {
        'name': name,
        'discountType': discountType,
        'discountValue': discountValue,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'status': status,
        'scope': scope,
        'targetIds': targetIds,
      };

      final model = await remoteDataSource.createDiscount(data);
      return model.toEntity();
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  @override
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
  }) async {
    try {
      final data = {
        'name': name,
        'discountType': discountType,
        'discountValue': discountValue,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'status': status,
        'scope': scope,
        'targetIds': targetIds,
      };
      await remoteDataSource.updateDiscount(id, data);
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  @override
  Future<void> deleteDiscount(int id) async {
    try {
      await remoteDataSource.deleteDiscount(id);
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  @override
  Future<void> updateDiscountStatus(int id, String status) async {
    try {
      await remoteDataSource.updateDiscountStatus(id, status);
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }
}
