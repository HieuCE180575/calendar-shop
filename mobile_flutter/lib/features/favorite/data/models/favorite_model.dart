import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/favorite.dart';

part 'favorite_model.freezed.dart';
part 'favorite_model.g.dart';

@freezed
class FavoriteModel with _$FavoriteModel {
  const factory FavoriteModel({
    required int favoriteId,
    required int productId,
    required String productName,
    String? imageUrl,
    required double price,
    required String calendarType,
    required String productStatus,
    required DateTime createdAt,
  }) = _FavoriteModel;

  factory FavoriteModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteModelFromJson(json);
}

extension FavoriteModelMapper on FavoriteModel {
  Favorite toEntity() => Favorite(
        favoriteId: favoriteId,
        productId: productId,
        productName: productName,
        imageUrl: imageUrl,
        price: price,
        calendarType: calendarType,
        productStatus: productStatus,
        createdAt: createdAt,
      );
}
