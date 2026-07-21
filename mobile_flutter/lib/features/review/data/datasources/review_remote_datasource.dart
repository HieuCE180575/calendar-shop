import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/review_model.dart';
import '../models/product_rating_summary_model.dart';

class ReviewRemoteDataSource {
  final ApiClient apiClient;

  ReviewRemoteDataSource(this.apiClient);

  Future<List<ReviewModel>> getProductReviews(int productId) async {
    try {
      final response = await apiClient.dio.get('${ApiConstants.reviews}/product/$productId');
      final List dataList = response.data as List;
      return dataList.map((e) => ReviewModel.fromJson(e)).toList();
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<ProductRatingSummaryModel> getProductRatingSummary(int productId) async {
    try {
      final response = await apiClient.dio.get('${ApiConstants.reviews}/product/$productId/summary');
      return ProductRatingSummaryModel.fromJson(response.data);
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<void> createReview(int orderItemId, int rating, String? comment) async {
    try {
      await apiClient.dio.post(ApiConstants.reviews, data: {
        'orderItemId': orderItemId,
        'rating': rating,
        'comment': comment,
      });
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }
}
