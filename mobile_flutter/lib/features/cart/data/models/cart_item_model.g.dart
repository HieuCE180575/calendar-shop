// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartItemModelImpl _$$CartItemModelImplFromJson(Map<String, dynamic> json) =>
    _$CartItemModelImpl(
      cartItemId: (json['cartItemId'] as num).toInt(),
      productId: (json['productId'] as num).toInt(),
      productName: json['productName'] as String,
      imageUrl: json['imageUrl'] as String?,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      stockQuantity: (json['stockQuantity'] as num).toInt(),
      isSelected: json['isSelected'] as bool,
      lineTotal: (json['lineTotal'] as num).toDouble(),
    );

Map<String, dynamic> _$$CartItemModelImplToJson(_$CartItemModelImpl instance) =>
    <String, dynamic>{
      'cartItemId': instance.cartItemId,
      'productId': instance.productId,
      'productName': instance.productName,
      'imageUrl': instance.imageUrl,
      'price': instance.price,
      'quantity': instance.quantity,
      'stockQuantity': instance.stockQuantity,
      'isSelected': instance.isSelected,
      'lineTotal': instance.lineTotal,
    };
