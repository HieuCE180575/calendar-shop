class Product {
  final int productId;
  final int categoryId;
  final String? categoryName;
  final String productName;
  final String? description;
  final double price;
  final int stockQuantity;
  final String? imageUrl;
  final String calendarType;
  final String status;
  final DateTime createdAt;

  const Product({
    required this.productId,
    required this.categoryId,
    this.categoryName,
    required this.productName,
    this.description,
    required this.price,
    required this.stockQuantity,
    this.imageUrl,
    required this.calendarType,
    required this.status,
    required this.createdAt,
  });
}
