import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/admin_customer_stats.dart';
import '../providers/admin_stats_provider.dart';

class AdminCustomerStatsSection extends ConsumerWidget {
  const AdminCustomerStatsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminCustomerStatsProvider);

    return statsAsync.when(
      data: (stats) => _buildStats(context, stats),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Lỗi: $error')),
    );
  }

  Widget _buildStats(BuildContext context, AdminCustomerStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildOverviewCards(stats),
        const SizedBox(height: 16),
        _buildRankDistribution(stats),
        const SizedBox(height: 16),
        _buildTopCustomers(stats),
      ],
    );
  }

  Widget _buildOverviewCards(AdminCustomerStats stats) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Tổng KH',
            value: stats.totalCustomers.toString(),
            subtitle: '${stats.totalCustomersGrowth >= 0 ? '↑' : '↓'} ${stats.totalCustomersGrowth.abs()}% so với kỳ trước',
            icon: Icons.people_alt,
            color: Colors.blue,
            subtitleColor: stats.totalCustomersGrowth >= 0 ? AppColors.success : AppColors.danger,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'KH Mới',
            value: stats.newCustomers.toString(),
            subtitle: '${stats.newCustomersGrowth >= 0 ? '↑' : '↓'} ${stats.newCustomersGrowth.abs()}% so với kỳ trước',
            icon: Icons.person_add,
            color: Colors.green,
            subtitleColor: stats.newCustomersGrowth >= 0 ? AppColors.success : AppColors.danger,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'KH Trung thành',
            value: stats.loyalCustomers.toString(),
            subtitle: 'Bạc trở lên',
            icon: Icons.star,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildRankDistribution(AdminCustomerStats stats) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Phân bổ hạng thành viên',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...stats.rankDistribution.map((rank) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(rank.rank),
                        Text('${rank.total} (${rank.percentage}%)', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: rank.percentage / 100,
                      backgroundColor: Colors.grey.shade200,
                      color: _getRankColor(rank.rank),
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

  Widget _buildTopCustomers(AdminCustomerStats stats) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Khách hàng chi tiêu cao nhất',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...stats.topCustomers.map((customer) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: _getRankColor(customer.rank).withOpacity(0.2),
                  child: Text(
                    customer.fullName.isNotEmpty ? customer.fullName[0] : 'U',
                    style: TextStyle(color: _getRankColor(customer.rank), fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(customer.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${customer.totalOrders} đơn hàng'),
                trailing: Text(
                  '${_formatCurrency(customer.totalSpent)}đ',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(String rank) {
    switch (rank) {
      case 'Kim cương': return Colors.purple;
      case 'Vàng': return Colors.orange;
      case 'Bạc': return Colors.grey;
      case 'Đồng': return Colors.brown;
      default: return Colors.blue;
    }
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
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
            color: Colors.black.withOpacity(0.05),
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
