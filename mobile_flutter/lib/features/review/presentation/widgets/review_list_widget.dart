import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/review_provider.dart';

class ReviewListWidget extends ConsumerWidget {
  final int productId;

  const ReviewListWidget({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(productRatingSummaryProvider(productId));
    final reviewsAsync = ref.watch(productReviewsProvider(productId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Đánh giá sản phẩm',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        summaryAsync.when(
          data: (summary) {
            if (summary.totalReviews == 0) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Text('Chưa có đánh giá nào cho sản phẩm này.'),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        summary.averageRating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < summary.averageRating.round() ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 16,
                          );
                        }),
                      ),
                      Text('${summary.totalReviews} đánh giá', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildProgressBar(5, summary.star5, summary.totalReviews),
                        _buildProgressBar(4, summary.star4, summary.totalReviews),
                        _buildProgressBar(3, summary.star3, summary.totalReviews),
                        _buildProgressBar(2, summary.star2, summary.totalReviews),
                        _buildProgressBar(1, summary.star1, summary.totalReviews),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const SizedBox(),
        ),
        const Divider(),
        reviewsAsync.when(
          data: (reviews) {
            if (reviews.isEmpty) return const SizedBox();
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviews.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final review = reviews[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: review.userAvatarUrl != null
                        ? NetworkImage(review.userAvatarUrl!)
                        : null,
                    child: review.userAvatarUrl == null ? const Icon(Icons.person) : null,
                  ),
                  title: Row(
                    children: [
                      Text(review.userFullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Row(
                        children: List.generate(5, (starIndex) {
                          return Icon(
                            starIndex < review.rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 14,
                          );
                        }),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      if (review.comment != null && review.comment!.isNotEmpty)
                        Text(review.comment!),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(review.createdAt),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Lỗi tải đánh giá: $err')),
        ),
      ],
    );
  }

  Widget _buildProgressBar(int star, int count, int total) {
    final double percent = total > 0 ? count / total : 0;
    return Row(
      children: [
        Text('$star', style: const TextStyle(fontSize: 12)),
        const Icon(Icons.star, size: 12, color: Colors.grey),
        const SizedBox(width: 4),
        Expanded(
          child: LinearProgressIndicator(
            value: percent,
            backgroundColor: Colors.grey.shade300,
            color: Colors.amber,
            minHeight: 6,
          ),
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: 20,
          child: Text('$count', style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ),
      ],
    );
  }
}
