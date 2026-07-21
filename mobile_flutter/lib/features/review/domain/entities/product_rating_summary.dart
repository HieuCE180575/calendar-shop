import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_rating_summary.freezed.dart';

@freezed
class ProductRatingSummary with _$ProductRatingSummary {
  const factory ProductRatingSummary({
    required int productId,
    required double averageRating,
    required int totalReviews,
    required int star1,
    required int star2,
    required int star3,
    required int star4,
    required int star5,
  }) = _ProductRatingSummary;
}
