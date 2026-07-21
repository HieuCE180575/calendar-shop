// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderItemModelImpl _$$OrderItemModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemModelImpl(
      orderItemId: (json['orderItemId'] as num).toInt(),
      productId: (json['productId'] as num).toInt(),
      productName: json['productName'] as String,
      productImageUrl: json['productImageUrl'] as String?,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );

Map<String, dynamic> _$$OrderItemModelImplToJson(
        _$OrderItemModelImpl instance) =>
    <String, dynamic>{
      'orderItemId': instance.orderItemId,
      'productId': instance.productId,
      'productName': instance.productName,
      'productImageUrl': instance.productImageUrl,
      'unitPrice': instance.unitPrice,
      'quantity': instance.quantity,
      'totalPrice': instance.totalPrice,
    };

_$OrderModelImpl _$$OrderModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderModelImpl(
      orderId: (json['orderId'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      shippingAddress: json['shippingAddress'] as String,
      subTotal: (json['subTotal'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num).toDouble(),
      shippingFee: (json['shippingFee'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      status: json['status'] as String,
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$OrderModelImplToJson(_$OrderModelImpl instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'userId': instance.userId,
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'shippingAddress': instance.shippingAddress,
      'subTotal': instance.subTotal,
      'discountAmount': instance.discountAmount,
      'shippingFee': instance.shippingFee,
      'totalAmount': instance.totalAmount,
      'paymentMethod': instance.paymentMethod,
      'status': instance.status,
      'note': instance.note,
      'createdAt': instance.createdAt.toIso8601String(),
      'items': instance.items,
    };
