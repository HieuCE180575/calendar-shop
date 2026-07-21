import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/quantity_selector.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../favorite/presentation/providers/favorite_provider.dart';
import '../../../review/presentation/widgets/review_list_widget.dart';
import '../providers/product_provider.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  final int productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  int _selectedQuantity = 1;
  String _selectedSize = '30x40 cm';

  void _handleDelete(BuildContext context) {
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
                  .deleteProduct(widget.productId);
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Xóa sản phẩm thành công!')),
                );
                context.pop();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailProvider(widget.productId));
    final authState = ref.watch(authNotifierProvider);
    final actionState = ref.watch(adminProductActionNotifierProvider);
    final isAdmin = authState.user?.role == 'Admin';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('Chi tiết sản phẩm'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
          if (!isAdmin && authState.user != null)
            Consumer(
              builder: (context, ref, child) {
                final isFavoriteAsync =
                    ref.watch(checkFavoriteProvider(widget.productId));
                return isFavoriteAsync.when(
                  data: (isFavorite) => IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : AppColors.textPrimary,
                    ),
                    onPressed: () {
                      ref
                          .read(favoriteActionNotifierProvider.notifier)
                          .toggleFavorite(widget.productId, isFavorite);
                    },
                  ),
                  loading: () => const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2)),
                  error: (_, __) => const SizedBox(),
                );
              },
            ),
          if (isAdmin) ...[
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
              onPressed: () {
                productAsync.whenData((product) {
                  context.push('/admin/products/edit', extra: product);
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.danger),
              onPressed: () => _handleDelete(context),
            ),
          ],
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          productAsync.when(
            loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary)),
            error: (err, __) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: AppColors.danger),
                  const SizedBox(height: 12),
                  Text('Lỗi: $err',
                      style: const TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () =>
                        ref.invalidate(productDetailProvider(widget.productId)),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
            data: (product) {
              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Banner Image with Carousel Dots & Category Badge
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 320,
                          color: AppColors.surface,
                          child: product.imageUrl != null &&
                                  product.imageUrl!.startsWith('http')
                              ? CachedNetworkImage(
                                  imageUrl: product.imageUrl!,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => Container(
                                    color: AppColors.primaryLight,
                                    child: const Center(
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2)),
                                  ),
                                  errorWidget: (_, __, ___) => Container(
                                    color: AppColors.primaryLight,
                                    child: const Icon(Icons.calendar_month,
                                        size: 100, color: AppColors.primary),
                                  ),
                                )
                              : Container(
                                  color: AppColors.primaryLight,
                                  child: const Icon(Icons.calendar_month,
                                      size: 100, color: AppColors.primary),
                                ),
                        ),
                        // Pagination Dots Mockup
                        Positioned(
                          bottom: 12,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              4,
                              (idx) => Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                width: idx == 0 ? 16 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: idx == 0
                                      ? AppColors.primary
                                      : Colors.white.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Content Container
                    Container(
                      transform: Matrix4.translationValues(0, -16, 0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category Badge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  product.categoryName ?? product.calendarType,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              StatusChip(status: product.status),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Title
                          Text(
                            product.productName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Rating ⭐ & Stock Row
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: AppColors.secondary, size: 18),
                              const SizedBox(width: 4),
                              const Text(
                                '4.8',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppColors.textPrimary),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                '(128 đánh giá)',
                                style: TextStyle(
                                    color: AppColors.textMuted, fontSize: 13),
                              ),
                              const Spacer(),
                              Text(
                                'Kho: ${product.stockQuantity}',
                                style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Price Banner
                          Text(
                            CurrencyFormatter.vnd(product.price),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Description
                          Text(
                            product.description != null &&
                                    product.description!.isNotEmpty
                                ? product.description!
                                : 'Bộ lịch cao cấp với chất liệu giấy in sắc nét, thiết kế tinh tế phù hợp trang trí không gian sống và làm việc.',
                            style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.6),
                          ),
                          const SizedBox(height: 20),

                          // Kích thước Chips
                          const Text(
                            'Kích thước',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            children: ['30x40 cm', '40x60 cm', '50x70 cm']
                                .map((size) {
                              final isSelected = size == _selectedSize;
                              return ChoiceChip(
                                label: Text(size),
                                selected: isSelected,
                                selectedColor: AppColors.primaryLight,
                                backgroundColor: AppColors.background,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textPrimary,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.border,
                                ),
                                onSelected: (val) {
                                  setState(() => _selectedSize = size);
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),

                          // Số lượng
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Số lượng',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary),
                              ),
                              QuantitySelector(
                                quantity: _selectedQuantity,
                                maxQuantity: product.stockQuantity,
                                onChanged: (val) {
                                  setState(() => _selectedQuantity = val);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Divider(color: AppColors.divider),
                          const SizedBox(height: 12),

                          // Đánh giá sản phẩm Section
                          ReviewListWidget(productId: product.productId),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (actionState.isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                  child: CircularProgressIndicator(color: AppColors.primary)),
            ),
        ],
      ),

      // Sticky Bottom Bar with "Thêm vào giỏ" & "Mua ngay"
      bottomNavigationBar: productAsync.maybeWhen(
        data: (product) {
          if (isAdmin) return const SizedBox.shrink();
          final isAvailable =
              product.status == 'Active' && product.stockQuantity > 0;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 10,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isAvailable
                        ? () async {
                            try {
                              await ref.read(cartProvider.notifier).addItem(
                                  product.productId, _selectedQuantity);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Đã thêm sản phẩm vào giỏ hàng!'),
                                    backgroundColor: AppColors.success,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Lỗi: $e'),
                                      backgroundColor: AppColors.danger),
                                );
                              }
                            }
                          }
                        : null,
                    icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                    label: const Text('Thêm vào giỏ'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isAvailable
                        ? () async {
                            try {
                              await ref.read(cartProvider.notifier).addItem(
                                  product.productId, _selectedQuantity);
                              if (context.mounted) {
                                context.go('/cart');
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Lỗi: $e'),
                                      backgroundColor: AppColors.danger),
                                );
                              }
                            }
                          }
                        : null,
                    child: Text(isAvailable ? 'Mua ngay' : 'Hết hàng'),
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
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style:
            TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold),
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
      color: Colors.black.withValues(alpha: 0.3),
      alignment: Alignment.center,
      child: child,
    );
  }
}
