import 'package:flutter/material.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đơn hàng của tôi')),
      body: const Center(
        child: Text('TODO: Gọi /api/orders/mine để xem danh sách đơn, chi tiết đơn, hủy đơn Pending.'),
      ),
    );
  }
}
