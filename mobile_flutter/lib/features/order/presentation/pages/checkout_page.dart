import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/order_provider.dart';
import '../../data/models/create_order_request.dart';
import '../../../cart/presentation/providers/cart_provider.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();
  String _paymentMethod = 'COD';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final request = CreateOrderRequest(
        customerName: _nameController.text.trim(),
        customerPhone: _phoneController.text.trim(),
        shippingAddress: _addressController.text.trim(),
        paymentMethod: _paymentMethod,
        note: _noteController.text.trim(),
      );

      final createOrderUseCase = ref.read(createOrderUseCaseProvider);
      final order = await createOrderUseCase(request);

      if (_paymentMethod == 'VNPay') {
        final getVNPayUrlUseCase = ref.read(getVNPayUrlUseCaseProvider);
        final urlString = await getVNPayUrlUseCase(order.orderId);
        final url = Uri.parse(urlString);

        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
          if (mounted) {
            context.go('/orders');
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Không thể mở trang thanh toán VNPay')),
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
      
      // Refresh cart
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Thông tin giao hàng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Họ tên', border: OutlineInputBorder()),
                      validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập họ tên' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'Số điện thoại', border: OutlineInputBorder()),
                      validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập số điện thoại' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(labelText: 'Địa chỉ giao hàng', border: OutlineInputBorder()),
                      validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập địa chỉ' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _noteController,
                      decoration: const InputDecoration(labelText: 'Ghi chú (Tùy chọn)', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 24),
                    const Text('Phương thức thanh toán', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    RadioListTile<String>(
                      title: const Text('Thanh toán khi nhận hàng (COD)'),
                      value: 'COD',
                      groupValue: _paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _paymentMethod = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Thanh toán VNPay'),
                      value: 'VNPay',
                      groupValue: _paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _paymentMethod = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitOrder,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.deepOrange,
                        ),
                        child: const Text('Xác nhận đặt hàng', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
