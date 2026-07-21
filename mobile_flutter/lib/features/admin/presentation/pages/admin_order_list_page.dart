import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_search_bar.dart';
import '../../../../core/widgets/status_chip.dart';

final adminOrdersProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.dio.get('/orders/admin');
  return response.data as List<dynamic>;
});

class AdminOrderListPage extends ConsumerStatefulWidget {
  const AdminOrderListPage({super.key});

  @override
  ConsumerState<AdminOrderListPage> createState() => _AdminOrderListPageState();
}

class _AdminOrderListPageState extends ConsumerState<AdminOrderListPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final List<String> _tabs = ['Tất cả', 'Chờ xác nhận', 'Đã xác nhận', 'Đang giao', 'Đã giao', 'Đã hủy'];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String _mapTabToStatus(String tab) {
    switch (tab) {
      case 'Chờ xác nhận':
        return 'Pending';
      case 'Đã xác nhận':
        return 'Confirmed';
      case 'Đang giao':
        return 'Shipping';
      case 'Đã giao':
        return 'Delivered';
      case 'Đã hủy':
        return 'Cancelled';
      default:
        return 'ALL';
    }
  }

  Future<void> _updateStatus(int orderId, String newStatus) async {
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.dio.put('/orders/admin/$orderId/status', data: {
        'status': newStatus,
      });
      ref.invalidate(adminOrdersProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã cập nhật trạng thái đơn thành $newStatus'), backgroundColor: AppColors.success),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi cập nhật: $e'), backgroundColor: AppColors.danger),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(adminOrdersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.go('/admin'),
        ),
        title: const Text('Quản lý Đơn hàng', style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMuted,
          indicatorColor: AppColors.primary,
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
          onTap: (_) => setState(() {}),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppSearchBar(
              controller: _searchController,
              hintText: 'Tìm theo tên khách hoặc SĐT...',
              onChanged: (val) {
                setState(() => _searchQuery = val.trim().toLowerCase());
              },
            ),
          ),
          Expanded(
            child: ordersAsync.when(
              data: (orders) {
                final currentStatus = _mapTabToStatus(_tabs[_tabController.index]);
                var filtered = orders.where((o) {
                  final matchesStatus = currentStatus == 'ALL' || o['status']?.toString().toLowerCase() == currentStatus.toLowerCase();
                  final name = (o['receiverName'] ?? o['fullName'] ?? '').toString().toLowerCase();
                  final phone = (o['receiverPhone'] ?? o['phone'] ?? '').toString().toLowerCase();
                  final matchesSearch = _searchQuery.isEmpty || name.contains(_searchQuery) || phone.contains(_searchQuery);
                  return matchesStatus && matchesSearch;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text('Không tìm thấy đơn hàng nào.', style: TextStyle(color: AppColors.textSecondary)),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(adminOrdersProvider),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final order = filtered[index];
                      final status = order['status'] ?? 'Pending';
                      final orderId = order['orderId'];
                      final total = order['totalAmount'] ?? 0;
                      final items = order['items'] as List<dynamic>? ?? [];

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                          boxShadow: const [
                            BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Đơn hàng #$orderId', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                StatusChip(status: status),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Khách hàng: ${order['receiverName'] ?? order['fullName'] ?? 'Khách lẻ'} • ${order['receiverPhone'] ?? ''}',
                              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(order['createdAt'])),
                              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                            ),
                            const Divider(height: 20),

                            Text('Sản phẩm (${items.length}):', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            ...items.take(2).map((it) => Text('• ${it['productName']} x${it['quantity']}', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
                            if (items.length > 2)
                              Text('... và ${items.length - 2} sản phẩm khác', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),

                            const Divider(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tổng: ${CurrencyFormatter.vnd(total)}',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                                ),

                                // Status action buttons
                                Wrap(
                                  spacing: 6,
                                  children: [
                                    if (status == 'Pending') ...[
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(minimumSize: const Size(80, 34), backgroundColor: AppColors.primary),
                                        onPressed: () => _updateStatus(orderId, 'Confirmed'),
                                        child: const Text('Xác nhận', style: TextStyle(fontSize: 12)),
                                      ),
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(minimumSize: const Size(60, 34), foregroundColor: AppColors.danger),
                                        onPressed: () => _updateStatus(orderId, 'Cancelled'),
                                        child: const Text('Hủy', style: TextStyle(fontSize: 12)),
                                      ),
                                    ],
                                    if (status == 'Confirmed')
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(minimumSize: const Size(90, 34), backgroundColor: const Color(0xFF0284C7)),
                                        onPressed: () => _updateStatus(orderId, 'Shipping'),
                                        child: const Text('Giao hàng', style: TextStyle(fontSize: 12)),
                                      ),
                                    if (status == 'Shipping')
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(minimumSize: const Size(90, 34), backgroundColor: AppColors.success),
                                        onPressed: () => _updateStatus(orderId, 'Delivered'),
                                        child: const Text('Hoàn thành', style: TextStyle(fontSize: 12)),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (err, _) => Center(child: Text('Lỗi: $err', style: const TextStyle(color: AppColors.danger))),
            ),
          ),
        ],
      ),
    );
  }
}
