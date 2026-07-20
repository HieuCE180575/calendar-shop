import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/create_order_request.dart';
import '../providers/order_provider.dart';
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
            context.go('/vnpay-waiting/${order.orderId}');
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Khong the mo trang thanh toan VNPay'),
              ),
            );
            context.go('/orders');
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Dat hang thanh cong!')),
          );
          context.go('/orders');
        }
      }

      ref.invalidate(cartProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dat hang that bai: $e')),
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
        title: const Text('Thanh toan'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'So dien thoai',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Vui long nhap so dien thoai'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Dia chi giao hang',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Vui long nhap dia chi'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _noteController,
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
                        child: const Text(
                          'Xac nhan dat hang',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
