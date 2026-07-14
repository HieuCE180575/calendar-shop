import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/favorite_model.dart';

class FavoriteRemoteDataSource {
  final ApiClient apiClient;

  FavoriteRemoteDataSource(this.apiClient);

  Future<List<FavoriteModel>> getFavorites() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.favorites);
      final List dataList = response.data as List;
      return dataList.map((e) => FavoriteModel.fromJson(e)).toList();
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<void> addFavorite(int productId) async {
    try {
      await apiClient.dio.post(ApiConstants.favorites, data: {
        'productId': productId,
      });
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<void> removeFavorite(int productId) async {
    try {
      await apiClient.dio.delete('${ApiConstants.favorites}/$productId');
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<bool> checkFavorite(int productId) async {
    try {
      final response = await apiClient.dio.get('${ApiConstants.favorites}/check/$productId');
      return response.data as bool;
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }
}
