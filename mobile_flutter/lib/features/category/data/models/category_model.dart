import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.categoryId,
    required super.categoryName,
    super.description,
    required super.status,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'] ?? '',
      description: json['description'],
      status: json['status'] ?? 'Active',
    );
  }
}
