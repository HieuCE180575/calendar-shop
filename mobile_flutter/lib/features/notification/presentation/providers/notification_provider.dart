import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/notification_remote_datasource.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';

part 'notification_provider.g.dart';

@riverpod
NotificationRemoteDataSource notificationRemoteDataSource(NotificationRemoteDataSourceRef ref) {
  return NotificationRemoteDataSource(ref.watch(apiClientProvider));
}

@riverpod
NotificationRepository notificationRepository(NotificationRepositoryRef ref) {
  return NotificationRepositoryImpl(ref.watch(notificationRemoteDataSourceProvider));
}

/// Notifier quản lý danh sách thông báo của người dùng.
@riverpod
class NotificationNotifier extends _$NotificationNotifier {
  @override
  FutureOr<List<NotificationEntity>> build() {
    return ref.watch(notificationRepositoryProvider).getNotifications();
  }

  /// Tải lại danh sách thông báo từ server.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(notificationRepositoryProvider).getNotifications(),
    );
  }

  /// Đánh dấu một thông báo là đã đọc.
  Future<void> markAsRead(int notificationId) async {
    if (!state.hasValue) return;

    final currentList = state.value!;
    final updatedList = currentList.map((item) {
      if (item.notificationId == notificationId) {
        return item.copyWith(isRead: true);
      }
      return item;
    }).toList();

    state = AsyncValue.data(updatedList);

    try {
      await ref.read(notificationRepositoryProvider).markAsRead(notificationId);
    } catch (e) {
      state = AsyncValue.data(currentList);
      rethrow;
    }
  }

  /// Đánh dấu tất cả thông báo là đã đọc.
  Future<void> markAllAsRead() async {
    if (!state.hasValue) return;

    final currentList = state.value!;
    final updatedList = currentList.map((item) => item.copyWith(isRead: true)).toList();

    state = AsyncValue.data(updatedList);

    try {
      await ref.read(notificationRepositoryProvider).markAllAsRead();
    } catch (e) {
      state = AsyncValue.data(currentList);
      rethrow;
    }
  }

  /// Kích hoạt nhắc nhở ngày lễ phục vụ demo/kiểm thử.
  Future<void> triggerHolidayReminders() async {
    await ref.read(notificationRepositoryProvider).triggerHolidayReminders();
    await refresh();
  }
}

/// Provider tính số lượng thông báo chưa đọc hiển thị ở badge.
@riverpod
int unreadNotificationsCount(UnreadNotificationsCountRef ref) {
  final notificationState = ref.watch(notificationNotifierProvider);
  return notificationState.maybeWhen(
    data: (notifications) => notifications.where((n) => !n.isRead).length,
    orElse: () => 0,
  );
}
