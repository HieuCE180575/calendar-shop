import '../repositories/cart_repository.dart';

/// Use Case chịu trách nhiệm thêm sản phẩm vào giỏ hàng.
class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  /// Thực thi thêm sản phẩm vào giỏ hàng
  Future<void> call(int productId, int quantity) {
    return repository.addToCart(productId, quantity);
  }
}
