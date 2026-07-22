class NotificationEntity {
  final int notificationId;
  final int userId;
  final String title;
  final String content;
  final String type;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.notificationId,
    required this.userId,
    required this.title,
    required this.content,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  NotificationEntity copyWith({
    int? notificationId,
    int? userId,
    String? title,
    String? content,
    String? type,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationEntity(
      notificationId: notificationId ?? this.notificationId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
