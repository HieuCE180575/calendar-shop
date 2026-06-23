import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/category_model.dart';

class CategoryRemoteDataSource {
  final ApiClient apiClient;

  CategoryRemoteDataSource(this.apiClient);

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.categories);
      return (response.data as List).map((e) => CategoryModel.fromJson(e)).toList();
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }
}
