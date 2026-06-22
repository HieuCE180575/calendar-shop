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
    bool includeHidden = false,
    int? top,
    int? skip,
  }) {
    return remoteDataSource.getProducts(
      categoryId: categoryId,
      search: search,
      minPrice: minPrice,
      maxPrice: maxPrice,
      calendarType: calendarType,
      sort: sort,
      includeHidden: includeHidden,
      top: top,
      skip: skip,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Product> getProductById(int id) => remoteDataSource.getProductById(id);

  @override
  Future<Product> createProduct({
    required int categoryId,
    required String productName,
    String? description,
    required double price,
    required int stockQuantity,
    String? imageUrl,
    required String calendarType,
    required String status,
  }) {
    return remoteDataSource.createProduct(
      categoryId: categoryId,
      productName: productName,
      description: description,
      price: price,
      stockQuantity: stockQuantity,
      imageUrl: imageUrl,
      calendarType: calendarType,
      status: status,
    );
  }

  @override
  Future<void> updateProduct(
    int id, {
    required int categoryId,
    required String productName,
    String? description,
    required double price,
    required int stockQuantity,
    String? imageUrl,
    required String calendarType,
    required String status,
  }) {
    return remoteDataSource.updateProduct(
      id,
      categoryId: categoryId,
      productName: productName,
      description: description,
      price: price,
      stockQuantity: stockQuantity,
      imageUrl: imageUrl,
      calendarType: calendarType,
      status: status,
    );
  }

  @override
  Future<void> deleteProduct(int id) {
    return remoteDataSource.deleteProduct(id);
  }

  @override
  Future<Product> createProduct({
    required int categoryId,
    required String productName,
    String? description,
    required double price,
    required int stockQuantity,
    String? imageUrl,
    required String calendarType,
    required String status,
  }) async {
    final model = await remoteDataSource.createProduct(
      categoryId: categoryId,
      productName: productName,
      description: description,
      price: price,
      stockQuantity: stockQuantity,
      imageUrl: imageUrl,
      calendarType: calendarType,
      status: status,
    );
    return model.toEntity();
  }

  @override
  Future<void> updateProduct(
    int id, {
    required int categoryId,
    required String productName,
    String? description,
    required double price,
    required int stockQuantity,
    String? imageUrl,
    required String calendarType,
    required String status,
  }) {
    return remoteDataSource.updateProduct(
      id,
      categoryId: categoryId,
      productName: productName,
      description: description,
      price: price,
      stockQuantity: stockQuantity,
      imageUrl: imageUrl,
      calendarType: calendarType,
      status: status,
    );
  }

  @override
  Future<void> deleteProduct(int id) {
    return remoteDataSource.deleteProduct(id);
  }
}
