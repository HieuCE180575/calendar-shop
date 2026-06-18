import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/product_model.dart';

class ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSource(this.apiClient);

  Future<List<ProductModel>> getProducts({
    int? categoryId,
    String? search,
    double? minPrice,
    double? maxPrice,
    String? calendarType,
    String sort = 'newest',
  }) async {
    try {
      final response = await apiClient.dio.get(ApiConstants.products, queryParameters: {
        if (categoryId != null) 'categoryId': categoryId,
        if (search != null && search.isNotEmpty) 'search': search,
        if (minPrice != null) 'minPrice': minPrice,
        if (maxPrice != null) 'maxPrice': maxPrice,
        if (calendarType != null && calendarType.isNotEmpty) 'calendarType': calendarType,
        'sort': sort,
      });
      return (response.data as List).map((e) => ProductModel.fromJson(e)).toList();
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await apiClient.dio.get('${ApiConstants.products}/$id');
      return ProductModel.fromJson(response.data);
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }
}
