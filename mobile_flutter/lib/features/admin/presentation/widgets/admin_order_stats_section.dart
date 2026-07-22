import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/admin_order_stats.dart';
import '../../presentation/providers/admin_stats_provider.dart';

class AdminOrderStatsSection extends ConsumerWidget {
  const AdminOrderStatsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminOrderStatsProvider);

    return statsAsync.when(
      data: (stats) => _buildStats(context, stats),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Lỗi: $error')),
    );
  }

  Widget _buildStats(BuildContext context, AdminOrderStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildOverviewCards(stats),
        const SizedBox(height: 16),
        _buildStatusDistribution(stats),
      ],
    );
  }

  Widget _buildOverviewCards(AdminOrderStats stats) {
    final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Tổng đơn hàng',
            value: stats.totalOrders.toString(),
            subtitle: '${stats.totalOrdersGrowth >= 0 ? '↑' : '↓'} ${stats.totalOrdersGrowth.abs()}% so với kỳ trước',
            icon: Icons.receipt_long,
            color: Colors.blue,
            subtitleColor: stats.totalOrdersGrowth >= 0 ? AppColors.success : AppColors.danger,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'Tổng doanh thu',
            value: currencyFormatter.format(stats.revenueByDay.fold<double>(0, (sum, item) => sum + item.revenue)),
            subtitle: '${stats.revenueGrowth >= 0 ? '↑' : '↓'} ${stats.revenueGrowth.abs()}% so với kỳ trước',
            icon: Icons.attach_money,
            color: Colors.green,
            subtitleColor: stats.revenueGrowth >= 0 ? AppColors.success : AppColors.danger,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDistribution(AdminOrderStats stats) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trạng thái đơn hàng',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...stats.statusDistribution.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_getStatusLabel(entry.status)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(entry.status).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        entry.total.toString(),
                        style: TextStyle(
                          color: _getStatusColor(entry.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
  
  String _getStatusLabel(String status) {
    switch (status) {
      case 'Pending': return 'Chờ xác nhận';
      case 'Processing': return 'Đang xử lý';
      case 'Shipped': return 'Đang giao';
      case 'Delivered': return 'Đã giao';
      case 'Cancelled': return 'Đã hủy';
      default: return status;
    }
  }
  
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending': return Colors.orange;
      case 'Processing': return Colors.blue;
      case 'Shipped': return Colors.indigo;
      case 'Delivered': return Colors.green;
      case 'Cancelled': return Colors.red;
      default: return Colors.grey;
    }
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
            style: TextStyle(fontSize: value.length > 8 ? 16 : 24, fontWeight: FontWeight.bold),
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
