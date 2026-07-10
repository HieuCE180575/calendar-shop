class AdminUserModel {
  final int userId;
  final String fullName;
  final String? email;
  final String? phone;
  final String role;
  final String status;
  final bool isEmailConfirmed;
  final DateTime? emailConfirmedAt;
  final String? avatarUrl;
  final String? gender;
  final DateTime? dateOfBirth;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AdminUserModel({
    required this.userId,
    required this.fullName,
    this.email,
    this.phone,
    required this.role,
    required this.status,
    this.isEmailConfirmed = false,
    this.emailConfirmedAt,
    this.avatarUrl,
    this.gender,
    this.dateOfBirth,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      userId: (json['userId'] as num).toInt(),
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      role: json['role']?.toString() ?? 'Customer',
      status: json['status']?.toString() ?? 'Active',
      isEmailConfirmed: json['isEmailConfirmed'] == true,
      emailConfirmedAt: DateTime.tryParse(json['emailConfirmedAt']?.toString() ?? ''),
      avatarUrl: json['avatarUrl']?.toString(),
      gender: json['gender']?.toString(),
      dateOfBirth: DateTime.tryParse(json['dateOfBirth']?.toString() ?? ''),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
    );
  }
}
