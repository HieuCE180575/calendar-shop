import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/admin_user_remote_datasource.dart';
import '../../data/models/admin_user_model.dart';

final adminUserRemoteDataSourceProvider = Provider<AdminUserRemoteDataSource>((ref) {
  return AdminUserRemoteDataSource(ref.watch(apiClientProvider));
});

final adminUserListRefreshProvider = StateProvider<int>((ref) => 0);

class AdminUserFilter {
  final String search;
  final String? role;
  final String? status;

  const AdminUserFilter({this.search = '', this.role, this.status});

  @override
  bool operator ==(Object other) {
    return other is AdminUserFilter && other.search == search && other.role == role && other.status == status;
  }

  @override
  int get hashCode => Object.hash(search, role, status);
}

final adminUsersProvider = FutureProvider.autoDispose.family<List<AdminUserModel>, AdminUserFilter>((ref, filter) async {
  ref.watch(adminUserListRefreshProvider);
  return ref.watch(adminUserRemoteDataSourceProvider).getUsers(
        search: filter.search,
        role: filter.role,
        status: filter.status,
      );
});

final adminUserDetailProvider = FutureProvider.autoDispose.family<AdminUserModel, int>((ref, id) async {
  return ref.watch(adminUserRemoteDataSourceProvider).getUserById(id);
});

class AdminUserActionState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  const AdminUserActionState({this.isLoading = false, this.error, this.isSuccess = false});
}

class AdminUserActionNotifier extends StateNotifier<AdminUserActionState> {
  final Ref ref;

  AdminUserActionNotifier(this.ref) : super(const AdminUserActionState());

  Future<bool> updateStatus(int id, String status) async {
    state = const AdminUserActionState(isLoading: true);
    try {
      await ref.read(adminUserRemoteDataSourceProvider).updateStatus(id: id, status: status);
      final refresh = ref.read(adminUserListRefreshProvider.notifier);
      refresh.state = refresh.state + 1;
      ref.invalidate(adminUserDetailProvider(id));
      state = const AdminUserActionState(isSuccess: true);
      return true;
    } catch (e) {
      state = AdminUserActionState(error: e.toString());
      return false;
    }
  }

  Future<bool> updateRole(int id, String role) async {
    state = const AdminUserActionState(isLoading: true);
    try {
      await ref.read(adminUserRemoteDataSourceProvider).updateRole(id: id, role: role);
      final refresh = ref.read(adminUserListRefreshProvider.notifier);
      refresh.state = refresh.state + 1;
      ref.invalidate(adminUserDetailProvider(id));
      state = const AdminUserActionState(isSuccess: true);
      return true;
    } catch (e) {
      state = AdminUserActionState(error: e.toString());
      return false;
    }
  }
}

final adminUserActionProvider = StateNotifierProvider<AdminUserActionNotifier, AdminUserActionState>((ref) {
  return AdminUserActionNotifier(ref);
});
