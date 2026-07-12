import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/admin_coupon_remote_datasource.dart';
import '../../data/repositories/admin_coupon_repository_impl.dart';
import '../../domain/entities/admin_coupon.dart';
import '../../domain/repositories/admin_coupon_repository.dart';
import '../../domain/usecases/create_admin_coupon_usecase.dart';
import '../../domain/usecases/get_admin_coupon_by_id_usecase.dart';
import '../../domain/usecases/get_admin_coupons_usecase.dart';
import '../../domain/usecases/update_admin_coupon_status_usecase.dart';
import '../../domain/usecases/update_admin_coupon_usecase.dart';

final adminCouponRemoteDataSourceProvider =
    Provider<AdminCouponRemoteDataSource>((ref) {
  return AdminCouponRemoteDataSource(ref.watch(apiClientProvider));
});

final adminCouponRepositoryProvider = Provider<AdminCouponRepository>((ref) {
  return AdminCouponRepositoryImpl(ref.watch(adminCouponRemoteDataSourceProvider));
});

final getAdminCouponsUseCaseProvider = Provider<GetAdminCouponsUseCase>((ref) {
  return GetAdminCouponsUseCase(ref.watch(adminCouponRepositoryProvider));
});

final getAdminCouponByIdUseCaseProvider =
    Provider<GetAdminCouponByIdUseCase>((ref) {
  return GetAdminCouponByIdUseCase(ref.watch(adminCouponRepositoryProvider));
});

final createAdminCouponUseCaseProvider =
    Provider<CreateAdminCouponUseCase>((ref) {
  return CreateAdminCouponUseCase(ref.watch(adminCouponRepositoryProvider));
});

final updateAdminCouponUseCaseProvider =
    Provider<UpdateAdminCouponUseCase>((ref) {
  return UpdateAdminCouponUseCase(ref.watch(adminCouponRepositoryProvider));
});

final updateAdminCouponStatusUseCaseProvider =
    Provider<UpdateAdminCouponStatusUseCase>((ref) {
  return UpdateAdminCouponStatusUseCase(
    ref.watch(adminCouponRepositoryProvider),
  );
});

final adminCouponListProvider =
    FutureProvider.autoDispose<List<AdminCoupon>>((ref) async {
  return ref.watch(getAdminCouponsUseCaseProvider)();
});

final adminCouponDetailProvider =
    FutureProvider.family.autoDispose<AdminCoupon, int>((ref, id) async {
  return ref.watch(getAdminCouponByIdUseCaseProvider)(id);
});

class AdminCouponActionState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  const AdminCouponActionState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });
}

class AdminCouponActionNotifier extends StateNotifier<AdminCouponActionState> {
  final Ref ref;

  AdminCouponActionNotifier(this.ref)
      : super(const AdminCouponActionState());

  Future<bool> createCoupon({
    required String code,
    String? description,
    required String discountType,
    required double discountValue,
    required double minOrderValue,
    required DateTime startDate,
    required DateTime endDate,
    int? usageLimit,
    required String status,
  }) async {
    state = const AdminCouponActionState(isLoading: true);
    try {
      await ref.read(createAdminCouponUseCaseProvider)(
            code: code,
            description: description,
            discountType: discountType,
            discountValue: discountValue,
            minOrderValue: minOrderValue,
            startDate: startDate,
            endDate: endDate,
            usageLimit: usageLimit,
            status: status,
          );
      state = const AdminCouponActionState(isSuccess: true);
      ref.invalidate(adminCouponListProvider);
      return true;
    } catch (e) {
      state = AdminCouponActionState(error: e.toString());
      return false;
    }
  }

  Future<bool> updateCoupon(
    int id, {
    required String code,
    String? description,
    required String discountType,
    required double discountValue,
    required double minOrderValue,
    required DateTime startDate,
    required DateTime endDate,
    int? usageLimit,
    required String status,
  }) async {
    state = const AdminCouponActionState(isLoading: true);
    try {
      await ref.read(updateAdminCouponUseCaseProvider)(
            id,
            code: code,
            description: description,
            discountType: discountType,
            discountValue: discountValue,
            minOrderValue: minOrderValue,
            startDate: startDate,
            endDate: endDate,
            usageLimit: usageLimit,
            status: status,
          );
      state = const AdminCouponActionState(isSuccess: true);
      ref.invalidate(adminCouponListProvider);
      ref.invalidate(adminCouponDetailProvider(id));
      return true;
    } catch (e) {
      state = AdminCouponActionState(error: e.toString());
      return false;
    }
  }

  Future<bool> updateStatus(int id, String status) async {
    state = const AdminCouponActionState(isLoading: true);
    try {
      await ref.read(updateAdminCouponStatusUseCaseProvider)(id, status);
      state = const AdminCouponActionState(isSuccess: true);
      ref.invalidate(adminCouponListProvider);
      ref.invalidate(adminCouponDetailProvider(id));
      return true;
    } catch (e) {
      state = AdminCouponActionState(error: e.toString());
      return false;
    }
  }
}

final adminCouponActionNotifierProvider =
    StateNotifierProvider<AdminCouponActionNotifier, AdminCouponActionState>(
  (ref) => AdminCouponActionNotifier(ref),
);
