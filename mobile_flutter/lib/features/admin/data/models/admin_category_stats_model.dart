import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/admin_category_stats.dart';

part 'admin_category_stats_model.freezed.dart';
part 'admin_category_stats_model.g.dart';

@freezed
class AdminCategoryStatsModel with _$AdminCategoryStatsModel {
  const factory AdminCategoryStatsModel({
    required int totalCategories,
    required int activeCategories,
    required int hiddenCategories,
    required List<CategoryProductDistributionModel> productDistribution,
  }) = _AdminCategoryStatsModel;

  factory AdminCategoryStatsModel.fromJson(Map<String, dynamic> json) =>
      _$AdminCategoryStatsModelFromJson(json);
}

@freezed
class CategoryProductDistributionModel with _$CategoryProductDistributionModel {
  const factory CategoryProductDistributionModel({
    required String categoryName,
    required int productCount,
    required double percentage,
  }) = _CategoryProductDistributionModel;

  factory CategoryProductDistributionModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryProductDistributionModelFromJson(json);
}

extension AdminCategoryStatsModelMapper on AdminCategoryStatsModel {
  AdminCategoryStats toEntity() => AdminCategoryStats(
        totalCategories: totalCategories,
        activeCategories: activeCategories,
        hiddenCategories: hiddenCategories,
        productDistribution: productDistribution.map((e) => e.toEntity()).toList(),
      );
}

extension CategoryProductDistributionModelMapper on CategoryProductDistributionModel {
  CategoryProductDistribution toEntity() => CategoryProductDistribution(
        categoryName: categoryName,
        productCount: productCount,
        percentage: percentage,
      );
}
