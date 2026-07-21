import '../entities/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories();
  Future<Category> createCategory(String name, String? description, String status);
  Future<void> updateCategory(int id, String name, String? description, String status);
  Future<void> deleteCategory(int id);
}
