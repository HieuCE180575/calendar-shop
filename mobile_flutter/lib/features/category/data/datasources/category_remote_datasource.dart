import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/category_model.dart';

class CategoryRemoteDataSource {
  final ApiClient apiClient;

  CategoryRemoteDataSource(this.apiClient);

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.categories);
      final List dataList;
      if (response.data is Map && (response.data as Map).containsKey('value')) {
        dataList = response.data['value'] as List;
      } else if (response.data is List) {
        dataList = response.data as List;
      } else {
        dataList = [];
      }
      return dataList.map((e) => CategoryModel.fromJson(e)).toList();
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<CategoryModel> createCategory(String name, String? description, String status) async {
    try {
      final response = await apiClient.dio.post(ApiConstants.categories, data: {
        'categoryName': name,
        'description': description,
        'status': status,
      });
      return CategoryModel.fromJson(response.data);
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<void> updateCategory(int id, String name, String? description, String status) async {
    try {
      await apiClient.dio.put('${ApiConstants.categories}/$id', data: {
        'categoryName': name,
        'description': description,
        'status': status,
      });
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      await apiClient.dio.delete('${ApiConstants.categories}/$id');
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }
}
