import '../../domain/entities/app_user.dart';

class UserModel extends AppUser {
  const UserModel({
    required super.userId,
    required super.fullName,
    super.email,
    super.phone,
    required super.role,
    required super.status,
    super.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      fullName: json['fullName'] ?? '',
      email: json['email'],
      phone: json['phone'],
      role: json['role'] ?? 'Customer',
      status: json['status'] ?? 'Active',
      avatarUrl: json['avatarUrl'],
    );
  }
}
