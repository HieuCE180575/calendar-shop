import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
<<<<<<< HEAD

import '../../domain/entities/create_order_input.dart';
import '../providers/order_provider.dart';
=======
import '../providers/order_provider.dart';
import '../../data/models/create_order_request.dart';
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
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
<<<<<<< HEAD

=======
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
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
<<<<<<< HEAD
      final input = CreateOrderInput(
=======
      final request = CreateOrderRequest(
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
        customerName: _nameController.text.trim(),
        customerPhone: _phoneController.text.trim(),
        shippingAddress: _addressController.text.trim(),
        paymentMethod: _paymentMethod,
        note: _noteController.text.trim(),
      );

      final createOrderUseCase = ref.read(createOrderUseCaseProvider);
<<<<<<< HEAD
      final order = await createOrderUseCase(input);
=======
      final order = await createOrderUseCase(request);
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)

      if (_paymentMethod == 'VNPay') {
        final getVNPayUrlUseCase = ref.read(getVNPayUrlUseCaseProvider);
        final urlString = await getVNPayUrlUseCase(order.orderId);
        final url = Uri.parse(urlString);

        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
          if (mounted) {
<<<<<<< HEAD
            context.go('/vnpay-waiting/${order.orderId}');
=======
            context.go('/orders');
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
<<<<<<< HEAD
              const SnackBar(
                content: Text('Khong the mo trang thanh toan VNPay'),
              ),
=======
              const SnackBar(content: Text('Không thể mở trang thanh toán VNPay')),
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
            );
            context.go('/orders');
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
<<<<<<< HEAD
            const SnackBar(content: Text('Dat hang thanh cong!')),
=======
            const SnackBar(content: Text('Đặt hàng thành công!')),
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
          );
          context.go('/orders');
        }
      }
<<<<<<< HEAD

      ref.invalidate(cartProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dat hang that bai: $e')),
=======
      
      // Refresh cart
      ref.invalidate(cartProvider);
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đặt hàng thất bại: $e')),
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
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
<<<<<<< HEAD
        title: const Text('Thanh toan'),
=======
        title: const Text('Thanh toán'),
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
<<<<<<< HEAD
              padding: const EdgeInsets.all(16),
=======
              padding: const EdgeInsets.all(16.0),
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
<<<<<<< HEAD
                    const Text(
                      'Thong tin giao hang',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Ho ten',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Vui long nhap ho ten'
                          : null,
=======
                    const Text('Thông tin giao hàng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Họ tên', border: OutlineInputBorder()),
                      validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập họ tên' : null,
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
<<<<<<< HEAD
                      decoration: const InputDecoration(
                        labelText: 'So dien thoai',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Vui long nhap so dien thoai'
                          : null,
=======
                      decoration: const InputDecoration(labelText: 'Số điện thoại', border: OutlineInputBorder()),
                      validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập số điện thoại' : null,
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
<<<<<<< HEAD
                      decoration: const InputDecoration(
                        labelText: 'Dia chi giao hang',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Vui long nhap dia chi'
                          : null,
=======
                      decoration: const InputDecoration(labelText: 'Địa chỉ giao hàng', border: OutlineInputBorder()),
                      validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập địa chỉ' : null,
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _noteController,
<<<<<<< HEAD
                      decoration: const InputDecoration(
                        labelText: 'Ghi chu (tuy chon)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Phuong thuc thanh toan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment<String>(
                          value: 'COD',
                          label: Text('COD'),
                          icon: Icon(Icons.local_shipping_outlined),
                        ),
                        ButtonSegment<String>(
                          value: 'VNPay',
                          label: Text('VNPay'),
                          icon: Icon(Icons.account_balance_wallet_outlined),
                        ),
                      ],
                      selected: {_paymentMethod},
                      onSelectionChanged: (selection) {
                        setState(() {
                          _paymentMethod = selection.first;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _paymentMethod == 'COD'
                          ? 'Thanh toan khi nhan hang.'
                          : 'Ban se duoc chuyen sang cong thanh toan VNPay sau khi tao don.',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
=======
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
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
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
<<<<<<< HEAD
                        child: const Text(
                          'Xac nhan dat hang',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
=======
                        child: const Text('Xác nhận đặt hàng', style: TextStyle(fontSize: 18, color: Colors.white)),
>>>>>>> 7ece4cf (feat: implement VNPay payment integration)
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
