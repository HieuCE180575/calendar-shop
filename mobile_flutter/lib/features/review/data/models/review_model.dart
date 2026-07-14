import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/review.dart';

part 'review_model.freezed.dart';
part 'review_model.g.dart';

@freezed
class ReviewModel with _$ReviewModel {
  const factory ReviewModel({
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
  }) = _ReviewModel;

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);
}

extension ReviewModelMapper on ReviewModel {
  Review toEntity() => Review(
        reviewId: reviewId,
        userId: userId,
        userFullName: userFullName,
        userAvatarUrl: userAvatarUrl,
        productId: productId,
        productName: productName,
        orderItemId: orderItemId,
        rating: rating,
        comment: comment,
        status: status,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
