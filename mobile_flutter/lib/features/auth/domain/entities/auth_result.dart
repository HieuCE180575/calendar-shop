import 'app_user.dart';

class AuthResult {
  final String token;
  final AppUser user;

  const AuthResult({required this.token, required this.user});
}
