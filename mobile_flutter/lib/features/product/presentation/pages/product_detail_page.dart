import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/product_provider.dart';

class ProductDetailPage extends ConsumerWidget {
  final int productId;

  const ProductDetailPage({super.key, required this.productId});

  void _handleDelete(BuildContext context, WidgetRef ref) {
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
                  .deleteProduct(productId);
              if (success) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Xóa sản phẩm thành công!')),
                  );
                  context.pop(); // Quay về danh sách
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
    final productAsync = ref.watch(productDetailProvider(productId));
    final authState = ref.watch(authNotifierProvider);
    final actionState = ref.watch(adminProductActionNotifierProvider);

    final isAdmin = authState.user?.role == 'Admin';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết sản phẩm'),
        actions: [
          if (isAdmin) ...[
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blueAccent),
              onPressed: () {
                // Điều hướng sang trang sửa
                productAsync.whenData((product) {
                  context.push('/admin/products/edit', extra: product);
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => _handleDelete(context, ref),
            ),
          ],
        ],
      ),
      body: Stack(
        children: [
          productAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, __) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Lỗi: $err', style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(productDetailProvider(productId)),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
            data: (product) {
              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 80), // Chừa khoảng trống cho Bottom Bar
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ảnh sản phẩm
                    Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade100, Colors.blue.shade50],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                          ? Image.network(
                              product.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.calendar_month,
                                size: 100,
                                color: Colors.blueAccent,
                              ),
                            )
                          : const Icon(
                              Icons.calendar_today,
                              size: 100,
                              color: Colors.blueAccent,
                            ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Loại lịch & Trạng thái
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  product.calendarType,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              _buildStatusBadge(product.status),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Tên sản phẩm
                          Text(
                            product.productName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Giá
                          Text(
                            CurrencyFormatter.vnd(product.price),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Danh mục & Tồn kho
                          Row(
                            children: [
                              const Icon(Icons.category_outlined, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                'Danh mục: ${product.categoryName ?? 'Chưa xác định'}',
                                style: const TextStyle(fontSize: 14, color: Colors.black87),
                              ),
                              const Spacer(),
                              const Icon(Icons.inventory_2_outlined, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                'Còn lại: ${product.stockQuantity}',
                                style: const TextStyle(fontSize: 14, color: Colors.black87),
                              ),
                            ],
                          ),
                          const Divider(height: 24),

                          // Mô tả
                          const Text(
                            'Mô tả sản phẩm',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.description != null && product.description!.isNotEmpty
                                ? product.description!
                                : 'Chưa có mô tả cho sản phẩm này.',
                            style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (actionState.isLoading)
            const ContainerOverlay(child: CircularProgressIndicator()),
        ],
      ),
      bottomNavigationBar: productAsync.maybeWhen(
        data: (product) {
          if (isAdmin) {
            return const SizedBox.shrink(); // Admin dùng appbar actions để Sửa / Xóa
          }
          final isAvailable = product.status == 'Active' && product.stockQuantity > 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isAvailable
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Thêm vào giỏ hàng thành công! (Chức năng thuộc nhiệm vụ Người 3)'),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isAvailable ? 'Thêm vào giỏ hàng' : 'Hết hàng',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        orElse: () => const SizedBox.shrink(),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Overlay widget hiển thị khi đang load xử lý API
class ContainerOverlay extends StatelessWidget {
  final Widget child;

  const ContainerOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.3),
      alignment: Alignment.center,
      child: child,
    );
  }
}
