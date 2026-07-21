import '../repositories/review_repository.dart';

class CreateReviewUseCase {
  final ReviewRepository repository;

  CreateReviewUseCase(this.repository);

  Future<void> call(int orderItemId, int rating, String? comment) {
    return repository.createReview(orderItemId, rating, comment);
  }
}
