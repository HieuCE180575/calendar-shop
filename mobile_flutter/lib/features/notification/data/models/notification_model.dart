import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/notification_entity.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required int notificationId,
    required int userId,
    required String title,
    required String content,
    required String type,
    required bool isRead,
    required DateTime createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

extension NotificationModelMapper on NotificationModel {
  NotificationEntity toEntity() => NotificationEntity(
        notificationId: notificationId,
        userId: userId,
        title: title,
        content: content,
        type: type,
        isRead: isRead,
        createdAt: createdAt,
      );
}
