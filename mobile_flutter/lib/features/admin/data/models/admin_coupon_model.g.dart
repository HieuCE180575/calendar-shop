// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_coupon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdminCouponModelImpl _$$AdminCouponModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AdminCouponModelImpl(
      couponId: (json['couponId'] as num).toInt(),
      code: json['code'] as String,
      description: json['description'] as String?,
      discountType: json['discountType'] as String,
      discountValue: (json['discountValue'] as num).toDouble(),
      minOrderValue: (json['minOrderValue'] as num).toDouble(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      usageLimit: (json['usageLimit'] as num?)?.toInt(),
      usedCount: (json['usedCount'] as num).toInt(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$AdminCouponModelImplToJson(
        _$AdminCouponModelImpl instance) =>
    <String, dynamic>{
      'couponId': instance.couponId,
      'code': instance.code,
      'description': instance.description,
      'discountType': instance.discountType,
      'discountValue': instance.discountValue,
      'minOrderValue': instance.minOrderValue,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'usageLimit': instance.usageLimit,
      'usedCount': instance.usedCount,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
