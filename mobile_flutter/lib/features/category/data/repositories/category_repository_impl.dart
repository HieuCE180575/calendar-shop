import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_datasource.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Category>> getCategories() async {
    final models = await remoteDataSource.getCategories();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Category> createCategory(String name, String? description, String status) async {
    final model = await remoteDataSource.createCategory(name, description, status);
    return model.toEntity();
  }

  @override
  Future<void> updateCategory(int id, String name, String? description, String status) async {
    return remoteDataSource.updateCategory(id, name, description, status);
  }

  @override
  Future<void> deleteCategory(int id) async {
    return remoteDataSource.deleteCategory(id);
  }
}
