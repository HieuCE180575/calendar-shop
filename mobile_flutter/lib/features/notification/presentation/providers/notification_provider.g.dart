// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationRemoteDataSourceHash() =>
    r'b4ecfabe042804706b00c22d998757fed13ac21f';

/// See also [notificationRemoteDataSource].
@ProviderFor(notificationRemoteDataSource)
final notificationRemoteDataSourceProvider =
    AutoDisposeProvider<NotificationRemoteDataSource>.internal(
  notificationRemoteDataSource,
  name: r'notificationRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NotificationRemoteDataSourceRef
    = AutoDisposeProviderRef<NotificationRemoteDataSource>;
String _$notificationRepositoryHash() =>
    r'35360102a5296871af20127eb69efc8f7b2ba49a';

/// See also [notificationRepository].
@ProviderFor(notificationRepository)
final notificationRepositoryProvider =
    AutoDisposeProvider<NotificationRepository>.internal(
  notificationRepository,
  name: r'notificationRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NotificationRepositoryRef
    = AutoDisposeProviderRef<NotificationRepository>;
String _$unreadNotificationsCountHash() =>
    r'297370acd96bd00df35e5d75fc878bdbd04cd568';

/// Provider tính số lượng thông báo chưa đọc hiển thị ở badge.
///
/// Copied from [unreadNotificationsCount].
@ProviderFor(unreadNotificationsCount)
final unreadNotificationsCountProvider = AutoDisposeProvider<int>.internal(
  unreadNotificationsCount,
  name: r'unreadNotificationsCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unreadNotificationsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UnreadNotificationsCountRef = AutoDisposeProviderRef<int>;
String _$notificationNotifierHash() =>
    r'bca6741e5c9996ed3f5bde60496fdbd5fd611824';

/// Notifier quản lý danh sách thông báo của người dùng.
///
/// Copied from [NotificationNotifier].
@ProviderFor(NotificationNotifier)
final notificationNotifierProvider = AutoDisposeAsyncNotifierProvider<
    NotificationNotifier, List<NotificationEntity>>.internal(
  NotificationNotifier.new,
  name: r'notificationNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationNotifier
    = AutoDisposeAsyncNotifier<List<NotificationEntity>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
