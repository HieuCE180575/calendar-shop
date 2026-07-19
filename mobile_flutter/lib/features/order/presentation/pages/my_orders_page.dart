import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
<<<<<<< HEAD
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../review/presentation/widgets/write_review_dialog.dart';
import '../../domain/entities/order.dart';
import '../providers/order_provider.dart';

=======
import '../providers/order_provider.dart';
import '../widgets/order_card_widget.dart';

/// Màn hình danh sách đơn hàng của người dùng hiện tại.
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
class MyOrdersPage extends ConsumerStatefulWidget {
  const MyOrdersPage({super.key});

  @override
  ConsumerState<MyOrdersPage> createState() => _MyOrdersPageState();
}

<<<<<<< HEAD
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

=======
class _MyOrdersPageState extends ConsumerState<MyOrdersPage> with WidgetsBindingObserver {
  
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
<<<<<<< HEAD
    _tabController = TabController(length: _tabs.length, vsync: this);
=======
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
<<<<<<< HEAD
    _tabController.dispose();
=======
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(myOrdersProvider);
    }
  }

<<<<<<< HEAD
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
=======
  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(myOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn hàng của tôi'),
        centerTitle: true,
      ),
      body: ordersState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                const SizedBox(height: 10),
                Text(
<<<<<<< HEAD
                  'Không thể tải đơn hàng: $err',
=======
                  'Không thể tải đơn hàng: $error',
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
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
<<<<<<< HEAD
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
=======
        data: (orders) {
          if (orders.isEmpty) {
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
<<<<<<< HEAD
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
=======
                  const Icon(Icons.receipt_long_outlined,
                      size: 80, color: Colors.grey),
                  const SizedBox(height: 15),
                  const Text(
                    'Bạn chưa có đơn hàng nào!',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
                  ElevatedButton(
                    onPressed: () => context.go('/products'),
                    child: const Text('Mua sắm ngay'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
<<<<<<< HEAD
            onRefresh: () async => ref.invalidate(myOrdersProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filteredOrders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                return _buildOrderCard(context, order);
=======
            onRefresh: () async {
              ref.invalidate(myOrdersProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderCardWidget(
                  order: order,
                  onTap: () => context.push('/orders/${order.orderId}'),
                );
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
              },
            ),
          );
        },
<<<<<<< HEAD
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
=======
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
      ),
    );
  }
}
