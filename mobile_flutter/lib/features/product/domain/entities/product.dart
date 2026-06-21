import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required int productId,
    required int categoryId,
    String? categoryName,
    required String productName,
    String? description,
    required double price,
    required int stockQuantity,
    String? imageUrl,
    required String calendarType,
    required String status,
    required DateTime createdAt,
  }) = _Product;
}
