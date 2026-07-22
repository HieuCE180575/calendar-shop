import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_discount_stats.freezed.dart';

@freezed
class AdminDiscountStats with _$AdminDiscountStats {
  const factory AdminDiscountStats({
    @Default(0) int totalDiscounts,
    @Default(0) int activeDiscounts,
    @Default(0) int expiredDiscounts,
    @Default([]) List<DiscountTypeDistribution> typeDistribution,
    @Default([]) List<TopDiscount> topDiscounts,
  }) = _AdminDiscountStats;
}

@freezed
class DiscountTypeDistribution with _$DiscountTypeDistribution {
  const factory DiscountTypeDistribution({
    @Default('') String type,
    @Default(0) int total,
    @Default(0.0) double percentage,
  }) = _DiscountTypeDistribution;
}

@freezed
class TopDiscount with _$TopDiscount {
  const factory TopDiscount({
    @Default(0) int discountId,
    @Default('') String code,
    @Default(0) int usageCount,
  }) = _TopDiscount;
}
