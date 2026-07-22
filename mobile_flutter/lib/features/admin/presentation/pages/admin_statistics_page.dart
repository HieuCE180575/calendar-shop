import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/admin_dashboard_provider.dart';
import '../widgets/admin_dashboard_header.dart';
import '../widgets/best_selling_products_card.dart';
import '../widgets/overview_metrics_section.dart';
import '../widgets/revenue_chart_card.dart';
import '../widgets/status_breakdown_card.dart';
import '../widgets/recent_orders_card.dart';
import '../widgets/low_stock_products_card.dart';

class AdminStatisticsPage extends ConsumerWidget {
  const AdminStatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminDashboardStatsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      appBar: AppBar(
        title: const Text(
          'Báo cáo thống kê',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.indigo.shade800,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => ref.invalidate(adminDashboardStatsProvider),
            tooltip: 'Làm mới dữ liệu',
          ),
        ],
      ),
      body: statsAsync.when(
        data: (stats) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(adminDashboardStatsProvider),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AdminDashboardHeader(),
                const SizedBox(height: 16),
                OverviewMetricsSection(stats: stats),
                if (stats.lowStockProducts.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  LowStockProductsCard(products: stats.lowStockProducts),
                ],
                const SizedBox(height: 24),
                StatusBreakdownCard(stats: stats),
                const SizedBox(height: 24),
                DailyRevenueChartCard(data: stats.revenueByDay),
                const SizedBox(height: 24),
                MonthlyRevenueChartCard(data: stats.revenueByMonth),
                const SizedBox(height: 24),
                BestSellingProductsCard(products: stats.bestSelling),
                if (stats.recentOrders.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  RecentOrdersCard(orders: stats.recentOrders),
                ],
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        loading: () => const _DashboardLoadingState(),
        error: (error, stack) => _DashboardErrorState(
          message: error.toString(),
          onRetry: () => ref.invalidate(adminDashboardStatsProvider),
        ),
      ),
    );
  }
}

class _DashboardLoadingState extends StatelessWidget {
  const _DashboardLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.indigo),
          SizedBox(height: 16),
          Text(
            'Đang tải số liệu thống kê...',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _DashboardErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _DashboardErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
            const SizedBox(height: 16),
            const Text(
              'Lỗi tải số liệu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
