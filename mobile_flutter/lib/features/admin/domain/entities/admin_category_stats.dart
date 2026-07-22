import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_category_stats.freezed.dart';

@freezed
class AdminCategoryStats with _$AdminCategoryStats {
  const factory AdminCategoryStats({
    @Default(0) int totalCategories,
    @Default(0) int activeCategories,
    @Default(0) int hiddenCategories,
    @Default([]) List<CategoryProductDistribution> productDistribution,
  }) = _AdminCategoryStats;
}

@freezed
class CategoryProductDistribution with _$CategoryProductDistribution {
  const factory CategoryProductDistribution({
    @Default('') String categoryName,
    @Default(0) int productCount,
    @Default(0.0) double percentage,
  }) = _CategoryProductDistribution;
}
