import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/cart_item_model.dart';

/// Lớp chịu trách nhiệm gọi các API thô liên quan đến giỏ hàng từ Server.
class CartRemoteDataSource {
  final ApiClient apiClient;

  CartRemoteDataSource(this.apiClient);

  /// Lấy danh sách sản phẩm trong giỏ hàng (API dạng OData)
  Future<List<CartItemModel>> getCart() async {
    try {
      // Gọi HTTP GET /api/cart
      final response = await apiClient.dio.get(ApiConstants.cart);

      // Vì OData bọc danh sách trong thuộc tính "value", ta cần bóc tách dữ liệu
      final List dataList;
      if (response.data is Map && (response.data as Map).containsKey('value')) {
        dataList = response.data['value'] as List;
      } else if (response.data is List) {
        dataList = response.data as List;
      } else {
        dataList = [];
      }

      // Map từng phần tử JSON sang CartItemModel DTO
      return dataList.map((e) => CartItemModel.fromJson(e)).toList();
    } catch (e) {
      // Chuyển đổi và ném ra lỗi chuẩn hóa RFC 7807
      throw apiClient.handleError(e);
    }
  }

  /// Thêm một sản phẩm vào giỏ hàng
  Future<void> addToCart(int productId, int quantity) async {
    try {
      await apiClient.dio.post(ApiConstants.cart, data: {
        'productId': productId,
        'quantity': quantity,
      });
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  /// Cập nhật số lượng và tích chọn của sản phẩm trong giỏ hàng
  Future<void> updateCartItem(int cartItemId, int quantity, bool isSelected) async {
    try {
      await apiClient.dio.put('${ApiConstants.cart}/$cartItemId', data: {
        'quantity': quantity,
        'isSelected': isSelected,
      });
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  /// Xóa sản phẩm khỏi giỏ hàng
  Future<void> deleteCartItem(int cartItemId) async {
    try {
      await apiClient.dio.delete('${ApiConstants.cart}/$cartItemId');
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }
}
