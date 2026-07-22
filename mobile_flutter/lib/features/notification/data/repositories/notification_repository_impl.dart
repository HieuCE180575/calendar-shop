import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';
import '../models/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    final models = await remoteDataSource.getNotifications();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> markAsRead(int id) async {
    await remoteDataSource.markAsRead(id);
  }

  @override
  Future<void> markAllAsRead() async {
    await remoteDataSource.markAllAsRead();
  }

  @override
  Future<void> registerFcmToken(String token) async {
    await remoteDataSource.registerFcmToken(token);
  }

  @override
  Future<void> triggerHolidayReminders() async {
    await remoteDataSource.triggerHolidayReminders();
  }

  @override
  Future<void> deleteNotification(int id) async {
    await remoteDataSource.deleteNotification(id);
  }
}
