import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/admin_discount.dart';
import '../providers/admin_discount_provider.dart';
import '../../../product/presentation/providers/product_provider.dart';
import '../../../category/presentation/providers/category_provider.dart';

class AdminDiscountFormPage extends ConsumerStatefulWidget {
  final AdminDiscount? discount;

  const AdminDiscountFormPage({super.key, this.discount});

  @override
  ConsumerState<AdminDiscountFormPage> createState() => _AdminDiscountFormPageState();
}

class _AdminDiscountFormPageState extends ConsumerState<AdminDiscountFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _discountValueController;
  List<int> _selectedProductIds = [];
  List<int> _selectedCategoryIds = [];

  String _discountType = 'Percent';
  String _status = 'Active';
  String _scope = 'Product';

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.discount?.name ?? '');
    _discountValueController = TextEditingController(
        text: widget.discount != null ? widget.discount!.discountValue.toString() : '');
    if (widget.discount != null) {
      _discountType = widget.discount!.discountType;
      _status = widget.discount!.status;
      _startDate = widget.discount!.startDate;
      _endDate = widget.discount!.endDate;
      _selectedProductIds = List.from(widget.discount!.productIds);
      _scope = 'Product';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _discountValueController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context, bool isStart) async {
    final initialDate = isStart ? _startDate : _endDate;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null && context.mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (pickedTime != null) {
        setState(() {
          final newDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          if (isStart) {
            _startDate = newDateTime;
          } else {
            _endDate = newDateTime;
          }
        });
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final discountValue = double.parse(_discountValueController.text.trim());

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDay = DateTime(_startDate.year, _startDate.month, _startDate.day);
    final endDay = DateTime(_endDate.year, _endDate.month, _endDate.day);

    if (startDay.isBefore(today)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ngày bắt đầu không được trong quá khứ.')),
      );
      return;
    }

    if (endDay.isBefore(startDay)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ngày kết thúc phải lớn hơn hoặc bằng ngày bắt đầu.')),
      );
      return;
    }

    // Nếu startDay và endDay giống nhau, EndDate sẽ lấy cuối ngày đó (23:59:59)
    DateTime finalEndDate = _endDate;
    if (startDay.isAtSameMomentAs(endDay)) {
      finalEndDate = DateTime(
        _endDate.year,
        _endDate.month,
        _endDate.day,
        23,
        59,
        59,
      );
    }

    final success = widget.discount == null
        ? await ref.read(adminDiscountActionNotifierProvider.notifier).createDiscount(
              name: name,
              discountType: _discountType,
              discountValue: discountValue,
              startDate: _startDate.toUtc(),
              endDate: finalEndDate.toUtc(),
              status: _status,
              scope: _scope,
              targetIds: _scope == 'Product' ? _selectedProductIds : _selectedCategoryIds,
            )
        : await ref.read(adminDiscountActionNotifierProvider.notifier).updateDiscount(
              widget.discount!.discountId,
              name: name,
              discountType: _discountType,
              discountValue: discountValue,
              startDate: _startDate.toUtc(),
              endDate: finalEndDate.toUtc(),
              status: _status,
              scope: _scope,
              targetIds: _scope == 'Product' ? _selectedProductIds : _selectedCategoryIds,
            );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                widget.discount == null ? 'Tạo thành công' : 'Cập nhật thành công')),
      );
      context.pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Có lỗi xảy ra, vui lòng thử lại')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(adminDiscountActionNotifierProvider);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.discount == null ? 'Thêm Giảm giá mới' : 'Cập nhật Giảm giá'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.black, 
          fontSize: 18, 
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Thông tin chung', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: _buildInputDecoration('Tên Giảm giá (Bắt buộc)'),
                    validator: (v) => v == null || v.isEmpty ? 'Vui lòng nhập tên' : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _discountType,
                          decoration: _buildInputDecoration('Loại giảm'),
                          items: const [
                            DropdownMenuItem(value: 'Percent', child: Text('Theo %')),
                            DropdownMenuItem(value: 'FixedAmount', child: Text('Số tiền (VND)')),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _discountType = val);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _discountValueController,
                          keyboardType: TextInputType.number,
                          decoration: _buildInputDecoration('Giá trị giảm'),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Bắt buộc';
                            final val = double.tryParse(v);
                            if (val == null || val <= 0) return 'Phải > 0';
                            if (_discountType == 'Percent' && val > 100) return 'Phải <= 100';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text('Phạm vi áp dụng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _scope,
                          decoration: _buildInputDecoration('Áp dụng cho'),
                          items: const [
                            DropdownMenuItem(value: 'Product', child: Text('Sản phẩm')),
                            DropdownMenuItem(value: 'Category', child: Text('Danh mục')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _scope = val;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _openMultiSelectDialog(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade50,
                            foregroundColor: Colors.blue.shade700,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.list),
                          label: Text(_scope == 'Product' 
                              ? 'Chọn SP (${_selectedProductIds.length})' 
                              : 'Chọn Danh mục (${_selectedCategoryIds.length})',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text('Thời gian & Trạng thái', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDateTime(context, true),
                          child: InputDecorator(
                            decoration: _buildInputDecoration('Ngày bắt đầu'),
                            child: Text(dateFormat.format(_startDate)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDateTime(context, false),
                          child: InputDecorator(
                            decoration: _buildInputDecoration('Ngày kết thúc'),
                            child: Text(dateFormat.format(_endDate)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _status,
                    decoration: _buildInputDecoration('Trạng thái'),
                    items: const [
                      DropdownMenuItem(value: 'Active', child: Text('Hoạt động')),
                      DropdownMenuItem(value: 'Inactive', child: Text('Không hoạt động')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _status = val);
                    },
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Text(
                        widget.discount == null ? 'TẠO GIẢM GIÁ MỚI' : 'CẬP NHẬT THAY ĐỔI',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.white.withOpacity(0.8),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
      ),
    );
  }
  Future<void> _openMultiSelectDialog() async {
    try {
      if (_scope == 'Product') {
        final items = await ref.read(productListProvider.future);
        if (!context.mounted) return;
        final result = await showDialog<List<int>>(
          context: context,
          builder: (context) => _MultiSelectDialog(
            title: 'Chọn Sản phẩm',
            items: items.map((e) => _MultiSelectItem(e.productId, e.productName)).toList(),
            initialSelected: _selectedProductIds,
          ),
        );
        if (result != null) {
          setState(() => _selectedProductIds = result);
        }
      } else {
        final items = await ref.read(categoryListProvider.future);
        if (!context.mounted) return;
        final result = await showDialog<List<int>>(
          context: context,
          builder: (context) => _MultiSelectDialog(
            title: 'Chọn Danh mục',
            items: items.map((e) => _MultiSelectItem(e.categoryId, e.categoryName)).toList(),
            initialSelected: _selectedCategoryIds,
          ),
        );
        if (result != null) {
          setState(() => _selectedCategoryIds = result);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đang tải dữ liệu, vui lòng thử lại sau')));
      }
    }
  }
}

class _MultiSelectItem {
  final int id;
  final String name;
  _MultiSelectItem(this.id, this.name);
}

class _MultiSelectDialog extends StatefulWidget {
  final String title;
  final List<_MultiSelectItem> items;
  final List<int> initialSelected;

  const _MultiSelectDialog({required this.title, required this.items, required this.initialSelected});

  @override
  State<_MultiSelectDialog> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<_MultiSelectDialog> {
  late List<int> _selected;
  String _searchQuery = '';
  int _currentPage = 1;
  static const int _itemsPerPage = 5; // Có thể điều chỉnh số lượng mỗi trang (ví dụ 5 hoặc 10)

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.initialSelected);
  }

  @override
  Widget build(BuildContext context) {
    // Lọc theo từ khóa
    final filteredItems = widget.items
        .where((item) => item.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    // Tính toán phân trang
    final totalPages = (filteredItems.length / _itemsPerPage).ceil();
    if (_currentPage > totalPages && totalPages > 0) {
      _currentPage = totalPages;
    } else if (totalPages == 0) {
      _currentPage = 1;
    }

    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    final paginatedItems = filteredItems.sublist(
      startIndex,
      endIndex > filteredItems.length ? filteredItems.length : endIndex,
    );

    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Tìm kiếm',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                  _currentPage = 1; // Reset về trang 1
                });
              },
            ),
            const SizedBox(height: 12),
            if (filteredItems.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Không tìm thấy kết quả nào.'),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: paginatedItems.length,
                  itemBuilder: (context, index) {
                    final item = paginatedItems[index];
                    final isSelected = _selected.contains(item.id);
                    return CheckboxListTile(
                      title: Text(item.name),
                      value: isSelected,
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            _selected.add(item.id);
                          } else {
                            _selected.remove(item.id);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
            if (totalPages > 1) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _currentPage > 1
                        ? () => setState(() => _currentPage--)
                        : null,
                  ),
                  Text('$_currentPage / $totalPages'),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _currentPage < totalPages
                        ? () => setState(() => _currentPage++)
                        : null,
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _selected),
          child: const Text('Xong'),
        ),
      ],
    );
  }
}
