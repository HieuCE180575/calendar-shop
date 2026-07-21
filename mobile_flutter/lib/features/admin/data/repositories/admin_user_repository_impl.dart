import '../../domain/entities/admin_user.dart';
import '../../domain/repositories/admin_user_repository.dart';
import '../datasources/admin_user_remote_datasource.dart';
import '../models/admin_user_model.dart';

class AdminUserRepositoryImpl implements AdminUserRepository {
  final AdminUserRemoteDataSource remoteDataSource;

  AdminUserRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<AdminUser>> getUsers({
    String? search,
    String? role,
    String? status,
  }) async {
    final models = await remoteDataSource.getUsers(
      search: search,
      role: role,
      status: status,
    );
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<AdminUser> getUserById(int id) async {
    final model = await remoteDataSource.getUserById(id);
    return model.toEntity();
  }

  @override
  Future<void> updateRole({required int id, required String role}) {
    return remoteDataSource.updateRole(id: id, role: role);
  }

  @override
  Future<void> updateStatus({required int id, required String status}) {
    return remoteDataSource.updateStatus(id: id, status: status);
  }
}
