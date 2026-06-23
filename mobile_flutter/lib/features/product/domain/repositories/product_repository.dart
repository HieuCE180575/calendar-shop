import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({
    int? categoryId,
    String? search,
    double? minPrice,
    double? maxPrice,
    String? calendarType,
    String sort,
    bool includeHidden = false,
    int? top,
    int? skip,
  });

  Future<Product> getProductById(int id);

  Future<Product> createProduct({
    required int categoryId,
    required String productName,
    String? description,
    required double price,
    required int stockQuantity,
    String? imageUrl,
    required String calendarType,
    required String status,
  });

  Future<void> updateProduct(
    int id, {
    required int categoryId,
    required String productName,
    String? description,
    required double price,
    required int stockQuantity,
    String? imageUrl,
    required String calendarType,
    required String status,
  });

  Future<void> deleteProduct(int id);
}
