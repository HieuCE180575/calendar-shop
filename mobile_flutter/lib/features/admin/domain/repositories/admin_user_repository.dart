import '../entities/admin_user.dart';

abstract class AdminUserRepository {
  Future<List<AdminUser>> getUsers({
    String? search,
    String? role,
    String? status,
  });

  Future<AdminUser> getUserById(int id);
  Future<void> updateStatus({required int id, required String status});
  Future<void> updateRole({required int id, required String role});
}
