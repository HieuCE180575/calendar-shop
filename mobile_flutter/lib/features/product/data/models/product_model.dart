import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/product.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
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
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}

extension ProductModelMapper on ProductModel {
  Product toEntity() => Product(
        productId: productId,
        categoryId: categoryId,
        categoryName: categoryName,
        productName: productName,
        description: description,
        price: price,
        stockQuantity: stockQuantity,
        imageUrl: imageUrl,
        calendarType: calendarType,
        status: status,
        createdAt: createdAt,
      );
}
