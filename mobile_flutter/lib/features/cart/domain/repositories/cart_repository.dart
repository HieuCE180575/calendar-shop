import '../entities/cart_item.dart';

/// Hợp đồng nghiệp vụ giỏ hàng ở tầng Domain.
/// Định nghĩa các hành vi nghiệp vụ mà Frontend cần sử dụng.
abstract class CartRepository {
  /// Lấy danh sách sản phẩm trong giỏ hàng của người dùng hiện tại
  Future<List<CartItemEntity>> getCart();

  /// Thêm một sản phẩm với số lượng cụ thể vào giỏ hàng
  Future<void> addToCart(int productId, int quantity);

  /// Cập nhật số lượng hoặc trạng thái tích chọn của một sản phẩm trong giỏ
  Future<void> updateCartItem(int cartItemId, int quantity, bool isSelected);

  /// Xóa bỏ hoàn toàn một sản phẩm ra khỏi giỏ hàng
  Future<void> deleteCartItem(int cartItemId);
}
