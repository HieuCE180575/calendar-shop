import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/admin_coupon_stats.dart';
import '../providers/admin_stats_provider.dart';

class AdminCouponStatsSection extends ConsumerWidget {
  const AdminCouponStatsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminCouponStatsProvider);

    return statsAsync.when(
      data: (stats) => _buildStats(context, stats),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Lỗi: $error')),
    );
  }

  Widget _buildStats(BuildContext context, AdminCouponStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildOverviewCards(stats),
      ],
    );
  }

  Widget _buildOverviewCards(AdminCouponStats stats) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Tổng mã giảm giá',
            value: stats.totalCoupons.toString(),
            subtitle: '${stats.totalCouponsGrowth >= 0 ? '↑' : '↓'} ${stats.totalCouponsGrowth.abs()}% so với kỳ trước',
            icon: Icons.confirmation_num,
            color: Colors.blue,
            subtitleColor: stats.totalCouponsGrowth >= 0 ? AppColors.success : AppColors.danger,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'Đang hoạt động',
            value: stats.activeCoupons.toString(),
            subtitle: '${stats.activeCouponsGrowth >= 0 ? '↑' : '↓'} ${stats.activeCouponsGrowth.abs()}% so với kỳ trước',
            icon: Icons.verified,
            color: Colors.green,
            subtitleColor: stats.activeCouponsGrowth >= 0 ? AppColors.success : AppColors.danger,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color? subtitleColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 10, color: subtitleColor ?? color, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
