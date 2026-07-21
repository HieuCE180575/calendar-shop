// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$orderRemoteDataSourceHash() =>
    r'24948ce5c95c0cc90257299ec478d5fc0e6e8735';

/// See also [orderRemoteDataSource].
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
String _$orderRepositoryHash() => r'81313a513fbceb72677d536ac10c02224a2b1529';

/// See also [orderRepository].
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
String _$myOrdersHash() => r'27ccbf18f006fb93b57f24644bacab4eeb8314d7';

/// See also [myOrders].
@ProviderFor(myOrders)
final myOrdersProvider = AutoDisposeFutureProvider<List<OrderEntity>>.internal(
  myOrders,
  name: r'myOrdersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$myOrdersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MyOrdersRef = AutoDisposeFutureProviderRef<List<OrderEntity>>;
String _$reorderActionHash() => r'81c592a50ae97cc2814e831635a0e47cabdd624a';

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
