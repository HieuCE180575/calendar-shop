import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/review_remote_datasource.dart';
import '../../data/repositories/review_repository_impl.dart';
import '../../domain/entities/review.dart';
import '../../domain/entities/product_rating_summary.dart';
import '../../domain/repositories/review_repository.dart';
import '../../domain/usecases/create_review_usecase.dart';
import '../../domain/usecases/get_product_rating_summary_usecase.dart';
import '../../domain/usecases/get_product_reviews_usecase.dart';

final reviewRemoteDataSourceProvider = Provider<ReviewRemoteDataSource>((ref) {
  return ReviewRemoteDataSource(ref.watch(apiClientProvider));
});

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepositoryImpl(ref.watch(reviewRemoteDataSourceProvider));
});

final getProductReviewsUseCaseProvider = Provider<GetProductReviewsUseCase>((ref) {
  return GetProductReviewsUseCase(ref.watch(reviewRepositoryProvider));
});

final getProductRatingSummaryUseCaseProvider =
    Provider<GetProductRatingSummaryUseCase>((ref) {
  return GetProductRatingSummaryUseCase(ref.watch(reviewRepositoryProvider));
});

final createReviewUseCaseProvider = Provider<CreateReviewUseCase>((ref) {
  return CreateReviewUseCase(ref.watch(reviewRepositoryProvider));
});

final productReviewsProvider = FutureProvider.family.autoDispose<List<Review>, int>((ref, productId) async {
  return ref.watch(getProductReviewsUseCaseProvider)(productId);
});

final productRatingSummaryProvider = FutureProvider.family.autoDispose<ProductRatingSummary, int>((ref, productId) async {
  return ref.watch(getProductRatingSummaryUseCaseProvider)(productId);
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
      await ref.read(createReviewUseCaseProvider)(orderItemId, rating, comment);
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
