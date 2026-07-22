import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class AdminPageLayout extends ConsumerWidget {
  final String title;
  final String currentRoute;
  final Widget child;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const AdminPageLayout({
    super.key,
    required this.title,
    required this.currentRoute,
    required this.child,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: actions ?? [
          IconButton(
            icon: const Icon(Icons.storefront_outlined, color: AppColors.primary),
            tooltip: 'Trang bán hàng',
            onPressed: () => context.go('/products'),
          ),
          IconButton(
            onPressed: () => context.push('/profile'),
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'Hồ sơ',
          ),
          IconButton(
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.admin_panel_settings, color: Colors.white, size: 48),
                  SizedBox(height: 12),
                  Text(
                    'Calendar Shop Admin',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Quản trị viên',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(context, icon: Icons.dashboard_outlined, title: 'Tổng quan', route: '/admin'),
            const Divider(),
            _buildDrawerItem(context, icon: Icons.inventory_2_outlined, title: 'Sản phẩm', route: '/admin/products'),
            _buildDrawerItem(context, icon: Icons.receipt_long_outlined, title: 'Đơn hàng', route: '/admin/orders'),
            _buildDrawerItem(context, icon: Icons.people_alt_outlined, title: 'Khách hàng', route: '/admin/users'),
            _buildDrawerItem(context, icon: Icons.category_outlined, title: 'Danh mục', route: '/admin/categories'),
            _buildDrawerItem(context, icon: Icons.discount_outlined, title: 'Khuyến mãi', route: '/admin/coupons'),
            _buildDrawerItem(context, icon: Icons.flash_on_outlined, title: 'Flash Sale', route: '/admin/discounts'),
            _buildDrawerItem(context, icon: Icons.bar_chart_outlined, title: 'Thống kê', route: '/admin/statistics'),
          ],
        ),
      ),
      body: child,
      floatingActionButton: floatingActionButton,
    );
  }

  Widget _buildDrawerItem(BuildContext context, {required IconData icon, required String title, required String route}) {
    final isSelected = currentRoute == route;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : Colors.grey[700],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.primary : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppColors.primary.withOpacity(0.1),
      onTap: () {
        Navigator.pop(context); // Close drawer
        if (!isSelected) {
          context.go(route);
        }
      },
    );
  }
}
