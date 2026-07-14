import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/category_provider.dart';
import '../widgets/category_form_dialog.dart';

class AdminCategoryPage extends ConsumerWidget {
  const AdminCategoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Danh Mục'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const CategoryFormDialog(),
              );
            },
          ),
        ],
      ),
      body: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('Chưa có danh mục nào.'));
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(categoryListProvider);
            },
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                return ListTile(
                  leading: const Icon(Icons.category),
                  title: Text(cat.categoryName),
                  subtitle: Text(cat.description ?? 'Không có mô tả'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        cat.status == 'Active' ? Icons.check_circle : Icons.cancel,
                        color: cat.status == 'Active' ? Colors.green : Colors.grey,
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => CategoryFormDialog(category: cat),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Xác nhận xóa'),
                              content: Text('Bạn có chắc chắn muốn xóa danh mục "${cat.categoryName}" không?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  onPressed: () async {
                                    Navigator.pop(ctx);
                                    await ref.read(adminCategoryActionNotifierProvider.notifier).deleteCategory(cat.categoryId);
                                  },
                                  child: const Text('Xóa'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Lỗi: $err')),
      ),
    );
  }
}
