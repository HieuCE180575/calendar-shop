import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../constants/api_constants.dart';
import '../../features/favorite/presentation/providers/favorite_provider.dart';
import '../../features/product/domain/entities/product.dart';
import '../theme/app_colors.dart';

class ProductCard extends ConsumerWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavoriteAsync = ref.watch(checkFavoriteProvider(product.productId));
    final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final formattedPrice = currencyFormatter.format(product.price);
    final badgeText = product.categoryName ?? product.calendarType;
    final resolvedImageUrl = ApiConstants.resolveImageUrl(product.imageUrl);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Category Badge & Favorite Button
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: resolvedImageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: resolvedImageUrl,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Container(
                                color: AppColors.primaryLight,
                                child: const Center(
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                              errorWidget: (_, __, ___) => Container(
                                color: AppColors.primaryLight,
                                child: const Icon(Icons.calendar_today, size: 40, color: AppColors.primary),
                              ),
                            )
                          : Container(
                              color: AppColors.primaryLight,
                              child: const Icon(Icons.calendar_today, size: 40, color: AppColors.primary),
                            ),
                    ),
                  ),

                  // Category Badge Pill
                  if (badgeText.isNotEmpty)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          badgeText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                  // Sale Badge
                  if (product.originalPrice != null && product.originalPrice! > product.price)
                    Positioned(
                      top: 8,
                      left: badgeText.isNotEmpty ? null : 8,
                      right: badgeText.isNotEmpty ? 44 : null, // 44 to avoid favorite icon
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.danger,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Sale',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                  // Heart Favorite Icon
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Material(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          final isFav = isFavoriteAsync.value ?? false;
                          ref
                              .read(favoriteActionNotifierProvider.notifier)
                              .toggleFavorite(product.productId, isFav);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: isFavoriteAsync.when(
                            data: (isFav) => Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              size: 16,
                              color: isFav ? Colors.red : AppColors.textSecondary,
                            ),
                            loading: () => const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2)),
                            error: (_, __) => const Icon(
                              Icons.error_outline,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Card Body Details
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.originalPrice != null && product.originalPrice! > product.price)
                        Text(
                          currencyFormatter.format(product.originalPrice),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      Text(
                        formattedPrice,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kho: ${product.stockQuantity}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      isFavoriteAsync.maybeWhen(
                        data: (isFav) => Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          size: 14,
                          color: isFav ? Colors.red : AppColors.textMuted,
                        ),
                        orElse: () => const Icon(Icons.favorite_border,
                            size: 14, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
