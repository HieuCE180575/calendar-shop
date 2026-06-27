import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../providers/cart_provider.dart';
import '../../domain/entities/cart_item.dart';

/// Màn hình danh sách Giỏ hàng (Cart Page) ở tầng Presentation.
class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lắng nghe danh sách giỏ hàng từ CartProvider
    final cartState = ref.watch(cartProvider);
    // Lắng nghe tổng tiền động từ CartTotalProvider
    final cartTotal = ref.watch(cartTotalProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng của tôi'),
        centerTitle: true,
        elevation: 0,
      ),
      body: cartState.when(
        // Trạng thái đang tải dữ liệu
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        // Trạng thái xảy ra lỗi (như lỗi kết nối API)
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                const SizedBox(height: 10),
                Text(
                  'Không thể tải giỏ hàng: $error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: () => ref.invalidate(cartProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
        // Trạng thái tải giỏ hàng thành công
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
                  const SizedBox(height: 15),
                  const Text(
                    'Giỏ hàng của bạn đang trống!',
                    style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () => context.go('/products'),
                    child: const Text('Mua sắm ngay'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _buildCartItemCard(context, ref, item);
                  },
                ),
              ),
              _buildCheckoutSummaryBar(context, cartTotal),
            ],
          );
        },
      ),
    );
  }

  /// Hàm dựng Card hiển thị từng sản phẩm trong giỏ hàng
  Widget _buildCartItemCard(BuildContext context, WidgetRef ref, CartItemEntity item) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Checkbox tích chọn sản phẩm để thanh toán
            Checkbox(
              value: item.isSelected,
              activeColor: Colors.deepOrange,
              onChanged: (isSelected) async {
                if (isSelected != null) {
                  try {
                    await ref.read(cartProvider.notifier).toggleSelect(
                          item.cartItemId,
                          isSelected,
                          item.quantity,
                        );
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Không thể chọn sản phẩm: $e')),
                      );
                    }
                  }
                }
              },
            ),
            // Ảnh sản phẩm có bộ nhớ đệm (CachedNetworkImage)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: SizedBox(
                width: 70,
                height: 70,
                child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: item.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.calendar_today, color: Colors.grey),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            // Thông tin sản phẩm (Tên, giá, tổng tiền của dòng)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Đơn giá: ${item.price.toStringAsFixed(0)} đ',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tổng: ${item.lineTotal.toStringAsFixed(0)} đ',
                    style: const TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Bộ tăng/giảm số lượng và nút Xóa
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    // Nút giảm số lượng
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
                      onPressed: item.quantity > 1
                          ? () async {
                              try {
                                await ref.read(cartProvider.notifier).updateQuantity(
                                      item.cartItemId,
                                      item.quantity - 1,
                                      item.isSelected,
                                    );
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Không thể giảm số lượng: $e')),
                                  );
                                }
                              }
                            }
                          : null, // Vô hiệu hóa nút nếu số lượng bằng 1
                    ),
                    Text(
                      '${item.quantity}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    // Nút tăng số lượng
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: Colors.grey),
                      onPressed: item.quantity < item.stockQuantity
                          ? () async {
                              try {
                                await ref.read(cartProvider.notifier).updateQuantity(
                                      item.cartItemId,
                                      item.quantity + 1,
                                      item.isSelected,
                                    );
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Không thể tăng số lượng: $e')),
                                  );
                                }
                              }
                            }
                          : null, // Vô hiệu hóa nút nếu vượt quá tồn kho thực tế
                    ),
                  ],
                ),
                // Nút xóa sản phẩm khỏi giỏ hàng
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Xác nhận xóa'),
                        content: const Text('Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Hủy'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              try {
                                await ref.read(cartProvider.notifier).removeItem(item.cartItemId);
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Không thể xóa sản phẩm: $e')),
                                  );
                                }
                              }
                            },
                            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Hàm dựng thanh tổng tiền và nút thanh toán dán chặt ở đáy màn hình
  Widget _buildCheckoutSummaryBar(BuildContext context, double cartTotal) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(158, 158, 158, 0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Tổng tiền:',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 2),
              Text(
                '${cartTotal.toStringAsFixed(0)} đ',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: cartTotal > 0
                ? () {
                    // TODO: Chuyển sang màn hình checkout đặt hàng
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tính năng Thanh toán đang được phát triển.')),
                    );
                  }
                : null, // Vô hiệu hóa nút nếu không chọn sản phẩm nào để mua
            child: const Text(
              'Thanh toán',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
