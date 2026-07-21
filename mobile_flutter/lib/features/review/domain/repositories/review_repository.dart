import '../entities/review.dart';
import '../entities/product_rating_summary.dart';

abstract class ReviewRepository {
  Future<List<Review>> getProductReviews(int productId);
  Future<ProductRatingSummary> getProductRatingSummary(int productId);
  Future<void> createReview(int orderItemId, int rating, String? comment);
}
