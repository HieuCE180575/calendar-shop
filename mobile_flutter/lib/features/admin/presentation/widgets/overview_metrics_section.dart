import 'package:flutter/material.dart';

import '../../domain/entities/admin_dashboard_stats.dart';
import 'admin_dashboard_formatters.dart';

class OverviewMetricsSection extends StatelessWidget {
  final AdminDashboardStats stats;

  const OverviewMetricsSection({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.3,
      children: [
        _MetricCard(
          title: 'TONG DOANH THU',
          value: AdminDashboardFormatters.currency.format(stats.totalRevenue),
          icon: Icons.monetization_on_rounded,
          gradient: LinearGradient(
            colors: [Colors.indigo.shade700, Colors.blue.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        _MetricCard(
          title: 'TONG DON HANG',
          value: AdminDashboardFormatters.number.format(stats.totalOrders),
          icon: Icons.receipt_long_rounded,
          gradient: LinearGradient(
            colors: [Colors.teal.shade700, Colors.teal.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        _MetricCard(
          title: 'SAN PHAM DA BAN',
          value: AdminDashboardFormatters.number.format(stats.totalProductsSold),
          icon: Icons.shopping_basket_rounded,
          gradient: LinearGradient(
            colors: [Colors.orange.shade700, Colors.amber.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        _MetricCard(
          title: 'TONG KHACH HANG',
          value: AdminDashboardFormatters.number.format(stats.totalUsers),
          icon: Icons.people_alt_rounded,
          gradient: LinearGradient(
            colors: [Colors.purple.shade700, Colors.purpleAccent.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Gradient gradient;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              Icon(icon, color: Colors.white, size: 22),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
