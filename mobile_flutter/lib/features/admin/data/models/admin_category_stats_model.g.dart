// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_category_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdminCategoryStatsModelImpl _$$AdminCategoryStatsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AdminCategoryStatsModelImpl(
      totalCategories: (json['totalCategories'] as num).toInt(),
      activeCategories: (json['activeCategories'] as num).toInt(),
      hiddenCategories: (json['hiddenCategories'] as num).toInt(),
      productDistribution: (json['productDistribution'] as List<dynamic>)
          .map((e) => CategoryProductDistributionModel.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AdminCategoryStatsModelImplToJson(
        _$AdminCategoryStatsModelImpl instance) =>
    <String, dynamic>{
      'totalCategories': instance.totalCategories,
      'activeCategories': instance.activeCategories,
      'hiddenCategories': instance.hiddenCategories,
      'productDistribution': instance.productDistribution,
    };

_$CategoryProductDistributionModelImpl
    _$$CategoryProductDistributionModelImplFromJson(
            Map<String, dynamic> json) =>
        _$CategoryProductDistributionModelImpl(
          categoryName: json['categoryName'] as String,
          productCount: (json['productCount'] as num).toInt(),
          percentage: (json['percentage'] as num).toDouble(),
        );

Map<String, dynamic> _$$CategoryProductDistributionModelImplToJson(
        _$CategoryProductDistributionModelImpl instance) =>
    <String, dynamic>{
      'categoryName': instance.categoryName,
      'productCount': instance.productCount,
      'percentage': instance.percentage,
    };
