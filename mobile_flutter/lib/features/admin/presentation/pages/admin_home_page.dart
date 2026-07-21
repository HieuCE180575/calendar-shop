import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Bảng quản trị Admin', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.storefront_outlined, color: AppColors.primary),
            tooltip: 'Trang bán hàng',
            onPressed: () => context.go('/products'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAdminTile(
            context,
            icon: Icons.inventory_2_outlined,
            title: 'Quản lý sản phẩm',
            subtitle: 'Thêm, sửa, xóa, tồn kho và trạng thái',
            route: '/admin/products',
            color: const Color(0xFF2563EB),
          ),
          const SizedBox(height: 12),
          _buildAdminTile(
            context,
            icon: Icons.category_outlined,
            title: 'Quản lý danh mục',
            subtitle: 'Phân loại các dòng lịch',
            route: '/admin/categories',
            color: const Color(0xFF0284C7),
          ),
          const SizedBox(height: 12),
          _buildAdminTile(
            context,
            icon: Icons.receipt_long_outlined,
            title: 'Quản lý đơn hàng',
            subtitle: 'Duyệt đơn, giao hàng, cập nhật trạng thái',
            route: '/admin/orders',
            color: const Color(0xFF10B981),
          ),
          const SizedBox(height: 12),
          _buildAdminTile(
            context,
            icon: Icons.discount_outlined,
            title: 'Quản lý mã giảm giá',
            subtitle: 'Bật/tắt coupon, giá trị giảm, hạn sử dụng',
            route: '/admin/coupons',
            color: const Color(0xFFF59E0B),
          ),
          const SizedBox(height: 12),
          _buildAdminTile(
            context,
            icon: Icons.bar_chart_outlined,
            title: 'Báo cáo & Thống kê',
            subtitle: 'Tổng doanh thu, số lượng bán, biểu đồ',
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
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
        onTap: () => context.push(route),
      ),
    );
  }
}
