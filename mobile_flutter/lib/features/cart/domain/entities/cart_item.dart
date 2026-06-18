class CartItemEntity {
  final int cartItemId;
  final int productId;
  final String productName;
  final String? imageUrl;
  final double price;
  final int quantity;
  final int stockQuantity;
  final bool isSelected;
  final double lineTotal;

  const CartItemEntity({
    required this.cartItemId,
    required this.productId,
    required this.productName,
    this.imageUrl,
    required this.price,
    required this.quantity,
    required this.stockQuantity,
    required this.isSelected,
    required this.lineTotal,
  });
}
