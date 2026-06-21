import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Product>> getProducts({
    int? categoryId,
    String? search,
    double? minPrice,
    double? maxPrice,
    String? calendarType,
    String sort = 'newest',
  }) async {
    final models = await remoteDataSource.getProducts(
      categoryId: categoryId,
      search: search,
      minPrice: minPrice,
      maxPrice: maxPrice,
      calendarType: calendarType,
      sort: sort,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Product> getProductById(int id) async {
    final model = await remoteDataSource.getProductById(id);
    return model.toEntity();
  }
}
