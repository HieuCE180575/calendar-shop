import '../entities/admin_user.dart';
import '../repositories/admin_user_repository.dart';

class GetAdminUsersUseCase {
  final AdminUserRepository repository;

  GetAdminUsersUseCase(this.repository);

  Future<List<AdminUser>> call({
    String? search,
    String? role,
    String? status,
  }) {
    return repository.getUsers(
      search: search,
      role: role,
      status: status,
    );
  }
}
