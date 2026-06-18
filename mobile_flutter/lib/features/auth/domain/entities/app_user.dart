class AppUser {
  final int userId;
  final String fullName;
  final String? email;
  final String? phone;
  final String role;
  final String status;
  final String? avatarUrl;

  const AppUser({
    required this.userId,
    required this.fullName,
    this.email,
    this.phone,
    required this.role,
    required this.status,
    this.avatarUrl,
  });
}
