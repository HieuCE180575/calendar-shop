import '../repositories/product_repository.dart';

class UpdateProductUseCase {
  final ProductRepository repository;

  UpdateProductUseCase(this.repository);

  Future<void> call(
    int id, {
    required int categoryId,
    required String productName,
    String? description,
    required double price,
    required int stockQuantity,
    String? imageUrl,
    required String calendarType,
    required String status,
  }) {
    return repository.updateProduct(
      id,
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
