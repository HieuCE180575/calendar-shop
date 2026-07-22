import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/widgets/quantity_selector.dart';
import '../../domain/entities/cart_item.dart';
import '../providers/cart_provider.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  String? _couponCode;
  double _discountAmount = 0;
  String _paymentMethod = 'COD';

  Future<void> _checkCoupon(String code, double cartTotal) async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.dio.get('/coupons/check', queryParameters: {
        'code': code,
        'subTotal': cartTotal,
      });
      final data = response.data;
      final type = data['discountType'];
      final value = data['discountValue'] as num;

      double discount = 0;
      if (type == 'Percent') {
        discount = cartTotal * (value / 100);
      } else {
        discount = value.toDouble();
      }

      setState(() {
        _couponCode = code;
        _discountAmount = discount;
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã áp dụng mã $code'), backgroundColor: AppColors.success),
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Có lỗi xảy ra khi kiểm tra mã';
        if (e is DioException && e.response?.data != null) {
          final data = e.response!.data;
          errorMessage = data is String ? data : data.toString();
        } else {
          errorMessage = e.toString();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: AppColors.danger),
        );
      }
    }
  }

  void _showCouponBottomSheet(BuildContext context, double cartTotal) {
    final couponController = TextEditingController(text: _couponCode);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Nhập mã giảm giá', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: couponController,
                    decoration: const InputDecoration(
                      hintText: 'Nhập mã (VD: CHAOHE2026)',
                      prefixIcon: Icon(Icons.confirmation_number_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: const Size(100, 48)),
                  onPressed: () {
                    final code = couponController.text.trim().toUpperCase();
                    if (code.isNotEmpty) {
                      _checkCoupon(code, cartTotal);
                    }
                  },
                  child: const Text('Áp dụng'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final cartTotal = ref.watch(cartTotalProvider);
    final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    final itemCount = cartState.value?.length ?? 0;
    final finalTotal = (cartTotal - _discountAmount) > 0 ? (cartTotal - _discountAmount) : 0.0;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: cartState.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.danger, size: 50),
              const SizedBox(height: 10),
              Text('Lỗi: $error', style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.invalidate(cartProvider),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 80, color: AppColors.textMuted),
                  const SizedBox(height: 16),
                  const Text(
                    'Giỏ hàng của bạn đang trống!',
                    style: TextStyle(fontSize: 16, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: const Size(160, 44)),
                    onPressed: () => context.go('/products'),
                    child: const Text('Khám phá sản phẩm'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cart Item List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _buildCartItemCard(context, ref, item);
                  },
                ),
                const SizedBox(height: 20),

                // Order Price Breakdown Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tạm tính', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                          Text(currencyFormatter.format(cartTotal), style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Giảm giá', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                          Text(
                            _discountAmount > 0 ? '-${currencyFormatter.format(_discountAmount)}' : '0 đ',
                            style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () => _showCouponBottomSheet(context, cartTotal),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _couponCode != null ? 'Mã: $_couponCode' : 'Nhập mã giảm giá',
                                style: TextStyle(
                                  color: _couponCode != null ? AppColors.primary : AppColors.textMuted,
                                  fontWeight: _couponCode != null ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tổng tiền', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          Text(
                            currencyFormatter.format(finalTotal),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Shipping Address Tile
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 24),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Địa chỉ giao hàng', style: TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
                            SizedBox(height: 2),
                            Text('Nguyễn Văn An', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            Text('123 Đường Lê Lợi, Phường Bến Nghé, Quận 1, TP. Hồ Chí Minh',
                                maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Payment Method Selector Tile
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.payments_outlined, color: AppColors.primary, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Phương thức thanh toán', style: TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 2),
                            Text(
                              _paymentMethod == 'COD' ? 'Thanh toán khi nhận hàng (COD)' : 'Thanh toán trực tuyến VNPay',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (val) => setState(() => _paymentMethod = val),
                        itemBuilder: (ctx) => [
                          const PopupMenuItem<String>(value: 'COD', child: Text('Thanh toán COD')),
                          const PopupMenuItem<String>(value: 'VNPAY', child: Text('Ví VNPay')),
                        ],
                        child: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
          boxShadow: [
            BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, -3)),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size.fromHeight(50),
          ),
          onPressed: cartTotal > 0
              ? () {
                  context.push('/checkout', extra: {
                    'couponCode': _couponCode,
                    'discountAmount': _discountAmount,
                    'cartTotal': cartTotal,
                  });
                }
              : null,
          child: const Text('Thanh toán', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildCartItemCard(BuildContext context, WidgetRef ref, CartItemEntity item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Checkbox(
            value: item.isSelected,
            activeColor: AppColors.primary,
            onChanged: (isSelected) async {
              if (isSelected != null) {
                await ref.read(cartProvider.notifier).toggleSelect(item.cartItemId, isSelected, item.quantity);
              }
            },
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 64,
              height: 64,
              child: item.imageUrl != null && item.imageUrl!.startsWith('http')
                  ? CachedNetworkImage(imageUrl: item.imageUrl!, fit: BoxFit.cover)
                  : Container(color: AppColors.primaryLight, child: const Icon(Icons.calendar_today, color: AppColors.primary)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.vnd(item.price),
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 14),
                ),
                const SizedBox(height: 6),
                QuantitySelector(
                  quantity: item.quantity,
                  maxQuantity: item.stockQuantity,
                  onChanged: (newQty) async {
                    await ref.read(cartProvider.notifier).updateQuantity(item.cartItemId, newQty, item.isSelected);
                  },
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.textMuted, size: 20),
            onPressed: () async {
              await ref.read(cartProvider.notifier).removeItem(item.cartItemId);
            },
          ),
        ],
      ),
    );
  }
}
