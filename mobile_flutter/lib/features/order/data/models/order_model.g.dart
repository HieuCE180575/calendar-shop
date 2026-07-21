// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderModelImpl _$$OrderModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderModelImpl(
      orderId: (json['orderId'] as num).toInt(),
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      shippingAddress: json['shippingAddress'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$OrderModelImplToJson(_$OrderModelImpl instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'shippingAddress': instance.shippingAddress,
      'totalAmount': instance.totalAmount,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
    };
