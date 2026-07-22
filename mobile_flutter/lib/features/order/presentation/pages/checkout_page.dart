import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/create_order_input.dart';
import '../providers/order_provider.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../address/domain/entities/address.dart';
import '../../../address/presentation/providers/address_provider.dart';
import '../../../address/presentation/widgets/address_selection_bottom_sheet.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({
    super.key,
    this.couponCode,
    this.discountAmount = 0.0,
    this.cartTotal = 0.0,
  });

  final String? couponCode;
  final double discountAmount;
  final double cartTotal;

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final _noteController = TextEditingController();
  Address? _selectedAddress;
  String _paymentMethod = 'COD';
  bool _isLoading = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  String _formatAddress(Address addr) {
    final parts = [addr.addressLine, addr.ward, addr.district, addr.province];
    return parts.where((p) => p != null && p.isNotEmpty).join(', ');
  }

  Future<void> _submitOrder() async {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn địa chỉ giao hàng')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final input = CreateOrderInput(
        customerName: _selectedAddress!.receiverName,
        customerPhone: _selectedAddress!.receiverPhone,
        shippingAddress: _formatAddress(_selectedAddress!),
        paymentMethod: _paymentMethod,
        couponCode: widget.couponCode,
        note: _noteController.text.trim(),
      );

      final createOrderUseCase = ref.read(createOrderUseCaseProvider);
      final order = await createOrderUseCase(input);

      if (_paymentMethod == 'VNPay') {
        final getVNPayUrlUseCase = ref.read(getVNPayUrlUseCaseProvider);
        final urlString = await getVNPayUrlUseCase(order.orderId);
        final url = Uri.parse(urlString);

        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
          if (mounted) {
            context.go('/vnpay-waiting/${order.orderId}');
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Không thể mở trang thanh toán VNPay'),
              ),
            );
            context.go('/orders');
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đặt hàng thành công!')),
          );
          context.go('/orders');
        }
      }

      ref.invalidate(cartProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đặt hàng thất bại: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _changeAddress(List<Address> addresses) async {
    final result = await showModalBottomSheet<Address>(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddressSelectionBottomSheet(
        currentSelectedAddress: _selectedAddress,
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _selectedAddress = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final addressState = ref.watch(addressListProvider);

    final shippingFee = widget.cartTotal >= 300000 ? 0.0 : 30000.0;
    final totalAmount = (widget.cartTotal - widget.discountAmount) + shippingFee;
    final finalTotal = totalAmount > 0 ? totalAmount : 0.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Thanh toán', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thông tin giao hàng',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  addressState.when(
                    loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                    error: (e, st) => Text('Lỗi tải địa chỉ: $e'),
                    data: (addresses) {
                      if (_selectedAddress == null && addresses.isNotEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          final defaultAddr = addresses.firstWhere(
                            (a) => a.isDefault,
                            orElse: () => addresses.first,
                          );
                          setState(() {
                            _selectedAddress = defaultAddr;
                          });
                        });
                      }

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_selectedAddress == null)
                              const Text('Chưa có địa chỉ. Vui lòng thêm!', style: TextStyle(color: AppColors.textMuted))
                            else ...[
                              Text(
                                '${_selectedAddress!.receiverName} | ${_selectedAddress!.receiverPhone}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _formatAddress(_selectedAddress!),
                                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                              ),
                            ],
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () => _changeAddress(addresses),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppColors.primary),
                                  foregroundColor: AppColors.primary,
                                ),
                                child: Text(_selectedAddress == null ? 'Thêm địa chỉ' : 'Thay đổi địa chỉ'),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Note Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TextField(
                      controller: _noteController,
                      decoration: const InputDecoration(
                        labelText: 'Ghi chú (tùy chọn)',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Payment Method
                  const Text(
                    'Phương thức thanh toán',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          value: 'COD',
                          groupValue: _paymentMethod,
                          activeColor: AppColors.primary,
                          title: const Text('Thanh toán khi nhận hàng (COD)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                          onChanged: (val) => setState(() => _paymentMethod = val!),
                        ),
                        const Divider(height: 1, color: AppColors.border),
                        RadioListTile<String>(
                          value: 'VNPay',
                          groupValue: _paymentMethod,
                          activeColor: AppColors.primary,
                          title: const Text('Thanh toán qua VNPay', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                          onChanged: (val) => setState(() => _paymentMethod = val!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Order Summary Breakdown
                  const Text(
                    'Chi tiết thanh toán',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow('Tạm tính', widget.cartTotal),
                        const SizedBox(height: 8),
                        _buildSummaryRow('Phí vận chuyển', shippingFee),
                        if (widget.discountAmount > 0) ...[
                          const SizedBox(height: 8),
                          _buildSummaryRow('Giảm giá', widget.discountAmount, isDiscount: true),
                        ],
                        const Divider(height: 24, color: AppColors.border),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Tổng cộng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            Text(
                              CurrencyFormatter.vnd(finalTotal),
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
      bottomSheet: _isLoading
          ? null
          : Container(
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
                onPressed: _selectedAddress == null ? null : _submitOrder,
                child: const Text('Xác nhận đặt hàng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        Text(
          isDiscount ? '-${CurrencyFormatter.vnd(value)}' : CurrencyFormatter.vnd(value),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDiscount ? AppColors.danger : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
