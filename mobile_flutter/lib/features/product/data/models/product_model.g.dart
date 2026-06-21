// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductModelImpl _$$ProductModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductModelImpl(
      productId: (json['productId'] as num).toInt(),
      categoryId: (json['categoryId'] as num).toInt(),
      categoryName: json['categoryName'] as String?,
      productName: json['productName'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      stockQuantity: (json['stockQuantity'] as num).toInt(),
      imageUrl: json['imageUrl'] as String?,
      calendarType: json['calendarType'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ProductModelImplToJson(_$ProductModelImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'productName': instance.productName,
      'description': instance.description,
      'price': instance.price,
      'stockQuantity': instance.stockQuantity,
      'imageUrl': instance.imageUrl,
      'calendarType': instance.calendarType,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
    };
