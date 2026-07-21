import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/category.dart';
import '../providers/category_provider.dart';

class CategoryFormDialog extends ConsumerStatefulWidget {
  final Category? category;

  const CategoryFormDialog({super.key, this.category});

  @override
  ConsumerState<CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends ConsumerState<CategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.categoryName ?? '');
    _descController = TextEditingController(text: widget.category?.description ?? '');
    _isActive = (widget.category?.status ?? 'Active') == 'Active';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final desc = _descController.text.isEmpty ? null : _descController.text;
      final status = _isActive ? 'Active' : 'Inactive';

      bool success;
      if (widget.category == null) {
        success = await ref.read(adminCategoryActionNotifierProvider.notifier).createCategory(name, desc, status);
      } else {
        success = await ref
            .read(adminCategoryActionNotifierProvider.notifier)
            .updateCategory(widget.category!.categoryId, name, desc, status);
      }

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.category == null ? 'Thêm mới thành công' : 'Cập nhật thành công')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final actionState = ref.watch(adminCategoryActionNotifierProvider);

    return AlertDialog(
      title: Text(widget.category == null ? 'Thêm Danh Mục' : 'Sửa Danh Mục'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Tên danh mục', border: OutlineInputBorder()),
              validator: (val) => val == null || val.isEmpty ? 'Vui lòng nhập tên danh mục' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Mô tả (tùy chọn)', border: OutlineInputBorder()),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Trạng thái hoạt động'),
              value: _isActive,
              onChanged: (val) => setState(() => _isActive = val),
            ),
            if (actionState.error != null) ...[
              const SizedBox(height: 8),
              Text(actionState.error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: actionState.isLoading ? null : () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: actionState.isLoading ? null : _submit,
          child: actionState.isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Lưu'),
        ),
      ],
    );
  }
}
