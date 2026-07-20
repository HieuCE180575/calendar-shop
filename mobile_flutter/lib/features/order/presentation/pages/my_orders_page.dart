import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../review/presentation/widgets/write_review_dialog.dart';

final myOrdersProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.dio.get('/orders/mine', queryParameters: {'\$orderby': 'CreatedAt desc'});
  
  if (response.data is Map && (response.data as Map).containsKey('value')) {
    return response.data['value'] as List<dynamic>;
  } else if (response.data is List) {
    return response.data as List<dynamic>;
  }
  return [];
});

class MyOrdersPage extends ConsumerStatefulWidget {
  const MyOrdersPage({super.key});

  @override
  ConsumerState<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends ConsumerState<MyOrdersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Tất cả', 'Chờ xác nhận', 'Đã xác nhận', 'Đang giao', 'Đã giao', 'Đã hủy'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(myOrdersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Material(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textMuted,
              indicatorColor: AppColors.primary,
              tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
              onTap: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: ordersAsync.when(
        data: (allOrders) {
          final currentTabStatus = _mapTabToStatus(_tabs[_tabController.index]);
          final filteredOrders = currentTabStatus == 'ALL'
              ? allOrders
              : allOrders.where((o) => o['status']?.toString().toLowerCase() == currentTabStatus.toLowerCase()).toList();

          if (filteredOrders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.textMuted),
                  const SizedBox(height: 12),
                  const Text('Chưa có đơn hàng nào', style: TextStyle(fontSize: 15, color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/products'),
                    child: const Text('Mua sắm ngay'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(myOrdersProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filteredOrders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                final items = order['items'] as List<dynamic>;
                final status = order['status'] ?? 'Pending';

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
                          Text(
                            'Mã đơn: #${order['orderId']}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                          ),
                          StatusChip(status: status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(order['createdAt'])),
                        style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                      ),
                      const Divider(height: 20),

                      ...items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['productName'] ?? '',
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary),
                                    ),
                                    Text(
                                      '${item['quantity']} x ${CurrencyFormatter.vnd(item['unitPrice'])}',
                                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                              if (status == 'Delivered')
                                TextButton(
                                  onPressed: () {
                                    if (item['review'] != null) {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Đánh giá của bạn'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: List.generate(5, (index) {
                                                  return Icon(
                                                    index < (item['review']['rating'] ?? 5) ? Icons.star : Icons.star_border,
                                                    color: Colors.amber,
                                                    size: 20,
                                                  );
                                                }),
                                              ),
                                              const SizedBox(height: 12),
                                              Text(item['review']['comment'] ?? 'Không có nhận xét'),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(ctx),
                                              child: const Text('Đóng'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.pop(ctx);
                                                try {
                                                  final apiClient = ref.read(apiClientProvider);
                                                  await apiClient.dio.delete('/reviews/${item['review']['reviewId']}');
                                                  ref.invalidate(myOrdersProvider);
                                                } catch (e) {
                                                  if (context.mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
                                                  }
                                                }
                                              },
                                              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => WriteReviewDialog(
                                          orderItemId: item['orderItemId'],
                                          productId: item['productId'],
                                        ),
                                      ).then((_) => ref.invalidate(myOrdersProvider));
                                    }
                                  },
                                  child: Text(item['review'] != null ? 'Xem đánh giá' : 'Đánh giá'),
                                ),
                            ],
                          ),
                        );
                      }),
                      const Divider(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Tổng thanh toán:', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                              Text(
                                CurrencyFormatter.vnd(order['totalAmount']),
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary),
                              ),
                            ],
                          ),
                          // Re-order Button ("Mua lại")
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(110, 38),
                              backgroundColor: AppColors.primaryLight,
                              foregroundColor: AppColors.primary,
                              elevation: 0,
                            ),
                            onPressed: () async {
                              final apiClient = ref.read(apiClientProvider);
                              try {
                                await apiClient.dio.post('/orders/${order['orderId']}/reorder');
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Đã thêm sản phẩm vào giỏ hàng!')),
                                  );
                                  context.push('/cart');
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
                                }
                              }
                            },
                            icon: const Icon(Icons.replay, size: 16),
                            label: const Text('Mua lại'),
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
        error: (err, _) => Center(child: Text('Lỗi tải đơn hàng: $err', style: const TextStyle(color: AppColors.danger))),
      ),
          ),
        ],
      ),
    );
  }
}
