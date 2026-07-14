import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/cart_remote_datasource.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/update_cart_item_usecase.dart';
import '../../domain/usecases/delete_cart_item_usecase.dart';
import '../../domain/entities/cart_item.dart';

part 'cart_provider.g.dart';

/// Provider khởi tạo và cung cấp CartRemoteDataSource
@riverpod
CartRemoteDataSource cartRemoteDataSource(CartRemoteDataSourceRef ref) {
  return CartRemoteDataSource(ref.watch(apiClientProvider));
}

/// Provider khởi tạo và cung cấp CartRepository
@riverpod
CartRepository cartRepository(CartRepositoryRef ref) {
  return CartRepositoryImpl(ref.watch(cartRemoteDataSourceProvider));
}

/// Provider cung cấp GetCartUseCase
@riverpod
GetCartUseCase getCartUseCase(GetCartUseCaseRef ref) {
  return GetCartUseCase(ref.watch(cartRepositoryProvider));
}

/// Provider cung cấp AddToCartUseCase
@riverpod
AddToCartUseCase addToCartUseCase(AddToCartUseCaseRef ref) {
  return AddToCartUseCase(ref.watch(cartRepositoryProvider));
}

/// Provider cung cấp UpdateCartItemUseCase
@riverpod
UpdateCartItemUseCase updateCartItemUseCase(UpdateCartItemUseCaseRef ref) {
  return UpdateCartItemUseCase(ref.watch(cartRepositoryProvider));
}

/// Provider cung cấp DeleteCartItemUseCase
@riverpod
DeleteCartItemUseCase deleteCartItemUseCase(DeleteCartItemUseCaseRef ref) {
  return DeleteCartItemUseCase(ref.watch(cartRepositoryProvider));
}

/// Notifier quản lý danh sách giỏ hàng bất đồng bộ
@riverpod
class Cart extends _$Cart {
  @override
  FutureOr<List<CartItemEntity>> build() {
    // Thực thi Use Case lấy danh sách giỏ hàng khi khởi tạo
    return ref.watch(getCartUseCaseProvider)();
  }

  /// Tăng/giảm số lượng sản phẩm (Optimistic Update)
  Future<void> updateQuantity(int cartItemId, int newQuantity, bool isSelected) async {
    final previousState = state;
    if (state.hasValue) {
      // Cập nhật UI ngay lập tức để người dùng thấy mượt mà
      final updatedList = state.value!.map((item) {
        if (item.cartItemId == cartItemId) {
          return item.copyWith(
            quantity: newQuantity,
            lineTotal: item.price * newQuantity,
          );
        }
        return item;
      }).toList();
      state = AsyncValue.data(updatedList);
    }

    try {
      // Gọi Use Case cập nhật lên Server
      await ref.read(updateCartItemUseCaseProvider)(
        cartItemId: cartItemId,
        quantity: newQuantity,
        isSelected: isSelected,
      );
    } catch (e) {
      // Rollback về trạng thái cũ nếu server báo lỗi
      state = previousState;
      rethrow;
    }
  }

  /// Tích chọn/Bỏ chọn sản phẩm mua (Optimistic Update)
  Future<void> toggleSelect(int cartItemId, bool isSelected, int quantity) async {
    final previousState = state;
    if (state.hasValue) {
      final updatedList = state.value!.map((item) {
        if (item.cartItemId == cartItemId) {
          return item.copyWith(isSelected: isSelected);
        }
        return item;
      }).toList();
      state = AsyncValue.data(updatedList);
    }

    try {
      await ref.read(updateCartItemUseCaseProvider)(
        cartItemId: cartItemId,
        quantity: quantity,
        isSelected: isSelected,
      );
    } catch (e) {
      state = previousState;
      rethrow;
    }
  }

  /// Xóa sản phẩm khỏi giỏ hàng
  Future<void> removeItem(int cartItemId) async {
    final previousState = state;
    if (state.hasValue) {
      state = AsyncValue.data(
        state.value!.where((item) => item.cartItemId != cartItemId).toList(),
      );
    }

    try {
      await ref.read(deleteCartItemUseCaseProvider)(cartItemId);
    } catch (e) {
      state = previousState;
      rethrow;
    }
  }

  /// Thêm một sản phẩm vào giỏ hàng
  Future<void> addItem(int productId, int quantity) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(addToCartUseCaseProvider)(productId, quantity);
      ref.invalidateSelf(); // Buộc Provider reload lại danh sách mới
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Provider tính toán tổng tiền động từ danh sách giỏ hàng (chỉ cộng các item được tích chọn)
@riverpod
double cartTotal(CartTotalRef ref) {
  final cartState = ref.watch(cartProvider);
  return cartState.maybeWhen(
    data: (items) => items
        .where((item) => item.isSelected)
        .fold(0.0, (sum, item) => sum + item.lineTotal),
    orElse: () => 0.0,
  );
}
