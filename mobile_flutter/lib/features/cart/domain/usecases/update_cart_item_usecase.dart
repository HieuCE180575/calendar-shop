import '../repositories/cart_repository.dart';

/// Use Case chịu trách nhiệm cập nhật số lượng hoặc tích chọn của sản phẩm trong giỏ hàng.
class UpdateCartItemUseCase {
  final CartRepository repository;

  UpdateCartItemUseCase(this.repository);

  /// Thực thi cập nhật sản phẩm trong giỏ hàng
  Future<void> call({
    required int cartItemId,
    required int quantity,
    required bool isSelected,
  }) {
    return repository.updateCartItem(cartItemId, quantity, isSelected);
  }
}
