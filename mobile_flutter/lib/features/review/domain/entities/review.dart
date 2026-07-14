import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';

@freezed
class Review with _$Review {
  const factory Review({
    required int reviewId,
    required int userId,
    required String userFullName,
    String? userAvatarUrl,
    required int productId,
    required String productName,
    required int orderItemId,
    required int rating,
    String? comment,
    required String status,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Review;
}
