import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/admin_dashboard_stats.dart';
import 'dashboard_section_card.dart';

class StatusBreakdownCard extends StatelessWidget {
  final AdminDashboardStats stats;

  const StatusBreakdownCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final statusColor = <String, Color>{
      'Pending': AppColors.warning,
      'Confirmed': Colors.blue,
      'Shipping': AppColors.primary,
      'Delivered': AppColors.success,
      'Cancelled': AppColors.danger,
    };

    final statusNameVi = <String, String>{
      'Pending': 'Chờ xử lý',
      'Confirmed': 'Đã xác nhận',
      'Shipping': 'Đang giao hàng',
      'Delivered': 'Đã giao thành công',
      'Cancelled': 'Đã hủy đơn',
    };

    final totalOrders = stats.totalOrders > 0 ? stats.totalOrders : 1;

    return DashboardSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trạng thái đơn hàng',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stats.ordersByStatus.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = stats.ordersByStatus[index];
              final color = statusColor[item.status] ?? Colors.grey;
              final nameVi = statusNameVi[item.status] ?? item.status;
              final percentage = item.total / totalOrders;

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            nameVi,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${item.total} đơn (${(percentage * 100).toStringAsFixed(1)}%)',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage,
                      backgroundColor: AppColors.divider,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 8,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
