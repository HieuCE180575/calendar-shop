import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<String> call({required String fullName, String? email, String? phone, required String password}) {
    return repository.register(fullName: fullName, email: email, phone: phone, password: password);
  }
}
