// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$adminOrderRemoteDataSourceHash() =>
    r'c1211e6f3618aea81b32fc996da3496e6670ac35';

/// See also [adminOrderRemoteDataSource].
@ProviderFor(adminOrderRemoteDataSource)
final adminOrderRemoteDataSourceProvider =
    AutoDisposeProvider<AdminOrderRemoteDataSource>.internal(
  adminOrderRemoteDataSource,
  name: r'adminOrderRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$adminOrderRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AdminOrderRemoteDataSourceRef
    = AutoDisposeProviderRef<AdminOrderRemoteDataSource>;
String _$adminOrderRepositoryHash() =>
    r'5a86e39f0347c927e6f9911d8abdedc30fa6b13a';

/// See also [adminOrderRepository].
@ProviderFor(adminOrderRepository)
final adminOrderRepositoryProvider =
    AutoDisposeProvider<AdminOrderRepository>.internal(
  adminOrderRepository,
  name: r'adminOrderRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$adminOrderRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AdminOrderRepositoryRef = AutoDisposeProviderRef<AdminOrderRepository>;
String _$adminOrdersHash() => r'340d73f6428a43c06b4e4fc3fa8e0877eafa1b48';

/// See also [adminOrders].
@ProviderFor(adminOrders)
final adminOrdersProvider =
    AutoDisposeFutureProvider<List<AdminOrder>>.internal(
  adminOrders,
  name: r'adminOrdersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$adminOrdersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AdminOrdersRef = AutoDisposeFutureProviderRef<List<AdminOrder>>;
String _$adminOrderSearchQueryHash() =>
    r'390ba65a6300052631818237da8e9f061a817d2d';

/// See also [AdminOrderSearchQuery].
@ProviderFor(AdminOrderSearchQuery)
final adminOrderSearchQueryProvider =
    AutoDisposeNotifierProvider<AdminOrderSearchQuery, String>.internal(
  AdminOrderSearchQuery.new,
  name: r'adminOrderSearchQueryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$adminOrderSearchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AdminOrderSearchQuery = AutoDisposeNotifier<String>;
String _$adminOrderStatusFilterHash() =>
    r'78de7e83f2e3fdd6bc4b882fe078531e838f9bf2';

/// See also [AdminOrderStatusFilter].
@ProviderFor(AdminOrderStatusFilter)
final adminOrderStatusFilterProvider =
    AutoDisposeNotifierProvider<AdminOrderStatusFilter, String>.internal(
  AdminOrderStatusFilter.new,
  name: r'adminOrderStatusFilterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$adminOrderStatusFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AdminOrderStatusFilter = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
