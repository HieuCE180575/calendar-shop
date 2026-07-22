// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddressModelImpl _$$AddressModelImplFromJson(Map<String, dynamic> json) =>
    _$AddressModelImpl(
      addressId: (json['addressId'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      receiverName: json['receiverName'] as String,
      receiverPhone: json['receiverPhone'] as String,
      province: json['province'] as String,
      district: json['district'] as String,
      ward: json['ward'] as String?,
      addressLine: json['addressLine'] as String,
      isDefault: json['isDefault'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$AddressModelImplToJson(_$AddressModelImpl instance) =>
    <String, dynamic>{
      'addressId': instance.addressId,
      'userId': instance.userId,
      'receiverName': instance.receiverName,
      'receiverPhone': instance.receiverPhone,
      'province': instance.province,
      'district': instance.district,
      'ward': instance.ward,
      'addressLine': instance.addressLine,
      'isDefault': instance.isDefault,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
