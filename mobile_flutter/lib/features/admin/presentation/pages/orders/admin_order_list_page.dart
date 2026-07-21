import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../providers/admin_order_provider.dart';

class AdminOrderListPage extends ConsumerWidget {
  const AdminOrderListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(adminOrdersProvider);
    final currentStatus = ref.watch(adminOrderStatusFilterProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Quản lý Đơn hàng'),
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
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Tìm khách hàng / SĐT...',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      prefixIcon: Icon(Icons.search, color: Colors.blue.shade700),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (val) {
                      ref.read(adminOrderSearchQueryProvider.notifier).setQuery(val);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: currentStatus,
                      icon: Icon(Icons.filter_list, color: Colors.blue.shade700),
                      style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                      items: const [
                        DropdownMenuItem(value: 'All', child: Text('Tất cả')),
                        DropdownMenuItem(value: 'Pending', child: Text('Chờ xử lý')),
                        DropdownMenuItem(value: 'Confirmed', child: Text('Đã xác nhận')),
                        DropdownMenuItem(value: 'Shipping', child: Text('Đang giao')),
                        DropdownMenuItem(value: 'Delivered', child: Text('Đã giao')),
                        DropdownMenuItem(value: 'Cancelled', child: Text('Đã hủy')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          ref.read(adminOrderStatusFilterProvider.notifier).setStatus(val);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ordersAsync.when(
              data: (orders) {
                if (orders.isEmpty) {
                  return const Center(child: Text('Không tìm thấy đơn hàng nào.', style: TextStyle(color: Colors.grey)));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
                    
                    Color statusColor = Colors.grey;
                    if (order.status == 'Pending') statusColor = Colors.orange;
                    if (order.status == 'Confirmed') statusColor = Colors.blue;
                    if (order.status == 'Shipping') statusColor = Colors.purple;
                    if (order.status == 'Delivered') statusColor = Colors.green;
                    if (order.status == 'Cancelled') statusColor = Colors.red;

                    return Card(
                      color: Colors.white,
                      elevation: 1,
                      shadowColor: Colors.black.withValues(alpha: 0.05),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          context.push('/admin/orders/${order.orderId}', extra: order);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Cột 1: Thông tin đơn
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Đơn #${order.orderId}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                          const SizedBox(height: 8),
                                          Text(DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt.toLocal()), style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                                        ],
                                      ),
                                    ),
                                    // Cột 2: Khách hàng
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.person_outline, size: 16, color: Colors.grey.shade600),
                                              const SizedBox(width: 4),
                                              Expanded(child: Text(order.customerName, style: TextStyle(color: Colors.grey.shade800, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(Icons.phone_outlined, size: 16, color: Colors.grey.shade600),
                                              const SizedBox(width: 4),
                                              Expanded(child: Text(order.customerPhone, style: TextStyle(color: Colors.grey.shade800, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Cột 3: Thanh toán và Số lượng SP
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.payment, size: 16, color: Colors.grey.shade600),
                                              const SizedBox(width: 4),
                                              Expanded(child: Text(order.paymentMethod, style: TextStyle(color: Colors.grey.shade800, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(Icons.inventory_2_outlined, size: 16, color: Colors.grey.shade600),
                                              const SizedBox(width: 4),
                                              Expanded(child: Text('${order.items.length} SP', style: TextStyle(color: Colors.grey.shade800, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Cột 4: Tổng tiền và Trạng thái
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: statusColor.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              order.status,
                                              style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            formatCurrency.format(order.totalAmount),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue.shade700,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert, color: Colors.grey),
                                onSelected: (newStatus) async {
                                  try {
                                    final repo = ref.read(adminOrderRepositoryProvider);
                                    await repo.updateOrderStatus(order.orderId, newStatus);
                                    ref.invalidate(adminOrdersProvider);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Đã cập nhật trạng thái đơn #${order.orderId} thành $newStatus')),
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Lỗi cập nhật trạng thái: $e')),
                                      );
                                    }
                                  }
                                },
                                itemBuilder: (context) {
                                  List<PopupMenuEntry<String>> items = [];
                                  if (order.status == 'Pending') {
                                    items.add(const PopupMenuItem(value: 'Confirmed', child: Text('Xác nhận (Confirmed)')));
                                    items.add(const PopupMenuItem(value: 'Cancelled', child: Text('Hủy đơn', style: TextStyle(color: Colors.red))));
                                  } else if (order.status == 'Confirmed') {
                                    items.add(const PopupMenuItem(value: 'Shipping', child: Text('Giao hàng (Shipping)')));
                                  } else if (order.status == 'Shipping') {
                                    items.add(const PopupMenuItem(value: 'Delivered', child: Text('Đã giao (Delivered)')));
                                  }
                                  
                                  if (items.isEmpty) {
                                    items.add(const PopupMenuItem(value: '', enabled: false, child: Text('Không có hành động')));
                                  }
                                  return items;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Lỗi: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
