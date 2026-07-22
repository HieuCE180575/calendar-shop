// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_product_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdminProductStatsModelImpl _$$AdminProductStatsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AdminProductStatsModelImpl(
      totalProducts: (json['totalProducts'] as num).toInt(),
      totalProductsGrowth:
          (json['totalProductsGrowth'] as num?)?.toDouble() ?? 0.0,
      inBusiness: (json['inBusiness'] as num).toInt(),
      inBusinessGrowth: (json['inBusinessGrowth'] as num?)?.toDouble() ?? 0.0,
      lowStock: (json['lowStock'] as num).toInt(),
      totalCategories: (json['totalCategories'] as num).toInt(),
      bestSelling: (json['bestSelling'] as List<dynamic>)
          .map((e) =>
              ProductBestSellingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      stockByCategory: (json['stockByCategory'] as List<dynamic>)
          .map((e) => CategoryStockDistributionModel.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      lowStockProducts: (json['lowStockProducts'] as List<dynamic>)
          .map((e) => ProductLowStockModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AdminProductStatsModelImplToJson(
        _$AdminProductStatsModelImpl instance) =>
    <String, dynamic>{
      'totalProducts': instance.totalProducts,
      'totalProductsGrowth': instance.totalProductsGrowth,
      'inBusiness': instance.inBusiness,
      'inBusinessGrowth': instance.inBusinessGrowth,
      'lowStock': instance.lowStock,
      'totalCategories': instance.totalCategories,
      'bestSelling': instance.bestSelling,
      'stockByCategory': instance.stockByCategory,
      'lowStockProducts': instance.lowStockProducts,
    };

_$ProductBestSellingModelImpl _$$ProductBestSellingModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductBestSellingModelImpl(
      productId: (json['productId'] as num).toInt(),
      productName: json['productName'] as String,
      totalSold: (json['totalSold'] as num).toInt(),
    );

Map<String, dynamic> _$$ProductBestSellingModelImplToJson(
        _$ProductBestSellingModelImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'totalSold': instance.totalSold,
    };

_$CategoryStockDistributionModelImpl
    _$$CategoryStockDistributionModelImplFromJson(Map<String, dynamic> json) =>
        _$CategoryStockDistributionModelImpl(
          categoryName: json['categoryName'] as String,
          totalStock: (json['totalStock'] as num).toInt(),
          percentage: (json['percentage'] as num).toDouble(),
        );

Map<String, dynamic> _$$CategoryStockDistributionModelImplToJson(
        _$CategoryStockDistributionModelImpl instance) =>
    <String, dynamic>{
      'categoryName': instance.categoryName,
      'totalStock': instance.totalStock,
      'percentage': instance.percentage,
    };

_$ProductLowStockModelImpl _$$ProductLowStockModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductLowStockModelImpl(
      productId: (json['productId'] as num).toInt(),
      productName: json['productName'] as String,
      stockQuantity: (json['stockQuantity'] as num).toInt(),
    );

Map<String, dynamic> _$$ProductLowStockModelImplToJson(
        _$ProductLowStockModelImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'stockQuantity': instance.stockQuantity,
    };
