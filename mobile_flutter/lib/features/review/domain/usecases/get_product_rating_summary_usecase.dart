import '../entities/product_rating_summary.dart';
import '../repositories/review_repository.dart';

class GetProductRatingSummaryUseCase {
  final ReviewRepository repository;

  GetProductRatingSummaryUseCase(this.repository);

  Future<ProductRatingSummary> call(int productId) {
    return repository.getProductRatingSummary(productId);
  }
}
