import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({required this.remoteDataSource, required this.tokenStorage});

  @override
  Future<AuthResult> login({required String login, required String password}) async {
    final result = await remoteDataSource.login(login: login, password: password);
    await tokenStorage.saveToken(result.token);
    return result;
  }

  @override
  Future<AuthResult> register({required String fullName, String? email, String? phone, required String password}) async {
    final result = await remoteDataSource.register(fullName: fullName, email: email, phone: phone, password: password);
    await tokenStorage.saveToken(result.token);
    return result;
  }

  @override
  Future<AppUser> me() => remoteDataSource.me();

  @override
  Future<void> logout() => tokenStorage.clearToken();
}
