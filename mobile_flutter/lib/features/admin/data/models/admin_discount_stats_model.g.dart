// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_discount_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdminDiscountStatsModelImpl _$$AdminDiscountStatsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AdminDiscountStatsModelImpl(
      totalDiscounts: (json['totalDiscounts'] as num).toInt(),
      activeDiscounts: (json['activeDiscounts'] as num).toInt(),
      expiredDiscounts: (json['expiredDiscounts'] as num).toInt(),
      typeDistribution: (json['typeDistribution'] as List<dynamic>)
          .map((e) =>
              DiscountTypeDistributionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      topDiscounts: (json['topDiscounts'] as List<dynamic>)
          .map((e) => TopDiscountModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AdminDiscountStatsModelImplToJson(
        _$AdminDiscountStatsModelImpl instance) =>
    <String, dynamic>{
      'totalDiscounts': instance.totalDiscounts,
      'activeDiscounts': instance.activeDiscounts,
      'expiredDiscounts': instance.expiredDiscounts,
      'typeDistribution': instance.typeDistribution,
      'topDiscounts': instance.topDiscounts,
    };

_$DiscountTypeDistributionModelImpl
    _$$DiscountTypeDistributionModelImplFromJson(Map<String, dynamic> json) =>
        _$DiscountTypeDistributionModelImpl(
          type: json['type'] as String,
          total: (json['total'] as num).toInt(),
          percentage: (json['percentage'] as num).toDouble(),
        );

Map<String, dynamic> _$$DiscountTypeDistributionModelImplToJson(
        _$DiscountTypeDistributionModelImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'total': instance.total,
      'percentage': instance.percentage,
    };

_$TopDiscountModelImpl _$$TopDiscountModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TopDiscountModelImpl(
      discountId: (json['discountId'] as num).toInt(),
      code: json['code'] as String,
      usageCount: (json['usageCount'] as num).toInt(),
    );

Map<String, dynamic> _$$TopDiscountModelImplToJson(
        _$TopDiscountModelImpl instance) =>
    <String, dynamic>{
      'discountId': instance.discountId,
      'code': instance.code,
      'usageCount': instance.usageCount,
    };
