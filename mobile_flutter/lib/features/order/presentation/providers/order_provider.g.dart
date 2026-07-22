// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$orderRemoteDataSourceHash() =>
    r'e4631a895194d2a40c472c241f00e7e5cc8f0bdd';

/// Provider khởi tạo và cung cấp OrderRemoteDataSource
///
/// Copied from [orderRemoteDataSource].
@ProviderFor(orderRemoteDataSource)
final orderRemoteDataSourceProvider =
    AutoDisposeProvider<OrderRemoteDataSource>.internal(
  orderRemoteDataSource,
  name: r'orderRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$orderRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef OrderRemoteDataSourceRef
    = AutoDisposeProviderRef<OrderRemoteDataSource>;
String _$orderRepositoryHash() => r'77c8b92481f0b42f91837683ebded09a97aa5bca';

/// Provider khởi tạo và cung cấp OrderRepository
///
/// Copied from [orderRepository].
@ProviderFor(orderRepository)
final orderRepositoryProvider = AutoDisposeProvider<OrderRepository>.internal(
  orderRepository,
  name: r'orderRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$orderRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef OrderRepositoryRef = AutoDisposeProviderRef<OrderRepository>;
String _$getMyOrdersUseCaseHash() =>
    r'cb5a84d5b373c9be06813f4f2b7fe22d40c91cf2';

/// Provider cung cấp GetMyOrdersUseCase
///
/// Copied from [getMyOrdersUseCase].
@ProviderFor(getMyOrdersUseCase)
final getMyOrdersUseCaseProvider =
    AutoDisposeProvider<GetMyOrdersUseCase>.internal(
  getMyOrdersUseCase,
  name: r'getMyOrdersUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getMyOrdersUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetMyOrdersUseCaseRef = AutoDisposeProviderRef<GetMyOrdersUseCase>;
String _$getOrderDetailUseCaseHash() =>
    r'f6c6575732df64b563ac93333738ae9ec2095dbe';

/// Provider cung cấp GetOrderDetailUseCase
///
/// Copied from [getOrderDetailUseCase].
@ProviderFor(getOrderDetailUseCase)
final getOrderDetailUseCaseProvider =
    AutoDisposeProvider<GetOrderDetailUseCase>.internal(
  getOrderDetailUseCase,
  name: r'getOrderDetailUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getOrderDetailUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetOrderDetailUseCaseRef
    = AutoDisposeProviderRef<GetOrderDetailUseCase>;
String _$cancelOrderUseCaseHash() =>
    r'fc8e6c04fa5848b664838936c853e31111f1d68c';

/// Provider cung cấp CancelOrderUseCase
///
/// Copied from [cancelOrderUseCase].
@ProviderFor(cancelOrderUseCase)
final cancelOrderUseCaseProvider =
    AutoDisposeProvider<CancelOrderUseCase>.internal(
  cancelOrderUseCase,
  name: r'cancelOrderUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cancelOrderUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CancelOrderUseCaseRef = AutoDisposeProviderRef<CancelOrderUseCase>;
String _$createOrderUseCaseHash() =>
    r'a1c7acef69597a6882cd522de1f6837807b710c8';

/// Provider cung cấp CreateOrderUseCase
///
/// Copied from [createOrderUseCase].
@ProviderFor(createOrderUseCase)
final createOrderUseCaseProvider =
    AutoDisposeProvider<CreateOrderUseCase>.internal(
  createOrderUseCase,
  name: r'createOrderUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createOrderUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CreateOrderUseCaseRef = AutoDisposeProviderRef<CreateOrderUseCase>;
String _$getVNPayUrlUseCaseHash() =>
    r'09abf79dd62fb503f5c39f953ac0ce7508be9a9c';

/// Provider cung cấp GetVNPayUrlUseCase
///
/// Copied from [getVNPayUrlUseCase].
@ProviderFor(getVNPayUrlUseCase)
final getVNPayUrlUseCaseProvider =
    AutoDisposeProvider<GetVNPayUrlUseCase>.internal(
  getVNPayUrlUseCase,
  name: r'getVNPayUrlUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getVNPayUrlUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetVNPayUrlUseCaseRef = AutoDisposeProviderRef<GetVNPayUrlUseCase>;
String _$reorderUseCaseHash() => r'd7e8d7056e7d0aa9bed42dfaed84f8466c35f031';

/// See also [reorderUseCase].
@ProviderFor(reorderUseCase)
final reorderUseCaseProvider = AutoDisposeProvider<ReorderUseCase>.internal(
  reorderUseCase,
  name: r'reorderUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reorderUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ReorderUseCaseRef = AutoDisposeProviderRef<ReorderUseCase>;
String _$myOrdersHash() => r'd627e2bfb5b07a475893e1f1c7e824724f3bf272';

/// Notifier quản lý danh sách đơn hàng bất đồng bộ
///
/// Copied from [MyOrders].
@ProviderFor(MyOrders)
final myOrdersProvider =
    AutoDisposeAsyncNotifierProvider<MyOrders, List<OrderEntity>>.internal(
  MyOrders.new,
  name: r'myOrdersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$myOrdersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MyOrders = AutoDisposeAsyncNotifier<List<OrderEntity>>;
String _$orderDetailHash() => r'882bc06f97ea53943d0c9f7a477a5e1a10dcea46';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$OrderDetail
    extends BuildlessAutoDisposeAsyncNotifier<OrderEntity> {
  late final int orderId;

  FutureOr<OrderEntity> build(
    int orderId,
  );
}

/// Notifier quản lý chi tiết đơn hàng bất đồng bộ
///
/// Copied from [OrderDetail].
@ProviderFor(OrderDetail)
const orderDetailProvider = OrderDetailFamily();

/// Notifier quản lý chi tiết đơn hàng bất đồng bộ
///
/// Copied from [OrderDetail].
class OrderDetailFamily extends Family<AsyncValue<OrderEntity>> {
  /// Notifier quản lý chi tiết đơn hàng bất đồng bộ
  ///
  /// Copied from [OrderDetail].
  const OrderDetailFamily();

  /// Notifier quản lý chi tiết đơn hàng bất đồng bộ
  ///
  /// Copied from [OrderDetail].
  OrderDetailProvider call(
    int orderId,
  ) {
    return OrderDetailProvider(
      orderId,
    );
  }

  @override
  OrderDetailProvider getProviderOverride(
    covariant OrderDetailProvider provider,
  ) {
    return call(
      provider.orderId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'orderDetailProvider';
}

/// Notifier quản lý chi tiết đơn hàng bất đồng bộ
///
/// Copied from [OrderDetail].
class OrderDetailProvider
    extends AutoDisposeAsyncNotifierProviderImpl<OrderDetail, OrderEntity> {
  /// Notifier quản lý chi tiết đơn hàng bất đồng bộ
  ///
  /// Copied from [OrderDetail].
  OrderDetailProvider(
    int orderId,
  ) : this._internal(
          () => OrderDetail()..orderId = orderId,
          from: orderDetailProvider,
          name: r'orderDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$orderDetailHash,
          dependencies: OrderDetailFamily._dependencies,
          allTransitiveDependencies:
              OrderDetailFamily._allTransitiveDependencies,
          orderId: orderId,
        );

  OrderDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.orderId,
  }) : super.internal();

  final int orderId;

  @override
  FutureOr<OrderEntity> runNotifierBuild(
    covariant OrderDetail notifier,
  ) {
    return notifier.build(
      orderId,
    );
  }

  @override
  Override overrideWith(OrderDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: OrderDetailProvider._internal(
        () => create()..orderId = orderId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        orderId: orderId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<OrderDetail, OrderEntity>
      createElement() {
    return _OrderDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderDetailProvider && other.orderId == orderId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, orderId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin OrderDetailRef on AutoDisposeAsyncNotifierProviderRef<OrderEntity> {
  /// The parameter `orderId` of this provider.
  int get orderId;
}

class _OrderDetailProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<OrderDetail, OrderEntity>
    with OrderDetailRef {
  _OrderDetailProviderElement(super.provider);

  @override
  int get orderId => (origin as OrderDetailProvider).orderId;
}

String _$reorderActionHash() => r'3288d04b3da86d206a283c6ef49a09425f036a37';

/// See also [ReorderAction].
@ProviderFor(ReorderAction)
final reorderActionProvider =
    AutoDisposeNotifierProvider<ReorderAction, void>.internal(
  ReorderAction.new,
  name: r'reorderActionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reorderActionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReorderAction = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
