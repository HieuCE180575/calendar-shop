// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_discount_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdminDiscountModelImpl _$$AdminDiscountModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AdminDiscountModelImpl(
      discountId: (json['discountId'] as num).toInt(),
      name: json['name'] as String,
      discountType: json['discountType'] as String,
      discountValue: (json['discountValue'] as num).toDouble(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      productIds: (json['productIds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      categoryIds: (json['categoryIds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$AdminDiscountModelImplToJson(
        _$AdminDiscountModelImpl instance) =>
    <String, dynamic>{
      'discountId': instance.discountId,
      'name': instance.name,
      'discountType': instance.discountType,
      'discountValue': instance.discountValue,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'productIds': instance.productIds,
      'categoryIds': instance.categoryIds,
    };
