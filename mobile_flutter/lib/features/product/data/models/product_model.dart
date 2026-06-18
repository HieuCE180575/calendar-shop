import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.productId,
    required super.categoryId,
    super.categoryName,
    required super.productName,
    super.description,
    required super.price,
    required super.stockQuantity,
    super.imageUrl,
    required super.calendarType,
    required super.status,
    required super.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['productId'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      productName: json['productName'] ?? '',
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      stockQuantity: json['stockQuantity'] ?? 0,
      imageUrl: json['imageUrl'],
      calendarType: json['calendarType'] ?? '',
      status: json['status'] ?? 'Active',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
