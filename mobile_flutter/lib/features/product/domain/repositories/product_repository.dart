import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({
    int? categoryId,
    String? search,
    double? minPrice,
    double? maxPrice,
    String? calendarType,
    String sort,
  });

  Future<Product> getProductById(int id);
}
