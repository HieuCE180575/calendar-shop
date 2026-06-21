import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/cart_item.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

@freezed
class CartItemModel with _$CartItemModel {
  const factory CartItemModel({
    required int cartItemId,
    required int productId,
    required String productName,
    String? imageUrl,
    required double price,
    required int quantity,
    required int stockQuantity,
    required bool isSelected,
    required double lineTotal,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);
}

extension CartItemModelMapper on CartItemModel {
  CartItemEntity toEntity() => CartItemEntity(
        cartItemId: cartItemId,
        productId: productId,
        productName: productName,
        imageUrl: imageUrl,
        price: price,
        quantity: quantity,
        stockQuantity: stockQuantity,
        isSelected: isSelected,
        lineTotal: lineTotal,
      );
}
