import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/admin_dashboard_stats.dart';
import 'admin_dashboard_formatters.dart';
import 'dashboard_section_card.dart';

class RecentOrdersCard extends StatelessWidget {
  final List<RecentOrder> orders;

  const RecentOrdersCard({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Đơn hàng gần đây',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.go('/admin/orders');
                  },
                  child: const Text('Xem tất cả', style: TextStyle(color: AppColors.primary)),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final order = orders[index];
              final dateStr = DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt.toLocal());
              return InkWell(
                onTap: () {
                  context.push('/admin/orders/${order.orderId}');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      // Order ID and Date
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '#DH${order.orderId}',
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dateStr,
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      // Customer
                      Expanded(
                        flex: 2,
                        child: Text(
                          order.customerName.isNotEmpty ? order.customerName : 'Khách hàng',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      // Product
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppColors.border),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: ApiConstants.resolveImageUrl(order.productImageUrl).isNotEmpty
                                  ? Image.network(
                                      ApiConstants.resolveImageUrl(order.productImageUrl),
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.image_outlined, size: 16, color: AppColors.textSecondary),
                                    )
                                  : const Icon(Icons.image_outlined, size: 16, color: AppColors.textSecondary),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                order.productName,
                                style: const TextStyle(fontSize: 13),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Status
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: _buildStatusBadge(order.status),
                        ),
                      ),
                      // Total Amount
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            AdminDashboardFormatters.currency.format(order.totalAmount),
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.primary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    String text = _getStatusVi(status);

    switch (status.toLowerCase()) {
      case 'delivered':
        bgColor = AppColors.success.withOpacity(0.1);
        textColor = AppColors.success;
        break;
      case 'cancelled':
        bgColor = AppColors.danger.withOpacity(0.1);
        textColor = AppColors.danger;
        break;
      case 'processing':
        bgColor = AppColors.primary.withOpacity(0.1);
        textColor = AppColors.primary;
        break;
      case 'pending':
      default:
        bgColor = const Color(0xFFE2561A).withOpacity(0.1);
        textColor = const Color(0xFFE2561A);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return AppColors.success;
      case 'cancelled':
        return AppColors.danger;
      case 'processing':
      case 'shipping':
        return AppColors.primary;
      case 'pending':
        return AppColors.warning;
      case 'confirmed':
        return Colors.blue;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusVi(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return 'Đã giao';
      case 'cancelled':
        return 'Đã hủy';
      case 'processing':
        return 'Đang xử lý';
      case 'shipping':
        return 'Đang giao';
      case 'pending':
        return 'Chờ xử lý';
      case 'confirmed':
        return 'Đã xác nhận';
      default:
        return status;
    }
  }
}
