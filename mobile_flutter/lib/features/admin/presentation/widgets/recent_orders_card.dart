import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/admin_dashboard_stats.dart';
import 'admin_dashboard_formatters.dart';

class RecentOrdersCard extends StatelessWidget {
  final List<RecentOrder> orders;

  const RecentOrdersCard({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history_rounded, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                const Text(
                  'DON HANG GAN DAY',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final order = orders[index];
                final dateStr = DateFormat('dd/MM HH:mm').format(order.createdAt);
                
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: Icon(Icons.receipt, color: Colors.blue.shade400, size: 20),
                  ),
                  title: Text(
                    order.customerName.isNotEmpty ? order.customerName : 'Khach hang #${order.orderId}',
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '#${order.orderId} • $dateStr',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        AdminDashboardFormatters.currency.format(order.totalAmount),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.status,
                        style: TextStyle(
                          fontSize: 11,
                          color: _getStatusColor(order.status),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'processing':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
