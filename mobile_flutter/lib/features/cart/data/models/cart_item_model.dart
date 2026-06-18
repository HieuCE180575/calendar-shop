import '../../domain/entities/cart_item.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.cartItemId,
    required super.productId,
    required super.productName,
    super.imageUrl,
    required super.price,
    required super.quantity,
    required super.stockQuantity,
    required super.isSelected,
    required super.lineTotal,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      cartItemId: json['cartItemId'],
      productId: json['productId'],
      productName: json['productName'] ?? '',
      imageUrl: json['imageUrl'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      stockQuantity: json['stockQuantity'],
      isSelected: json['isSelected'],
      lineTotal: (json['lineTotal'] as num).toDouble(),
    );
  }
}
