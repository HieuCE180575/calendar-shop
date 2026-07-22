import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/admin_dashboard_stats.dart';
import '../providers/admin_dashboard_provider.dart';
import 'admin_dashboard_formatters.dart';

class OverviewMetricsSection extends ConsumerWidget {
  final AdminDashboardStats stats;

  const OverviewMetricsSection({super.key, required this.stats});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final days = ref.watch(dashboardDaysFilterProvider);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.shopping_bag_outlined,
                iconColor: const Color(0xFF2563EB),
                iconBg: const Color(0xFFEFF6FF),
                title: 'Tổng đơn hàng',
                value: '${stats.totalOrders}',
                growthText: '${stats.totalOrdersGrowth >= 0 ? '↑' : '↓'} ${stats.totalOrdersGrowth.abs()}% so với $days ngày trước',
                growthColor: stats.totalOrdersGrowth >= 0 ? AppColors.success : AppColors.danger,
                onTap: () => context.go('/admin/orders'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.attach_money_outlined,
                iconColor: const Color(0xFF059669),
                iconBg: const Color(0xFFECFDF5),
                title: 'Doanh thu',
                value: AdminDashboardFormatters.shortCurrency(stats.totalRevenue),
                growthText: '${stats.totalRevenueGrowth >= 0 ? '↑' : '↓'} ${stats.totalRevenueGrowth.abs()}% so với $days ngày trước',
                growthColor: stats.totalRevenueGrowth >= 0 ? AppColors.success : AppColors.danger,
                onTap: () => context.go('/admin/statistics'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.inventory_2_outlined,
                iconColor: const Color(0xFF7C3AED),
                iconBg: const Color(0xFFF5F3FF),
                title: 'Sản phẩm',
                value: '${stats.totalProducts}', 
                growthText: '+ ${stats.newProductsCount} sản phẩm mới',
                growthColor: const Color(0xFF2563EB),
                onTap: () => context.go('/admin/products'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.warning_amber_rounded,
                iconColor: const Color(0xFFE2561A),
                iconBg: const Color(0xFFFFF7ED),
                title: 'Sắp hết hàng',
                value: '${stats.lowStockProducts.length}',
                growthText: 'Xem danh sách',
                growthColor: const Color(0xFF2563EB),
                onTap: () => context.go('/admin/products'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String value;
  final String growthText;
  final Color growthColor;
  final VoidCallback onTap;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.value,
    required this.growthText,
    required this.growthColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: iconColor, size: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  growthText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: growthColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
