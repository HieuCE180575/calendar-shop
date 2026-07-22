import '../../domain/entities/cart_item.dart';
import '../../domain/entities/checked_coupon.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_datasource.dart';

/// Lớp triển khai (implementation) của CartRepository ở tầng Domain.
/// Chịu trách nhiệm gọi nguồn dữ liệu (Data Source) và chuyển đổi Model DTO thành Entity sạch.
class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CartItemEntity>> getCart() async {
    // 1. Gọi remote datasource để lấy danh sách DTO models
    final models = await remoteDataSource.getCart();

    // 2. Map từng Model DTO thô thành Entity sạch để UI sử dụng
    return models
        .map(
          (model) => CartItemEntity(
            cartItemId: model.cartItemId,
            productId: model.productId,
            productName: model.productName,
            imageUrl: model.imageUrl,
            price: model.price,
            quantity: model.quantity,
            stockQuantity: model.stockQuantity,
            isSelected: model.isSelected,
            lineTotal: model.lineTotal,
          ),
        )
        .toList();
  }

  @override
  Future<void> addToCart(int productId, int quantity) {
    return remoteDataSource.addToCart(productId, quantity);
  }

  @override
  Future<void> updateCartItem(int cartItemId, int quantity, bool isSelected) {
    return remoteDataSource.updateCartItem(cartItemId, quantity, isSelected);
  }

  @override
  Future<void> deleteCartItem(int cartItemId) {
    return remoteDataSource.deleteCartItem(cartItemId);
  }

  @override
  Future<CheckedCoupon> checkCoupon(String code, double subTotal) async {
    final model = await remoteDataSource.checkCoupon(code, subTotal);
    return model.toEntity();
  }
}
