import '../../domain/entities/review.dart';
import '../../domain/entities/product_rating_summary.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/review_remote_datasource.dart';
import '../models/review_model.dart';
import '../models/product_rating_summary_model.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Review>> getProductReviews(int productId) async {
    final models = await remoteDataSource.getProductReviews(productId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<ProductRatingSummary> getProductRatingSummary(int productId) async {
    final model = await remoteDataSource.getProductRatingSummary(productId);
    return model.toEntity();
  }

  @override
  Future<void> createReview(int orderItemId, int rating, String? comment) async {
    return remoteDataSource.createReview(orderItemId, rating, comment);
  }
}
