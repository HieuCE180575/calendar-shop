import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/product_rating_summary.dart';

part 'product_rating_summary_model.freezed.dart';
part 'product_rating_summary_model.g.dart';

@freezed
class ProductRatingSummaryModel with _$ProductRatingSummaryModel {
  const factory ProductRatingSummaryModel({
    required int productId,
    required double averageRating,
    required int totalReviews,
    required int star1,
    required int star2,
    required int star3,
    required int star4,
    required int star5,
  }) = _ProductRatingSummaryModel;

  factory ProductRatingSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$ProductRatingSummaryModelFromJson(json);
}

extension ProductRatingSummaryModelMapper on ProductRatingSummaryModel {
  ProductRatingSummary toEntity() => ProductRatingSummary(
        productId: productId,
        averageRating: averageRating,
        totalReviews: totalReviews,
        star1: star1,
        star2: star2,
        star3: star3,
        star4: star4,
        star5: star5,
      );
}
