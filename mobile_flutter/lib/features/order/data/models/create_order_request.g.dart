// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateOrderRequestImpl _$$CreateOrderRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateOrderRequestImpl(
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      shippingAddress: json['shippingAddress'] as String,
      paymentMethod: json['paymentMethod'] as String,
      couponCode: json['couponCode'] as String?,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$CreateOrderRequestImplToJson(
        _$CreateOrderRequestImpl instance) =>
    <String, dynamic>{
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'shippingAddress': instance.shippingAddress,
      'paymentMethod': instance.paymentMethod,
      'couponCode': instance.couponCode,
      'note': instance.note,
    };
