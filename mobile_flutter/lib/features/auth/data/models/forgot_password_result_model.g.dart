// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgot_password_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ForgotPasswordResultModelImpl _$$ForgotPasswordResultModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ForgotPasswordResultModelImpl(
      message: json['message'] as String,
      expiredAt: json['expiredAt'] == null
          ? null
          : DateTime.parse(json['expiredAt'] as String),
    );

Map<String, dynamic> _$$ForgotPasswordResultModelImplToJson(
        _$ForgotPasswordResultModelImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'expiredAt': instance.expiredAt?.toIso8601String(),
    };
