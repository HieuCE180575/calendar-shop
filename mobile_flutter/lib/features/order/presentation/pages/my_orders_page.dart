import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../review/presentation/widgets/write_review_dialog.dart';
import '../../domain/entities/order.dart';
import '../providers/order_provider.dart';

class MyOrdersPage extends ConsumerStatefulWidget {
  const MyOrdersPage({super.key});

  @override
  ConsumerState<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends ConsumerState<MyOrdersPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;

  final List<String> _tabs = const [
    'Tất cả',
    'Chờ xác nhận',
    'Đã xác nhận',
    'Đang giao',
    'Đã giao',
    'Đã hủy',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: _tabs.length, vsync: this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(myOrdersProvider);
    }
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
      appBar: AppBar(
        title: const Text(
          'Đơn hàng của tôi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMuted,
          indicatorColor: AppColors.primary,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
          onTap: (_) => setState(() {}),
        ),
      ),
      body: ordersAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                const SizedBox(height: 10),
                Text(
                  'Không thể tải đơn hàng: $err',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: () => ref.invalidate(myOrdersProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
        data: (allOrders) {
          final currentTabStatus = _mapTabToStatus(_tabs[_tabController.index]);
          final filteredOrders = currentTabStatus == 'ALL'
              ? allOrders
              : allOrders
                  .where(
                    (order) =>
                        order.status.toLowerCase() ==
                        currentTabStatus.toLowerCase(),
                  )
                  .toList();

          if (filteredOrders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Chưa có đơn hàng nào',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                    ),
                  ),
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
<<<<<<< Updated upstream
                return _buildOrderCard(context, order);
=======
                final items = order['items'] as List<dynamic>;
                final status = order['status'] ?? 'Pending';

                return GestureDetector(
                  onTap: () {
                    context.push('/orders/${order['orderId']}');
                  },
                  child: Container(
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
                                  mainAxisSize: MainAxisSize.min,
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
                ),
                );
>>>>>>> Stashed changes
              },
            ),
          );
        },

      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderEntity order) {
    final dateText = DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/orders/${order.orderId}'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mã đơn: #${order.orderId}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  StatusChip(status: order.status),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                dateText,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
              const Divider(height: 20),
              ...order.items.map(
                (item) => Padding(
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
                        child: const Icon(
                          Icons.calendar_today,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.productName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '${item.quantity} x ${CurrencyFormatter.vnd(item.unitPrice)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (order.status == 'Delivered')
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => WriteReviewDialog(
                                orderItemId: item.orderItemId,
                                productId: item.productId,
                              ),
                            );
                          },
                          child: const Text('Đánh giá'),
                        ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tổng thanh toán:',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.vnd(order.totalAmount),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(110, 38),
                      backgroundColor: AppColors.primaryLight,
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                    ),
                    onPressed: () async {
                      for (final item in order.items) {
                        try {
                          await ref.read(cartProvider.notifier).addItem(
                                item.productId,
                                item.quantity,
                              );
                        } catch (_) {}
                      }

                      if (context.mounted) {
                        context.push('/cart');
                      }
                    },
                    icon: const Icon(Icons.replay, size: 16),
                    label: const Text('Mua lại'),
                  ),
                ],
              ),
            ],
          ),
        ),

      ),
    );
  }
}
