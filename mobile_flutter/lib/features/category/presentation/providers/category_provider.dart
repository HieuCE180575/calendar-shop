import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/category_remote_datasource.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/usecases/get_categories_usecase.dart';

final categoryRemoteDataSourceProvider = Provider<CategoryRemoteDataSource>((ref) {
  return CategoryRemoteDataSource(ref.watch(apiClientProvider));
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl(ref.watch(categoryRemoteDataSourceProvider));
});

final getCategoriesUseCaseProvider = Provider<GetCategoriesUseCase>((ref) {
  return GetCategoriesUseCase(ref.watch(categoryRepositoryProvider));
});

final categoryListProvider = FutureProvider.autoDispose<List<Category>>((ref) async {
  return ref.watch(getCategoriesUseCaseProvider)();
});

class AdminCategoryActionState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  const AdminCategoryActionState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });
}

class AdminCategoryActionNotifier extends StateNotifier<AdminCategoryActionState> {
  final Ref ref;

  AdminCategoryActionNotifier(this.ref) : super(const AdminCategoryActionState());

  Future<bool> createCategory(String name, String? description, String status) async {
    state = const AdminCategoryActionState(isLoading: true);
    try {
      await ref.read(categoryRepositoryProvider).createCategory(name, description, status);
      state = const AdminCategoryActionState(isSuccess: true);
      ref.invalidate(categoryListProvider);
      return true;
    } catch (e) {
      state = AdminCategoryActionState(error: e.toString());
      return false;
    }
  }

  Future<bool> updateCategory(int id, String name, String? description, String status) async {
    state = const AdminCategoryActionState(isLoading: true);
    try {
      await ref.read(categoryRepositoryProvider).updateCategory(id, name, description, status);
      state = const AdminCategoryActionState(isSuccess: true);
      ref.invalidate(categoryListProvider);
      return true;
    } catch (e) {
      state = AdminCategoryActionState(error: e.toString());
      return false;
    }
  }

  Future<bool> deleteCategory(int id) async {
    state = const AdminCategoryActionState(isLoading: true);
    try {
      await ref.read(categoryRepositoryProvider).deleteCategory(id);
      state = const AdminCategoryActionState(isSuccess: true);
      ref.invalidate(categoryListProvider);
      return true;
    } catch (e) {
      state = AdminCategoryActionState(error: e.toString());
      return false;
    }
  }
}

final adminCategoryActionNotifierProvider =
    StateNotifierProvider<AdminCategoryActionNotifier, AdminCategoryActionState>((ref) {
  return AdminCategoryActionNotifier(ref);
});
