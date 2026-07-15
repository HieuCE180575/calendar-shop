import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/order_provider.dart';

/// Màn hình chi tiết đơn hàng.
class OrderDetailPage extends ConsumerStatefulWidget {
  final int orderId;

  const OrderDetailPage({super.key, required this.orderId});

  @override
  ConsumerState<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends ConsumerState<OrderDetailPage> with WidgetsBindingObserver {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(orderDetailProvider(widget.orderId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderDetailProvider(widget.orderId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Đơn hàng #${widget.orderId}'),
        centerTitle: true,
      ),
      body: orderState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                const SizedBox(height: 10),
                Text(
                  'Không thể tải chi tiết đơn hàng: $error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: () => ref.invalidate(orderDetailProvider(widget.orderId)),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
        data: (order) {
          final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trạng thái đơn hàng
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.local_shipping_outlined),
                    title: const Text('Trạng thái'),
                    trailing: Chip(label: Text(order.status)),
                  ),
                ),
                const SizedBox(height: 12),

                // Thông tin giao hàng
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Thông tin giao hàng',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const Divider(),
                        Text('Người nhận: ${order.customerName}'),
                        const SizedBox(height: 4),
                        Text('Số điện thoại: ${order.customerPhone}'),
                        const SizedBox(height: 4),
                        Text('Địa chỉ: ${order.shippingAddress}'),
                        const SizedBox(height: 4),
                        Text('Ngày đặt: ${dateFormat.format(order.createdAt)}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Danh sách sản phẩm
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Sản phẩm',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const Divider(),
                        ...order.items.map((item) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(item.productName),
                                  ),
                                  Text('x${item.quantity}'),
                                  const SizedBox(width: 12),
                                  Text(
                                    '${item.totalPrice.toStringAsFixed(0)} đ',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Tổng tiền
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        _buildPriceRow('Tạm tính', order.subTotal),
                        if (order.discountAmount > 0)
                          _buildPriceRow('Giảm giá', -order.discountAmount),
                        _buildPriceRow('Phí vận chuyển', order.shippingFee),
                        const Divider(),
                        _buildPriceRow('Tổng cộng', order.totalAmount,
                            isBold: true),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Phương thức thanh toán
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.payment_outlined),
                    title: const Text('Phương thức thanh toán'),
                    trailing: Text(order.paymentMethod),
                  ),
                ),

                // Ghi chú
                if (order.note != null && order.note!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.note_outlined),
                      title: const Text('Ghi chú'),
                      subtitle: Text(order.note!),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Nút hủy đơn hàng (chỉ hiển thị khi status là Pending)
                if (order.status == 'Pending')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () =>
                          _showCancelDialog(context, ref, order.orderId),
                      child: const Text(
                        'Hủy đơn hàng',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: isBold
                  ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                  : null),
          Text(
            '${amount.toStringAsFixed(0)} đ',
            style: isBold
                ? const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.deepOrange)
                : null,
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, WidgetRef ref, int orderId) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hủy đơn hàng'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            labelText: 'Lý do hủy (không bắt buộc)',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Đóng'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await ref
                    .read(myOrdersProvider.notifier)
                    .cancelOrder(orderId, reasonController.text.trim());
                ref.invalidate(orderDetailProvider(orderId));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Đã hủy đơn hàng thành công.')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Không thể hủy đơn hàng: $e')),
                  );
                }
              }
            },
            child:
                const Text('Xác nhận hủy', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
