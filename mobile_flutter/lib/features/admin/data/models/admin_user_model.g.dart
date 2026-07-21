// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdminUserModelImpl _$$AdminUserModelImplFromJson(Map<String, dynamic> json) =>
    _$AdminUserModelImpl(
      userId: (json['userId'] as num).toInt(),
      fullName: json['fullName'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String,
      status: json['status'] as String,
      isEmailConfirmed: json['isEmailConfirmed'] as bool? ?? false,
      emailConfirmedAt: json['emailConfirmedAt'] == null
          ? null
          : DateTime.parse(json['emailConfirmedAt'] as String),
      avatarUrl: json['avatarUrl'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$AdminUserModelImplToJson(
        _$AdminUserModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'fullName': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'role': instance.role,
      'status': instance.status,
      'isEmailConfirmed': instance.isEmailConfirmed,
      'emailConfirmedAt': instance.emailConfirmedAt?.toIso8601String(),
      'avatarUrl': instance.avatarUrl,
      'gender': instance.gender,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
