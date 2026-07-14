import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../review/presentation/widgets/write_review_dialog.dart';

final myOrdersProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.dio.get('/orders/mine');
  return response.data as List<dynamic>;
});

class MyOrdersPage extends ConsumerWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(myOrdersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Đơn hàng của tôi')),
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('Bạn chưa có đơn hàng nào.'));
          }
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final items = order['items'] as List<dynamic>;
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Đơn hàng #${order['orderId']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(order['status'], style: TextStyle(color: _getStatusColor(order['status']), fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Text(DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(order['createdAt']))),
                      const Divider(),
                      ...items.map((item) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.calendar_today),
                          title: Text(item['productName']),
                          subtitle: Text('${item['quantity']} x ${CurrencyFormatter.vnd(item['unitPrice'])}'),
                          trailing: order['status'] == 'Delivered'
                              ? TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => WriteReviewDialog(
                                        orderItemId: item['orderItemId'],
                                        productId: item['productId'],
                                      ),
                                    );
                                  },
                                  child: const Text('Đánh giá'),
                                )
                              : null,
                        );
                      }),
                      const Divider(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Tổng tiền: ${CurrencyFormatter.vnd(order['totalAmount'])}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Lỗi tải đơn hàng: $err')),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Confirmed':
        return Colors.blue;
      case 'Shipping':
        return Colors.indigo;
      case 'Delivered':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
