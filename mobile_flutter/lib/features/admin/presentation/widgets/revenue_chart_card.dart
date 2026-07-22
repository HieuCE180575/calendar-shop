import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/admin_dashboard_stats.dart';
import 'admin_dashboard_formatters.dart';
import 'dashboard_section_card.dart';

class DailyRevenueChartCard extends StatelessWidget {
  final List<RevenueByDay> data;

  const DailyRevenueChartCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const _EmptyChartCard(
        title: 'Doanh thu theo ngày',
        message: 'Chưa có dữ liệu doanh thu theo ngày',
      );
    }

    final maxVal = data.map((e) => e.revenue).reduce((a, b) => a > b ? a : b);
    final maxScale = maxVal > 0 ? maxVal : 1.0;

    return DashboardSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Doanh thu theo ngày (Gần đây nhất)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                final barHeight = (item.revenue / maxScale) * 120;
                final dateStr = DateFormat('dd/MM').format(item.date);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        AdminDashboardFormatters.compactRevenue(item.revenue),
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 28,
                        height: barHeight > 5 ? barHeight : 5,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.indigo.shade400, Colors.indigo.shade700],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dateStr,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MonthlyRevenueChartCard extends StatelessWidget {
  final List<RevenueByMonth> data;

  const MonthlyRevenueChartCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const _EmptyChartCard(
        title: 'Doanh thu theo tháng',
        message: 'Chưa có dữ liệu doanh thu theo tháng',
      );
    }

    final maxVal = data.map((e) => e.revenue).reduce((a, b) => a > b ? a : b);
    final maxScale = maxVal > 0 ? maxVal : 1.0;

    return DashboardSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Doanh thu theo tháng',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                final barHeight = (item.revenue / maxScale) * 120;
                final monthStr = 'Thg ${item.month}/${item.year.toString().substring(2)}';

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        AdminDashboardFormatters.compactRevenue(item.revenue),
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 32,
                        height: barHeight > 5 ? barHeight : 5,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.teal.shade300, Colors.teal.shade600],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        monthStr,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyChartCard extends StatelessWidget {
  final String title;
  final String message;

  const _EmptyChartCard({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return DashboardSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
