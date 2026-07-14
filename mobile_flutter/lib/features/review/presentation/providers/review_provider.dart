import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/review_remote_datasource.dart';
import '../../data/repositories/review_repository_impl.dart';
import '../../domain/entities/review.dart';
import '../../domain/entities/product_rating_summary.dart';
import '../../domain/repositories/review_repository.dart';

final reviewRemoteDataSourceProvider = Provider<ReviewRemoteDataSource>((ref) {
  return ReviewRemoteDataSource(ref.watch(apiClientProvider));
});

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepositoryImpl(ref.watch(reviewRemoteDataSourceProvider));
});

final productReviewsProvider = FutureProvider.family.autoDispose<List<Review>, int>((ref, productId) async {
  return ref.watch(reviewRepositoryProvider).getProductReviews(productId);
});

final productRatingSummaryProvider = FutureProvider.family.autoDispose<ProductRatingSummary, int>((ref, productId) async {
  return ref.watch(reviewRepositoryProvider).getProductRatingSummary(productId);
});

class ReviewActionState {
  final bool isLoading;
  final String? error;

  const ReviewActionState({
    this.isLoading = false,
    this.error,
  });
}

class ReviewActionNotifier extends StateNotifier<ReviewActionState> {
  final Ref ref;

  ReviewActionNotifier(this.ref) : super(const ReviewActionState());

  Future<bool> createReview(int orderItemId, int rating, String? comment, int productId) async {
    state = const ReviewActionState(isLoading: true);
    try {
      await ref.read(reviewRepositoryProvider).createReview(orderItemId, rating, comment);
      state = const ReviewActionState();
      
      // Refresh reviews and summary for the product
      ref.invalidate(productReviewsProvider(productId));
      ref.invalidate(productRatingSummaryProvider(productId));
      return true;
    } catch (e) {
      state = ReviewActionState(error: e.toString());
      return false;
    }
  }
}

final reviewActionNotifierProvider =
    StateNotifierProvider<ReviewActionNotifier, ReviewActionState>((ref) {
  return ReviewActionNotifier(ref);
});
