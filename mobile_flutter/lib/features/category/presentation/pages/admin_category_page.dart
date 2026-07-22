import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/category_provider.dart';
import '../widgets/category_form_dialog.dart';

import '../../../admin/presentation/widgets/admin_page_layout.dart';
import '../../../admin/presentation/widgets/admin_category_stats_section.dart';
import '../../../admin/presentation/providers/admin_stats_provider.dart';

class AdminCategoryPage extends ConsumerWidget {
  const AdminCategoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryListProvider);

    return AdminPageLayout(
      title: 'Quản lý Danh Mục',
      currentRoute: '/admin/categories',
      actions: [
        IconButton(
          icon: const Icon(Icons.add_box_outlined, size: 28, color: Colors.blue),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const CategoryFormDialog(),
            );
          },
          tooltip: 'Thêm danh mục mới',
        ),
      ],
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(categoryListProvider);
          ref.invalidate(adminCategoryStatsProvider);
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: AdminCategoryStatsSection(),
            ),
          ),
          categoriesAsync.when(
            data: (categories) {
              if (categories.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text('Chưa có danh mục nào.')),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.all(12),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final cat = categories[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.withValues(alpha: 0.1),
                            child: const Icon(Icons.category, color: Colors.blue),
                          ),
                          title: Text(cat.categoryName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(cat.description ?? 'Không có mô tả'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: cat.status == 'Active' ? Colors.green.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  cat.status == 'Active' ? 'Hoạt động' : 'Đã ẩn',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: cat.status == 'Active' ? Colors.green : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => CategoryFormDialog(category: cat),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
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
                        ),
                      );
                    },
                    childCount: categories.length,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, _) => SliverFillRemaining(
              child: Center(child: Text('Lỗi: $err')),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
