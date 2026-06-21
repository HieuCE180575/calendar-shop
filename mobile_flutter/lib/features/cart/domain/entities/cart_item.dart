import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item.freezed.dart';

@freezed
class CartItemEntity with _$CartItemEntity {
  const factory CartItemEntity({
    required int cartItemId,
    required int productId,
    required String productName,
    String? imageUrl,
    required double price,
    required int quantity,
    required int stockQuantity,
    required bool isSelected,
    required double lineTotal,
  }) = _CartItemEntity;
}
