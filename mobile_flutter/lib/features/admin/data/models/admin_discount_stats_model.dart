import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/admin_discount_stats.dart';

part 'admin_discount_stats_model.freezed.dart';
part 'admin_discount_stats_model.g.dart';

@freezed
class AdminDiscountStatsModel with _$AdminDiscountStatsModel {
  const factory AdminDiscountStatsModel({
    required int totalDiscounts,
    required int activeDiscounts,
    required int expiredDiscounts,
    required List<DiscountTypeDistributionModel> typeDistribution,
    required List<TopDiscountModel> topDiscounts,
  }) = _AdminDiscountStatsModel;

  factory AdminDiscountStatsModel.fromJson(Map<String, dynamic> json) =>
      _$AdminDiscountStatsModelFromJson(json);
}

@freezed
class DiscountTypeDistributionModel with _$DiscountTypeDistributionModel {
  const factory DiscountTypeDistributionModel({
    required String type,
    required int total,
    required double percentage,
  }) = _DiscountTypeDistributionModel;

  factory DiscountTypeDistributionModel.fromJson(Map<String, dynamic> json) =>
      _$DiscountTypeDistributionModelFromJson(json);
}

@freezed
class TopDiscountModel with _$TopDiscountModel {
  const factory TopDiscountModel({
    required int discountId,
    required String code,
    required int usageCount,
  }) = _TopDiscountModel;

  factory TopDiscountModel.fromJson(Map<String, dynamic> json) =>
      _$TopDiscountModelFromJson(json);
}

extension AdminDiscountStatsModelMapper on AdminDiscountStatsModel {
  AdminDiscountStats toEntity() => AdminDiscountStats(
        totalDiscounts: totalDiscounts,
        activeDiscounts: activeDiscounts,
        expiredDiscounts: expiredDiscounts,
        typeDistribution: typeDistribution.map((e) => e.toEntity()).toList(),
        topDiscounts: topDiscounts.map((e) => e.toEntity()).toList(),
      );
}

extension DiscountTypeDistributionModelMapper on DiscountTypeDistributionModel {
  DiscountTypeDistribution toEntity() => DiscountTypeDistribution(
        type: type,
        total: total,
        percentage: percentage,
      );
}

extension TopDiscountModelMapper on TopDiscountModel {
  TopDiscount toEntity() => TopDiscount(
        discountId: discountId,
        code: code,
        usageCount: usageCount,
      );
}
