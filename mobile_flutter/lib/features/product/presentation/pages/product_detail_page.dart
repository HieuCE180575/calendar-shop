import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../favorite/presentation/providers/favorite_provider.dart';
import '../../../review/presentation/widgets/review_list_widget.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
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
      backgroundColor: Colors.white,
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
              return CustomScrollView(
                slivers: [
                  // Hình ảnh sản phẩm (SliverAppBar)
                  SliverAppBar(
                    expandedHeight: 350.0,
                    pinned: true,
                    backgroundColor: Colors.white,
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.8),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () => context.pop(),
                        ),
                      ),
                    ),
                    actions: [
                      if (isAdmin) ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.8),
                            child: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blueAccent),
                              onPressed: () => context.push('/admin/products/edit', extra: product),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.8),
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => _handleDelete(context, ref),
                            ),
                          ),
                        ),
                      ] else ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.8),
                            child: IconButton(
                              icon: const Icon(Icons.share_outlined, color: Colors.black),
                              onPressed: () {},
                            ),
                          ),
                        ),
                        if (authState.user != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.white.withOpacity(0.8),
                              child: Consumer(
                                builder: (context, ref, child) {
                                  final isFavoriteAsync = ref.watch(checkFavoriteProvider(product.productId));
                                  return isFavoriteAsync.when(
                                    data: (isFavorite) => IconButton(
                                      icon: Icon(
                                        isFavorite ? Icons.favorite : Icons.favorite_border,
                                        color: isFavorite ? Colors.redAccent : Colors.black,
                                      ),
                                      onPressed: () {
                                        ref.read(favoriteActionNotifierProvider.notifier).toggleFavorite(product.productId, isFavorite);
                                      },
                                    ),
                                    loading: () => const CircularProgressIndicator(),
                                    error: (_, __) => const SizedBox(),
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        color: Colors.blue.shade50,
                        child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                            ? Image.network(
                                product.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
                              )
                            : const Icon(Icons.calendar_today, size: 100, color: Colors.grey),
                      ),
                    ),
                  ),

                  // Nội dung chi tiết
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Loại lịch
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              product.calendarType,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Tên sản phẩm
                          Text(
                            product.productName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Giá
                          Text(
                            CurrencyFormatter.vnd(product.price),
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Mô tả
                          Text(
                            product.description != null && product.description!.isNotEmpty
                                ? product.description!
                                : 'Bộ lịch cao cấp với hình ảnh sắc nét, giấy cao cấp. Phù hợp trang trí không gian sống và làm việc.',
                            style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
                          ),
                          const SizedBox(height: 24),

                          // Kích thước (Dummy UI)
                          const Text(
                            'Kích thước',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildSizeOption('30x40 cm', true),
                              const SizedBox(width: 12),
                              _buildSizeOption('40x60 cm', false),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Đánh giá sản phẩm
                          const Divider(height: 32),
                          ReviewListWidget(productId: product.productId),
                          
                          // Padding cho bottom bar
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          if (actionState.isLoading)
            const ContainerOverlay(child: CircularProgressIndicator()),
        ],
      ),
      bottomNavigationBar: productAsync.maybeWhen(
        data: (product) {
          if (isAdmin) return const SizedBox.shrink();

          final isAvailable = product.status == 'Active' && product.stockQuantity > 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                // Nút chọn số lượng (Dummy UI)
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 20),
                        onPressed: () {},
                      ),
                      const Text('1', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.add, size: 20),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Nút Mua ngay
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isAvailable
                        ? () async {
                            try {
                              await ref.read(cartProvider.notifier).addItem(product.productId, 1);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Đã thêm vào giỏ hàng!'),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.redAccent),
                                );
                              }
                            }
                          }
                        : null,
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: Text(
                      isAvailable ? 'Thêm vào giỏ' : 'Hết hàng',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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

  Widget _buildSizeOption(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? Colors.blueAccent : Colors.grey.shade300,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.blueAccent : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
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
