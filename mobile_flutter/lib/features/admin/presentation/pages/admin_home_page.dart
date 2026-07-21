import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class AdminHomePage extends ConsumerWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Bang quan tri Admin',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.storefront_outlined,
              color: AppColors.primary,
            ),
            tooltip: 'Trang ban hang',
            onPressed: () => context.go('/products'),
          ),
          IconButton(
            onPressed: () => context.push('/profile'),
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'Ho so',
          ),
          IconButton(
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Dang xuat',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAdminTile(
            context,
            icon: Icons.inventory_2_outlined,
            title: 'Quan ly san pham',
            subtitle: 'Them, sua, xoa, ton kho va trang thai',
            route: '/admin/products',
            color: const Color(0xFF2563EB),
          ),
          const SizedBox(height: 12),
          _buildAdminTile(
            context,
            icon: Icons.category_outlined,
            title: 'Quan ly danh muc',
            subtitle: 'Phan loai cac dong lich',
            route: '/admin/categories',
            color: const Color(0xFF0284C7),
          ),
          const SizedBox(height: 12),
          _buildAdminTile(
            context,
            icon: Icons.receipt_long_outlined,
            title: 'Quan ly don hang',
            subtitle: 'Duyet don, giao hang, cap nhat trang thai',
            route: '/admin/orders',
            color: const Color(0xFF10B981),
          ),
          const SizedBox(height: 12),
          _buildAdminTile(
            context,
            icon: Icons.people_alt_outlined,
            title: 'Quan ly nguoi dung',
            subtitle: 'Xem danh sach, tim kiem, khoa/mo khoa, phan quyen',
            route: '/admin/users',
            color: const Color(0xFFEC4899),
          ),
          const SizedBox(height: 12),
          _buildAdminTile(
            context,
            icon: Icons.discount_outlined,
            title: 'Quan ly ma giam gia',
            subtitle: 'Bat/tat coupon, gia tri giam, han su dung',
            route: '/admin/coupons',
            color: const Color(0xFFF59E0B),
          ),
          const SizedBox(height: 12),
          _buildAdminTile(
            context,
            icon: Icons.bar_chart_outlined,
            title: 'Bao cao & Thong ke',
            subtitle: 'Tong doanh thu, so luong ban, bieu do',
            route: '/admin/statistics',
            color: const Color(0xFF8B5CF6),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String route,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: AppColors.textMuted,
        ),
        onTap: () => context.push(route),
      ),
    );
  }
}
