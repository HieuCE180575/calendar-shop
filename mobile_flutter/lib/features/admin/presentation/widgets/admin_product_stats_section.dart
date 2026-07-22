import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/admin_product_stats.dart';
import '../providers/admin_stats_provider.dart';

class AdminProductStatsSection extends ConsumerWidget {
  const AdminProductStatsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminProductStatsProvider);

    return statsAsync.when(
      data: (stats) => _buildStats(context, stats),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Lỗi: $error')),
    );
  }

  Widget _buildStats(BuildContext context, AdminProductStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildOverviewCards(stats),
        const SizedBox(height: 16),
        _buildStockByCategory(stats),
        const SizedBox(height: 16),
        _buildLowStockProducts(stats),
      ],
    );
  }

  Widget _buildOverviewCards(AdminProductStats stats) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Tổng SP',
            value: stats.totalProducts.toString(),
            subtitle: '${stats.totalProductsGrowth >= 0 ? '↑' : '↓'} ${stats.totalProductsGrowth.abs()}% so với kỳ trước',
            icon: Icons.inventory_2,
            color: Colors.blue,
            subtitleColor: stats.totalProductsGrowth >= 0 ? AppColors.success : AppColors.danger,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'Đang bán',
            value: stats.inBusiness.toString(),
            subtitle: '${stats.inBusinessGrowth >= 0 ? '↑' : '↓'} ${stats.inBusinessGrowth.abs()}% so với kỳ trước',
            icon: Icons.storefront,
            color: Colors.green,
            subtitleColor: stats.inBusinessGrowth >= 0 ? AppColors.success : AppColors.danger,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'Sắp hết',
            value: stats.lowStock.toString(),
            subtitle: 'Cần nhập thêm',
            icon: Icons.warning_amber_rounded,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStockByCategory(AdminProductStats stats) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tồn kho theo danh mục',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...stats.stockByCategory.map((cat) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(cat.categoryName),
                        Text('${cat.totalStock} (${cat.percentage.toStringAsFixed(1)}%)', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: cat.percentage / 100,
                      backgroundColor: Colors.grey.shade200,
                      color: Colors.blue,
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

  Widget _buildLowStockProducts(AdminProductStats stats) {
    if (stats.lowStockProducts.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sản phẩm sắp hết hàng (<10)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            const SizedBox(height: 12),
            ...stats.lowStockProducts.map((product) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: Colors.orange.withOpacity(0.2),
                  child: const Icon(Icons.inventory, color: Colors.orange),
                ),
                title: Text(product.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Mã SP'),
                trailing: Text(
                  'Còn ${product.stockQuantity}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
              );
            }),
          ],
        ),
      ),
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
