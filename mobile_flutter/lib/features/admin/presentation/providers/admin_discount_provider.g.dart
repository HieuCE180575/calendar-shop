// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_discount_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$adminDiscountRemoteDataSourceHash() =>
    r'721c41b9aab8a4462639daf1bf9fb8a9ffe342a8';

/// See also [adminDiscountRemoteDataSource].
@ProviderFor(adminDiscountRemoteDataSource)
final adminDiscountRemoteDataSourceProvider =
    AutoDisposeProvider<AdminDiscountRemoteDataSource>.internal(
  adminDiscountRemoteDataSource,
  name: r'adminDiscountRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$adminDiscountRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AdminDiscountRemoteDataSourceRef
    = AutoDisposeProviderRef<AdminDiscountRemoteDataSource>;
String _$adminDiscountRepositoryHash() =>
    r'cff643a2a9f44c99dbc47f8eb53f3038f80dc61d';

/// See also [adminDiscountRepository].
@ProviderFor(adminDiscountRepository)
final adminDiscountRepositoryProvider =
    AutoDisposeProvider<AdminDiscountRepository>.internal(
  adminDiscountRepository,
  name: r'adminDiscountRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$adminDiscountRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AdminDiscountRepositoryRef
    = AutoDisposeProviderRef<AdminDiscountRepository>;
String _$adminDiscountListHash() => r'd2b229cc8888112e99eaf21ec5d42c7279fdce43';

/// See also [adminDiscountList].
@ProviderFor(adminDiscountList)
final adminDiscountListProvider = AutoDisposeFutureProvider<
    ({List<AdminDiscount> items, int totalCount})>.internal(
  adminDiscountList,
  name: r'adminDiscountListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$adminDiscountListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AdminDiscountListRef = AutoDisposeFutureProviderRef<
    ({List<AdminDiscount> items, int totalCount})>;
String _$adminDiscountDetailHash() =>
    r'f69329d3e4c294f793d210cfe325cb9955a39945';

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

/// See also [adminDiscountDetail].
@ProviderFor(adminDiscountDetail)
const adminDiscountDetailProvider = AdminDiscountDetailFamily();

/// See also [adminDiscountDetail].
class AdminDiscountDetailFamily extends Family<AsyncValue<AdminDiscount>> {
  /// See also [adminDiscountDetail].
  const AdminDiscountDetailFamily();

  /// See also [adminDiscountDetail].
  AdminDiscountDetailProvider call(
    int id,
  ) {
    return AdminDiscountDetailProvider(
      id,
    );
  }

  @override
  AdminDiscountDetailProvider getProviderOverride(
    covariant AdminDiscountDetailProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'adminDiscountDetailProvider';
}

/// See also [adminDiscountDetail].
class AdminDiscountDetailProvider
    extends AutoDisposeFutureProvider<AdminDiscount> {
  /// See also [adminDiscountDetail].
  AdminDiscountDetailProvider(
    int id,
  ) : this._internal(
          (ref) => adminDiscountDetail(
            ref as AdminDiscountDetailRef,
            id,
          ),
          from: adminDiscountDetailProvider,
          name: r'adminDiscountDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$adminDiscountDetailHash,
          dependencies: AdminDiscountDetailFamily._dependencies,
          allTransitiveDependencies:
              AdminDiscountDetailFamily._allTransitiveDependencies,
          id: id,
        );

  AdminDiscountDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<AdminDiscount> Function(AdminDiscountDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AdminDiscountDetailProvider._internal(
        (ref) => create(ref as AdminDiscountDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AdminDiscount> createElement() {
    return _AdminDiscountDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AdminDiscountDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AdminDiscountDetailRef on AutoDisposeFutureProviderRef<AdminDiscount> {
  /// The parameter `id` of this provider.
  int get id;
}

class _AdminDiscountDetailProviderElement
    extends AutoDisposeFutureProviderElement<AdminDiscount>
    with AdminDiscountDetailRef {
  _AdminDiscountDetailProviderElement(super.provider);

  @override
  int get id => (origin as AdminDiscountDetailProvider).id;
}

String _$adminDiscountFilterHash() =>
    r'599f9d62fdb23c869e8d8a1d98c067346ec7723d';

/// See also [AdminDiscountFilter].
@ProviderFor(AdminDiscountFilter)
final adminDiscountFilterProvider = AutoDisposeNotifierProvider<
    AdminDiscountFilter, AdminDiscountFilterState>.internal(
  AdminDiscountFilter.new,
  name: r'adminDiscountFilterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$adminDiscountFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AdminDiscountFilter = AutoDisposeNotifier<AdminDiscountFilterState>;
String _$adminDiscountActionNotifierHash() =>
    r'06881fcfe1490305bf0933e379b57d6a5a7d8214';

/// See also [AdminDiscountActionNotifier].
@ProviderFor(AdminDiscountActionNotifier)
final adminDiscountActionNotifierProvider =
    AutoDisposeNotifierProvider<AdminDiscountActionNotifier, bool>.internal(
  AdminDiscountActionNotifier.new,
  name: r'adminDiscountActionNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$adminDiscountActionNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AdminDiscountActionNotifier = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
