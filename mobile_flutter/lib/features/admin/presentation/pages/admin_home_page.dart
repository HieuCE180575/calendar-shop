import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/admin_dashboard_provider.dart';
import '../widgets/overview_metrics_section.dart';
import '../widgets/revenue_chart_card.dart';
import '../widgets/recent_orders_card.dart';
import '../widgets/dashboard_product_management_section.dart';
import '../widgets/best_selling_products_card.dart';
import '../widgets/low_stock_products_card.dart';
import '../widgets/admin_dashboard_header.dart';
import '../widgets/admin_page_layout.dart';

class AdminHomePage extends ConsumerWidget {
  const AdminHomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminDashboardStatsProvider);
    
    return AdminPageLayout(
        title: 'Bảng quản trị Admin',
        currentRoute: '/admin',
        child: statsAsync.when(
        data: (stats) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(adminDashboardStatsProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AdminDashboardHeader(),
                const SizedBox(height: 16),
                OverviewMetricsSection(stats: stats),
                const SizedBox(height: 16),
                MonthlyRevenueChartCard(data: stats.revenueByMonth),
                const SizedBox(height: 16),
                RecentOrdersCard(orders: stats.recentOrders),
                const SizedBox(height: 16),
                const DashboardProductManagementSection(),
                const SizedBox(height: 16),
                BestSellingProductsCard(products: stats.bestSelling),
                const SizedBox(height: 16),
                LowStockProductsCard(stats: stats),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Lỗi tải dữ liệu: $error', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(adminDashboardStatsProvider),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    final bool isActive = GoRouterState.of(context).uri.toString() == route;
    return ListTile(
      leading: Icon(icon, color: isActive ? AppColors.primary : AppColors.textPrimary),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isActive ? FontWeight.bold : FontWeight.w600, 
          color: isActive ? AppColors.primary : AppColors.textPrimary,
        ),
      ),
      selected: isActive,
      selectedTileColor: AppColors.primary.withOpacity(0.1),
      onTap: () {
        Navigator.pop(context); // Close drawer
        if (!isActive) {
          context.push(route);
        }
      },
    );
  }
}
