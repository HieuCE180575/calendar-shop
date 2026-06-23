import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/get_product_by_id_usecase.dart';
import '../../domain/usecases/create_product_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';

final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>((ref) {
  return ProductRemoteDataSource(ref.watch(apiClientProvider));
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(ref.watch(productRemoteDataSourceProvider));
});

final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  return GetProductsUseCase(ref.watch(productRepositoryProvider));
});

final getProductByIdUseCaseProvider = Provider<GetProductByIdUseCase>((ref) {
  return GetProductByIdUseCase(ref.watch(productRepositoryProvider));
});

final createProductUseCaseProvider = Provider<CreateProductUseCase>((ref) {
  return CreateProductUseCase(ref.watch(productRepositoryProvider));
});

final updateProductUseCaseProvider = Provider<UpdateProductUseCase>((ref) {
  return UpdateProductUseCase(ref.watch(productRepositoryProvider));
});

final deleteProductUseCaseProvider = Provider<DeleteProductUseCase>((ref) {
  return DeleteProductUseCase(ref.watch(productRepositoryProvider));
});

// State of Product Filter
class ProductFilterState {
  final int? categoryId;
  final String? search;
  final double? minPrice;
  final double? maxPrice;
  final String? calendarType;
  final String sort;
  final int page;
  final int pageSize;

  const ProductFilterState({
    this.categoryId,
    this.search,
    this.minPrice,
    this.maxPrice,
    this.calendarType,
    this.sort = 'newest',
    this.page = 1,
    this.pageSize = 6,
  });

  ProductFilterState copyWith({
    int? categoryId,
    String? search,
    double? minPrice,
    double? maxPrice,
    String? calendarType,
    String? sort,
    int? page,
    int? pageSize,
    bool clearCategory = false,
    bool clearCalendarType = false,
  }) {
    return ProductFilterState(
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      search: search ?? this.search,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      calendarType: clearCalendarType ? null : (calendarType ?? this.calendarType),
      sort: sort ?? this.sort,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

class ProductFilterNotifier extends StateNotifier<ProductFilterState> {
  ProductFilterNotifier() : super(const ProductFilterState());

  void setCategory(int? categoryId) {
    if (categoryId == null) {
      state = state.copyWith(clearCategory: true, page: 1);
    } else {
      state = state.copyWith(categoryId: categoryId, page: 1);
    }
  }

  void setSearch(String? search) {
    state = state.copyWith(search: search, page: 1);
  }

  void setPrices(double? min, double? max) {
    state = state.copyWith(minPrice: min, maxPrice: max, page: 1);
  }

  void setCalendarType(String? calendarType) {
    if (calendarType == null) {
      state = state.copyWith(clearCalendarType: true, page: 1);
    } else {
      state = state.copyWith(calendarType: calendarType, page: 1);
    }
  }

  void setSort(String sort) {
    state = state.copyWith(sort: sort, page: 1);
  }

  void setPage(int page) {
    state = state.copyWith(page: page);
  }

  void nextPage() {
    state = state.copyWith(page: state.page + 1);
  }

  void prevPage() {
    if (state.page > 1) {
      state = state.copyWith(page: state.page - 1);
    }
  }

  void reset() {
    state = const ProductFilterState();
  }
}

final productFilterProvider = StateNotifierProvider<ProductFilterNotifier, ProductFilterState>((ref) {
  return ProductFilterNotifier();
});

// Auto-disposing future provider linked to filter state with OData pagination
final productListProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  final filter = ref.watch(productFilterProvider);
  final skip = (filter.page - 1) * filter.pageSize;
  return ref.watch(getProductsUseCaseProvider)(
    categoryId: filter.categoryId,
    search: filter.search,
    minPrice: filter.minPrice,
    maxPrice: filter.maxPrice,
    calendarType: filter.calendarType,
    sort: filter.sort,
    top: filter.pageSize,
    skip: skip,
  );
});

// Admin product list provider (includes hidden products)
final adminProductListProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  return ref.watch(getProductsUseCaseProvider)(
    includeHidden: true,
  );
});

// Product detail provider
final productDetailProvider = FutureProvider.family.autoDispose<Product, int>((ref, id) async {
  return ref.watch(getProductByIdUseCaseProvider)(id);
});

// Admin actions state representation
class AdminProductActionState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  const AdminProductActionState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });
}

class AdminProductActionNotifier extends StateNotifier<AdminProductActionState> {
  final Ref ref;

  AdminProductActionNotifier(this.ref) : super(const AdminProductActionState());

  Future<bool> createProduct({
    required int categoryId,
    required String productName,
    String? description,
    required double price,
    required int stockQuantity,
    String? imageUrl,
    required String calendarType,
    required String status,
  }) async {
    state = const AdminProductActionState(isLoading: true);
    try {
      await ref.read(createProductUseCaseProvider)(
        categoryId: categoryId,
        productName: productName,
        description: description,
        price: price,
        stockQuantity: stockQuantity,
        imageUrl: imageUrl,
        calendarType: calendarType,
        status: status,
      );
      state = const AdminProductActionState(isSuccess: true);
      ref.invalidate(productListProvider);
      ref.invalidate(adminProductListProvider);
      return true;
    } catch (e) {
      state = AdminProductActionState(error: e.toString());
      return false;
    }
  }

  Future<bool> updateProduct(
    int id, {
    required int categoryId,
    required String productName,
    String? description,
    required double price,
    required int stockQuantity,
    String? imageUrl,
    required String calendarType,
    required String status,
  }) async {
    state = const AdminProductActionState(isLoading: true);
    try {
      await ref.read(updateProductUseCaseProvider)(
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
      state = const AdminProductActionState(isSuccess: true);
      ref.invalidate(productListProvider);
      ref.invalidate(adminProductListProvider);
      ref.invalidate(productDetailProvider(id));
      return true;
    } catch (e) {
      state = AdminProductActionState(error: e.toString());
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    state = const AdminProductActionState(isLoading: true);
    try {
      await ref.read(deleteProductUseCaseProvider)(id);
      state = const AdminProductActionState(isSuccess: true);
      ref.invalidate(productListProvider);
      ref.invalidate(adminProductListProvider);
      return true;
    } catch (e) {
      state = AdminProductActionState(error: e.toString());
      return false;
    }
  }
}

final adminProductActionNotifierProvider =
    StateNotifierProvider<AdminProductActionNotifier, AdminProductActionState>((ref) {
  return AdminProductActionNotifier(ref);
});
