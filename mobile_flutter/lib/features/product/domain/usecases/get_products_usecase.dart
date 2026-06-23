import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<Product>> call({
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
    return repository.getProducts(
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
  }
}
