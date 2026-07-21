import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/admin_order.dart';
import '../../providers/admin_order_provider.dart';

class AdminOrderDetailPage extends ConsumerStatefulWidget {
  final AdminOrder order;
  const AdminOrderDetailPage({super.key, required this.order});

  @override
  ConsumerState<AdminOrderDetailPage> createState() => _AdminOrderDetailPageState();
}

class _AdminOrderDetailPageState extends ConsumerState<AdminOrderDetailPage> {
  late AdminOrder _order;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  Future<void> _updateStatus(String newStatus) async {
    setState(() => _isLoading = true);
    try {
      final success = await ref.read(adminOrderActionProvider.notifier).updateStatus(_order.orderId, newStatus);
      if (!success) {
        throw Exception('Cập nhật trạng thái thất bại');
      }
      // Update local state
      setState(() {
        _order = _order.copyWith(status: newStatus);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật trạng thái thành $newStatus')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text('Đơn #${_order.orderId}'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.black, 
          fontSize: 18, 
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCard(
                    children: [
                      _buildSectionTitle('Thông tin giao hàng'),
                      _buildInfoRow('Tên khách hàng:', _order.customerName),
                      _buildInfoRow('Số điện thoại:', _order.customerPhone),
                      _buildInfoRow('Địa chỉ giao:', _order.shippingAddress),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildCard(
                    children: [
                      _buildSectionTitle('Thông tin thanh toán'),
                      _buildInfoRow('Tạm tính:', formatCurrency.format(_order.subTotal)),
                      _buildInfoRow('Giảm giá:', '- ${formatCurrency.format(_order.discountAmount)}', color: Colors.green),
                      _buildInfoRow('Phí vận chuyển:', formatCurrency.format(_order.shippingFee)),
                      const Divider(height: 24),
                      _buildInfoRow('Tổng thanh toán:', formatCurrency.format(_order.totalAmount), isBold: true, color: Colors.blue.shade700, size: 18),
                      const SizedBox(height: 8),
                      _buildInfoRow('Phương thức:', _order.paymentMethod),
                      _buildInfoRow('Trạng thái:', _order.status, isBold: true, color: Colors.orange),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildCard(
                    children: [
                      _buildSectionTitle('Sản phẩm (${_order.items.length})'),
                      ..._order.items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.productName, style: const TextStyle(fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 4),
                                    Text('${formatCurrency.format(item.unitPrice)} x ${item.quantity}', style: TextStyle(color: Colors.grey.shade600)),
                                  ],
                                ),
                              ),
                              Text(formatCurrency.format(item.totalPrice), style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false, Color? color, double size = 14}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: size, color: Colors.grey.shade700)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: size,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: color ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    List<Widget> buttons = [];
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.blue.shade700,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
    );

    if (_order.status == 'Pending') {
      buttons.add(Expanded(
        child: ElevatedButton(
          style: buttonStyle,
          onPressed: () => _updateStatus('Confirmed'),
          child: const Text('Xác nhận Đơn', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ));
      buttons.add(const SizedBox(width: 12));
      buttons.add(Expanded(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade50,
            foregroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          onPressed: () => _updateStatus('Cancelled'),
          child: const Text('Hủy Đơn', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ));
    } else if (_order.status == 'Confirmed') {
      buttons.add(Expanded(
        child: ElevatedButton(
          style: buttonStyle,
          onPressed: () => _updateStatus('Shipping'),
          child: const Text('Bắt đầu Giao hàng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ));
    } else if (_order.status == 'Shipping') {
      buttons.add(Expanded(
        child: ElevatedButton(
          style: buttonStyle,
          onPressed: () => _updateStatus('Delivered'),
          child: const Text('Hoàn tất Giao hàng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ));
    }

    if (buttons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons,
    );
  }
}
