import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Calendar Shop')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.inventory_2_outlined),
            title: const Text('Quản lý sản phẩm'),
            subtitle: const Text('Thêm, sửa, xóa, tồn kho, trạng thái'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: const Text('Quản lý danh mục'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long_outlined),
            title: const Text('Quản lý đơn hàng'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.people_alt_outlined),
            title: const Text('Quản lý người dùng'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.discount_outlined),
            title: const Text('Quản lý mã giảm giá'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart_outlined),
            title: const Text('Thống kê'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.storefront_outlined),
            title: const Text('Xem app Customer'),
            onTap: () => context.go('/products'),
          ),
        ],
      ),
    );
  }
}
