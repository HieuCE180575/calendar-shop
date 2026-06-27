import '../repositories/cart_repository.dart';

/// Use Case chịu trách nhiệm xóa sản phẩm khỏi giỏ hàng.
class DeleteCartItemUseCase {
  final CartRepository repository;

  DeleteCartItemUseCase(this.repository);

  /// Thực thi xóa sản phẩm khỏi giỏ hàng
  Future<void> call(int cartItemId) {
    return repository.deleteCartItem(cartItemId);
  }
}
