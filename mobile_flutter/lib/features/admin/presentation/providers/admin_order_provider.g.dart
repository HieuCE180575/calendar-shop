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
String _$getAdminOrdersUseCaseHash() =>
    r'7de0b770726fc5c5b776c2331406250907587377';

/// See also [getAdminOrdersUseCase].
@ProviderFor(getAdminOrdersUseCase)
final getAdminOrdersUseCaseProvider =
    AutoDisposeProvider<GetAdminOrdersUseCase>.internal(
  getAdminOrdersUseCase,
  name: r'getAdminOrdersUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getAdminOrdersUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetAdminOrdersUseCaseRef
    = AutoDisposeProviderRef<GetAdminOrdersUseCase>;
String _$getAdminOrderByIdUseCaseHash() =>
    r'3b6f039ce5e1d7a596651395c80790996385bbf8';

/// See also [getAdminOrderByIdUseCase].
@ProviderFor(getAdminOrderByIdUseCase)
final getAdminOrderByIdUseCaseProvider =
    AutoDisposeProvider<GetAdminOrderByIdUseCase>.internal(
  getAdminOrderByIdUseCase,
  name: r'getAdminOrderByIdUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getAdminOrderByIdUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetAdminOrderByIdUseCaseRef
    = AutoDisposeProviderRef<GetAdminOrderByIdUseCase>;
String _$updateAdminOrderStatusUseCaseHash() =>
    r'5950308d3f8b28a641dffe87a85f89c187a9ec08';

/// See also [updateAdminOrderStatusUseCase].
@ProviderFor(updateAdminOrderStatusUseCase)
final updateAdminOrderStatusUseCaseProvider =
    AutoDisposeProvider<UpdateAdminOrderStatusUseCase>.internal(
  updateAdminOrderStatusUseCase,
  name: r'updateAdminOrderStatusUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateAdminOrderStatusUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UpdateAdminOrderStatusUseCaseRef
    = AutoDisposeProviderRef<UpdateAdminOrderStatusUseCase>;
String _$adminOrdersHash() => r'47f84ae0095d7a3b58013108ec2d3d0d662e42fe';

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
String _$adminOrderActionHash() => r'8a86383a3c93cab60496e63806bae63385be639a';

/// See also [AdminOrderAction].
@ProviderFor(AdminOrderAction)
final adminOrderActionProvider =
    AutoDisposeNotifierProvider<AdminOrderAction, bool>.internal(
  AdminOrderAction.new,
  name: r'adminOrderActionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$adminOrderActionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AdminOrderAction = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
