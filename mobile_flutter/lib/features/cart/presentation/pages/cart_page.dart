import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giỏ hàng')),
      body: const Center(
        child: Text('TODO: Gọi /api/cart để hiển thị, tăng giảm số lượng, chọn sản phẩm và đặt hàng.'),
      ),
    );
  }
}
