import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../providers/product_provider.dart';

class AdminProductListPage extends ConsumerWidget {
  const AdminProductListPage({super.key});

  void _handleDelete(BuildContext context, WidgetRef ref, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa sản phẩm này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ref
                  .read(adminProductActionNotifierProvider.notifier)
                  .deleteProduct(id);
              if (success) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Xóa sản phẩm thành công!')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(adminProductListProvider);
    final actionState = ref.watch(adminProductActionNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý sản phẩm (Admin)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined, size: 28),
            onPressed: () => context.push('/admin/products/new'),
            tooltip: 'Thêm sản phẩm mới',
          ),
        ],
      ),
      body: Stack(
        children: [
          productsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, __) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Lỗi: $err', style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(adminProductListProvider),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
            data: (products) {
              if (products.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Chưa có sản phẩm nào trong cửa hàng.'),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => context.push('/admin/products/new'),
                        icon: const Icon(Icons.add),
                        label: const Text('Thêm sản phẩm đầu tiên'),
                      ),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async => ref.invalidate(adminProductListProvider),
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: products.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade50,
                          child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                              ? Image.network(
                                  product.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.calendar_month, color: Colors.blueAccent),
                                )
                              : const Icon(Icons.calendar_month, color: Colors.blueAccent),
                        ),
                        title: Text(
                          product.productName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Loại: ${product.calendarType} • Tồn kho: ${product.stockQuantity}'),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  CurrencyFormatter.vnd(product.price),
                                  style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                _buildStatusBadge(product.status),
                              ],
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                              onPressed: () => context.push('/admin/products/edit', extra: product),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () => _handleDelete(context, ref, product.productId),
                            ),
                          ],
                        ),
                        onTap: () => context.push('/products/${product.productId}'),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          if (actionState.isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String text;
    switch (status) {
      case 'Active':
        color = Colors.green;
        text = 'Đang bán';
        break;
      case 'OutOfStock':
        color = Colors.orange;
        text = 'Hết hàng';
        break;
      case 'Hidden':
        color = Colors.grey;
        text = 'Ẩn';
        break;
      default:
        color = Colors.black;
        text = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
