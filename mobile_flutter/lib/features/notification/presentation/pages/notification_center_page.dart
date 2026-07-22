import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/notification_entity.dart';
import '../providers/notification_provider.dart';

class NotificationCenterPage extends ConsumerWidget {
  const NotificationCenterPage({super.key});

  IconData _getIconForType(String type) {
    switch (type) {
      case 'OrderUpdate':
        return Icons.local_shipping_outlined;
      case 'Holiday':
        return Icons.calendar_today_outlined;
      case 'Discount':
        return Icons.discount_outlined;
      default:
        return Icons.notifications_none_outlined;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'OrderUpdate':
        return Colors.orange;
      case 'Holiday':
        return Colors.green;
      case 'Discount':
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }

  String _formatDateTime(DateTime dt) {
    final local = dt.toLocal();
    final now = DateTime.now();
    final difference = now.difference(local);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    }
    if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    }

    return '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}/${local.year} '
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationNotifierProvider);
    final currentUser = ref.watch(authNotifierProvider).user;
    final isAdmin = currentUser?.role == 'Admin';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Trung tâm thông báo',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => ref.read(notificationNotifierProvider.notifier).markAllAsRead(),
            icon: const Icon(Icons.done_all, color: AppColors.primary),
            tooltip: 'Đọc tất cả',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(notificationNotifierProvider.notifier).refresh(),
        child: notificationState.when(
          data: (notifications) {
            if (notifications.isEmpty) {
              return Stack(
                children: [
                  ListView(),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_off_outlined,
                            size: 64,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Bạn chưa có thông báo nào',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Các thông báo về đơn hàng và ngày lễ sẽ xuất hiện tại đây.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (isAdmin) ...[
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () async {
                              try {
                                await ref.read(notificationNotifierProvider.notifier).triggerHolidayReminders();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Đã chạy mô phỏng nhắc nhở ngày lễ thành công.'),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Lỗi: $e')),
                                  );
                                }
                              }
                            },
                            icon: const Icon(Icons.bolt),
                            label: const Text('Mô phỏng thông báo ngày lễ'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: AppColors.primary.withOpacity(0.05),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Bấm vào thông báo để đánh dấu là đã đọc.',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ),
                      if (isAdmin)
                        TextButton.icon(
                          onPressed: () async {
                            await ref.read(notificationNotifierProvider.notifier).triggerHolidayReminders();
                          },
                          icon: const Icon(Icons.bolt, size: 14),
                          label: const Text('Mô phỏng ngày lễ', style: TextStyle(fontSize: 11)),
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final item = notifications[index];
                      return Dismissible(
                        key: Key('notification_${item.notificationId}'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          ref.read(notificationNotifierProvider.notifier).deleteNotification(item.notificationId);
                        },
                        child: _NotificationTile(
                          item: item,
                          icon: _getIconForType(item.type),
                          color: _getColorForType(item.type),
                          formattedTime: _formatDateTime(item.createdAt),
                          onTap: () {
                            if (!item.isRead) {
                              ref.read(notificationNotifierProvider.notifier).markAsRead(item.notificationId);
                            }
                            
                            // Navigate to order detail if it's an order notification
                            if (item.type == 'OrderUpdate') {
                              final regex = RegExp(r'#(\d+)');
                              final match = regex.firstMatch(item.content) ?? regex.firstMatch(item.title);
                              if (match != null) {
                                final orderIdStr = match.group(1);
                                if (orderIdStr != null) {
                                  // If admin, go to admin order detail, otherwise user order detail
                                  if (isAdmin) {
                                    context.push('/admin/orders/$orderIdStr');
                                  } else {
                                    context.push('/orders/$orderIdStr');
                                  }
                                }
                              }
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Đã có lỗi xảy ra: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.read(notificationNotifierProvider.notifier).refresh(),
                  child: const Text('Tải lại'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationEntity item;
  final IconData icon;
  final Color color;
  final String formattedTime;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.item,
    required this.icon,
    required this.color,
    required this.formattedTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: item.isRead ? Colors.transparent : AppColors.primary.withOpacity(0.04),
          border: const Border(
            bottom: BorderSide(color: AppColors.border, width: 0.5),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: item.isRead ? FontWeight.w500 : FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!item.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.content,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: item.isRead ? AppColors.textSecondary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formattedTime,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
