import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/admin_product_stats.dart';

part 'admin_product_stats_model.freezed.dart';
part 'admin_product_stats_model.g.dart';

@freezed
class AdminProductStatsModel with _$AdminProductStatsModel {
  const factory AdminProductStatsModel({
    required int totalProducts,
    @Default(0.0) double totalProductsGrowth,
    required int inBusiness,
    @Default(0.0) double inBusinessGrowth,
    required int lowStock,
    required int totalCategories,
    required List<ProductBestSellingModel> bestSelling,
    required List<CategoryStockDistributionModel> stockByCategory,
    required List<ProductLowStockModel> lowStockProducts,
  }) = _AdminProductStatsModel;

  factory AdminProductStatsModel.fromJson(Map<String, dynamic> json) =>
      _$AdminProductStatsModelFromJson(json);
}

@freezed
class ProductBestSellingModel with _$ProductBestSellingModel {
  const factory ProductBestSellingModel({
    required int productId,
    required String productName,
    required int totalSold,
  }) = _ProductBestSellingModel;

  factory ProductBestSellingModel.fromJson(Map<String, dynamic> json) =>
      _$ProductBestSellingModelFromJson(json);
}

@freezed
class CategoryStockDistributionModel with _$CategoryStockDistributionModel {
  const factory CategoryStockDistributionModel({
    required String categoryName,
    required int totalStock,
    required double percentage,
  }) = _CategoryStockDistributionModel;

  factory CategoryStockDistributionModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryStockDistributionModelFromJson(json);
}

@freezed
class ProductLowStockModel with _$ProductLowStockModel {
  const factory ProductLowStockModel({
    required int productId,
    required String productName,
    required int stockQuantity,
  }) = _ProductLowStockModel;

  factory ProductLowStockModel.fromJson(Map<String, dynamic> json) =>
      _$ProductLowStockModelFromJson(json);
}

extension AdminProductStatsModelMapper on AdminProductStatsModel {
  AdminProductStats toEntity() => AdminProductStats(
        totalProducts: totalProducts,
        totalProductsGrowth: totalProductsGrowth,
        inBusiness: inBusiness,
        inBusinessGrowth: inBusinessGrowth,
        lowStock: lowStock,
        totalCategories: totalCategories,
        bestSelling: bestSelling.map((e) => e.toEntity()).toList(),
        stockByCategory: stockByCategory.map((e) => e.toEntity()).toList(),
        lowStockProducts: lowStockProducts.map((e) => e.toEntity()).toList(),
      );
}

extension ProductBestSellingModelMapper on ProductBestSellingModel {
  ProductBestSelling toEntity() => ProductBestSelling(
        productId: productId,
        productName: productName,
        totalSold: totalSold,
      );
}

extension CategoryStockDistributionModelMapper on CategoryStockDistributionModel {
  CategoryStockDistribution toEntity() => CategoryStockDistribution(
        categoryName: categoryName,
        totalStock: totalStock,
        percentage: percentage,
      );
}

extension ProductLowStockModelMapper on ProductLowStockModel {
  ProductLowStock toEntity() => ProductLowStock(
        productId: productId,
        productName: productName,
        stockQuantity: stockQuantity,
      );
}
