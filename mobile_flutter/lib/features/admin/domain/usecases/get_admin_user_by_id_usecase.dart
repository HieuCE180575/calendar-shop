import '../entities/admin_user.dart';
import '../repositories/admin_user_repository.dart';

class GetAdminUserByIdUseCase {
  final AdminUserRepository repository;

  GetAdminUserByIdUseCase(this.repository);

  Future<AdminUser> call(int id) {
    return repository.getUserById(id);
  }
}
