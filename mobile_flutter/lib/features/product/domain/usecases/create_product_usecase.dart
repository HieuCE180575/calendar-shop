import '../entities/product.dart';
import '../repositories/product_repository.dart';

class CreateProductUseCase {
  final ProductRepository repository;

  CreateProductUseCase(this.repository);

  Future<Product> call({
    required int categoryId,
    required String productName,
    String? description,
    required double price,
    required int stockQuantity,
    String? imageUrl,
    required String calendarType,
    required String status,
  }) {
    return repository.createProduct(
      categoryId: categoryId,
      productName: productName,
      description: description,
      price: price,
      stockQuantity: stockQuantity,
      imageUrl: imageUrl,
      calendarType: calendarType,
      status: status,
    );
  }
}
