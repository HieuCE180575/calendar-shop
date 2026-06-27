// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cartRemoteDataSourceHash() =>
    r'67347ec7dd143ed3c7511aedfb552c8fb74b3a24';

/// Provider khởi tạo và cung cấp CartRemoteDataSource
///
/// Copied from [cartRemoteDataSource].
@ProviderFor(cartRemoteDataSource)
final cartRemoteDataSourceProvider =
    AutoDisposeProvider<CartRemoteDataSource>.internal(
  cartRemoteDataSource,
  name: r'cartRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cartRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CartRemoteDataSourceRef = AutoDisposeProviderRef<CartRemoteDataSource>;
String _$cartRepositoryHash() => r'883d0cf6b9ea713a69dc0d3666a9a672bbee615e';

/// Provider khởi tạo và cung cấp CartRepository
///
/// Copied from [cartRepository].
@ProviderFor(cartRepository)
final cartRepositoryProvider = AutoDisposeProvider<CartRepository>.internal(
  cartRepository,
  name: r'cartRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cartRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CartRepositoryRef = AutoDisposeProviderRef<CartRepository>;
String _$getCartUseCaseHash() => r'3fc7450ce31d5780d7d156e3aea7fff7f32dc262';

/// Provider cung cấp GetCartUseCase
///
/// Copied from [getCartUseCase].
@ProviderFor(getCartUseCase)
final getCartUseCaseProvider = AutoDisposeProvider<GetCartUseCase>.internal(
  getCartUseCase,
  name: r'getCartUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getCartUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetCartUseCaseRef = AutoDisposeProviderRef<GetCartUseCase>;
String _$addToCartUseCaseHash() => r'dda555d8316281d745d6d80b03d7842f16528a59';

/// Provider cung cấp AddToCartUseCase
///
/// Copied from [addToCartUseCase].
@ProviderFor(addToCartUseCase)
final addToCartUseCaseProvider = AutoDisposeProvider<AddToCartUseCase>.internal(
  addToCartUseCase,
  name: r'addToCartUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$addToCartUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AddToCartUseCaseRef = AutoDisposeProviderRef<AddToCartUseCase>;
String _$updateCartItemUseCaseHash() =>
    r'37eeb0634c1bab31a1a292c6c68189bffdb717e6';

/// Provider cung cấp UpdateCartItemUseCase
///
/// Copied from [updateCartItemUseCase].
@ProviderFor(updateCartItemUseCase)
final updateCartItemUseCaseProvider =
    AutoDisposeProvider<UpdateCartItemUseCase>.internal(
  updateCartItemUseCase,
  name: r'updateCartItemUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateCartItemUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UpdateCartItemUseCaseRef
    = AutoDisposeProviderRef<UpdateCartItemUseCase>;
String _$deleteCartItemUseCaseHash() =>
    r'dac2758ca2ae830de48456cd1b0260cc655e81a3';

/// Provider cung cấp DeleteCartItemUseCase
///
/// Copied from [deleteCartItemUseCase].
@ProviderFor(deleteCartItemUseCase)
final deleteCartItemUseCaseProvider =
    AutoDisposeProvider<DeleteCartItemUseCase>.internal(
  deleteCartItemUseCase,
  name: r'deleteCartItemUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$deleteCartItemUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DeleteCartItemUseCaseRef
    = AutoDisposeProviderRef<DeleteCartItemUseCase>;
String _$cartTotalHash() => r'17545141846f4cc045c2b42562ed2d334addc6dc';

/// Provider tính toán tổng tiền động từ danh sách giỏ hàng (chỉ cộng các item được tích chọn)
///
/// Copied from [cartTotal].
@ProviderFor(cartTotal)
final cartTotalProvider = AutoDisposeProvider<double>.internal(
  cartTotal,
  name: r'cartTotalProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$cartTotalHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CartTotalRef = AutoDisposeProviderRef<double>;
String _$cartHash() => r'9bace389956d253bf9080221d54376a615bfc6be';

/// Notifier quản lý danh sách giỏ hàng bất đồng bộ
///
/// Copied from [Cart].
@ProviderFor(Cart)
final cartProvider =
    AutoDisposeAsyncNotifierProvider<Cart, List<CartItemEntity>>.internal(
  Cart.new,
  name: r'cartProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$cartHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Cart = AutoDisposeAsyncNotifier<List<CartItemEntity>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
