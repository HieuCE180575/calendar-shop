import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

/// Use Case chịu trách nhiệm lấy danh sách sản phẩm trong giỏ hàng.
class GetCartUseCase {
  final CartRepository repository;

  GetCartUseCase(this.repository);

  /// Hàm call để thực thi Use Case
  Future<List<CartItemEntity>> call() {
    return repository.getCart();
  }
}
