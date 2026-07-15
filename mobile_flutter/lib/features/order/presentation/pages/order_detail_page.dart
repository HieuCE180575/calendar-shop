import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
<<<<<<< HEAD
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../providers/order_provider.dart';

=======
import 'package:intl/intl.dart';
import '../providers/order_provider.dart';

/// Màn hình chi tiết đơn hàng.
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
class OrderDetailPage extends ConsumerStatefulWidget {
  final int orderId;

  const OrderDetailPage({super.key, required this.orderId});

  @override
  ConsumerState<OrderDetailPage> createState() => _OrderDetailPageState();
}

<<<<<<< HEAD
class _OrderDetailPageState extends ConsumerState<OrderDetailPage>
    with WidgetsBindingObserver {
=======
class _OrderDetailPageState extends ConsumerState<OrderDetailPage> with WidgetsBindingObserver {
  
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
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
<<<<<<< HEAD
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (canPop) {
              Navigator.of(context).pop();
            } else {
              context.go('/orders');
            }
          },
        ),
        title: Text('Don hang #${widget.orderId}'),
=======

    return Scaffold(
      appBar: AppBar(
        title: Text('Đơn hàng #${widget.orderId}'),
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
        centerTitle: true,
      ),
      body: orderState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
<<<<<<< HEAD
            padding: const EdgeInsets.all(20),
=======
            padding: const EdgeInsets.all(20.0),
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                const SizedBox(height: 10),
                Text(
<<<<<<< HEAD
                  'Khong the tai chi tiet don hang: $error',
=======
                  'Không thể tải chi tiết đơn hàng: $error',
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
<<<<<<< HEAD
                  onPressed: () =>
                      ref.invalidate(orderDetailProvider(widget.orderId)),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Thu lai'),
=======
                  onPressed: () => ref.invalidate(orderDetailProvider(widget.orderId)),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Thử lại'),
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
                ),
              ],
            ),
          ),
        ),
        data: (order) {
          final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

          return SingleChildScrollView(
<<<<<<< HEAD
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.local_shipping_outlined),
                    title: const Text('Trang thai'),
=======
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trạng thái đơn hàng
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.local_shipping_outlined),
                    title: const Text('Trạng thái'),
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
                    trailing: Chip(label: Text(order.status)),
                  ),
                ),
                const SizedBox(height: 12),
<<<<<<< HEAD
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Thong tin giao hang',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Divider(),
                        Text('Nguoi nhan: ${order.customerName}'),
                        const SizedBox(height: 4),
                        Text('So dien thoai: ${order.customerPhone}'),
                        const SizedBox(height: 4),
                        Text('Dia chi: ${order.shippingAddress}'),
                        const SizedBox(height: 4),
                        Text('Ngay dat: ${dateFormat.format(order.createdAt)}'),
=======

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
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
<<<<<<< HEAD
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'San pham',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Divider(),
                        ...order.items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Expanded(child: Text(item.productName)),
                                Text('x${item.quantity}'),
                                const SizedBox(width: 12),
                                Text(
                                  '${item.totalPrice.toStringAsFixed(0)} d',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
=======

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
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
<<<<<<< HEAD
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        _buildPriceRow('Tam tinh', order.subTotal),
                        if (order.discountAmount > 0)
                          _buildPriceRow('Giam gia', -order.discountAmount),
                        _buildPriceRow('Phi van chuyen', order.shippingFee),
                        const Divider(),
                        _buildPriceRow(
                          'Tong cong',
                          order.totalAmount,
                          isBold: true,
                        ),
=======

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
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
<<<<<<< HEAD
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.payment_outlined),
                    title: const Text('Phuong thuc thanh toan'),
                    trailing: Text(order.paymentMethod),
                  ),
                ),
=======

                // Phương thức thanh toán
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.payment_outlined),
                    title: const Text('Phương thức thanh toán'),
                    trailing: Text(order.paymentMethod),
                  ),
                ),

                // Ghi chú
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
                if (order.note != null && order.note!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.note_outlined),
<<<<<<< HEAD
                      title: const Text('Ghi chu'),
=======
                      title: const Text('Ghi chú'),
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
                      subtitle: Text(order.note!),
                    ),
                  ),
                ],
<<<<<<< HEAD
                const SizedBox(height: 20),
=======

                const SizedBox(height: 20),

                // Nút hủy đơn hàng (chỉ hiển thị khi status là Pending)
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
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
<<<<<<< HEAD
                        'Huy don hang',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
=======
                        'Hủy đơn hàng',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
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
<<<<<<< HEAD
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold
                ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                : null,
          ),
          Text(
            '${amount.toStringAsFixed(0)} d',
=======
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
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
            style: isBold
                ? const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
<<<<<<< HEAD
                    color: Colors.deepOrange,
                  )
=======
                    color: Colors.deepOrange)
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
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
<<<<<<< HEAD
        title: const Text('Huy don hang'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            labelText: 'Ly do huy (khong bat buoc)',
=======
        title: const Text('Hủy đơn hàng'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            labelText: 'Lý do hủy (không bắt buộc)',
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
<<<<<<< HEAD
            child: const Text('Dong'),
=======
            child: const Text('Đóng'),
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
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
<<<<<<< HEAD
                      content: Text('Da huy don hang thanh cong.'),
                    ),
=======
                        content: Text('Đã hủy đơn hàng thành công.')),
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
<<<<<<< HEAD
                    SnackBar(content: Text('Khong the huy don hang: $e')),
=======
                    SnackBar(content: Text('Không thể hủy đơn hàng: $e')),
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
                  );
                }
              }
            },
<<<<<<< HEAD
            child: const Text(
              'Xac nhan huy',
              style: TextStyle(color: Colors.red),
            ),
=======
            child:
                const Text('Xác nhận hủy', style: TextStyle(color: Colors.red)),
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
          ),
        ],
      ),
    );
  }
}
