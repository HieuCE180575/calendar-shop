import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../category/presentation/providers/category_provider.dart';
import '../../domain/entities/product.dart';
import '../providers/product_provider.dart';

class AdminProductFormPage extends ConsumerStatefulWidget {
  final Product? product;

  const AdminProductFormPage({super.key, this.product});

  @override
  ConsumerState<AdminProductFormPage> createState() => _AdminProductFormPageState();
}

class _AdminProductFormPageState extends ConsumerState<AdminProductFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _imageUrlController = TextEditingController();

  int? _selectedCategoryId;
  String _selectedCalendarType = 'Wall Calendar';
  String _selectedStatus = 'Active';

  final List<String> _calendarTypes = [
    'Wall Calendar',
    'Desk Calendar',
    'Bloc Calendar',
    'Planner',
    'Custom Calendar'
  ];

  final List<String> _statusOptions = [
    'Active',
    'OutOfStock',
    'Hidden'
  ];

  bool get _isEditMode => widget.product != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      final p = widget.product!;
      _nameController.text = p.productName;
      _descController.text = p.description ?? '';
      _priceController.text = p.price.toStringAsFixed(0);
      _stockController.text = p.stockQuantity.toString();
      _imageUrlController.text = p.imageUrl ?? '';
      _selectedCategoryId = p.categoryId;
      if (_calendarTypes.contains(p.calendarType)) {
        _selectedCalendarType = p.calendarType;
      }
      if (_statusOptions.contains(p.status)) {
        _selectedStatus = p.status;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn danh mục!')),
      );
      return;
    }

    final name = _nameController.text.trim();
    final desc = _descController.text.trim();
    final price = double.parse(_priceController.text.trim());
    final stock = int.parse(_stockController.text.trim());
    final imgUrl = _imageUrlController.text.trim();

    final notifier = ref.read(adminProductActionNotifierProvider.notifier);
    bool success;

    if (_isEditMode) {
      success = await notifier.updateProduct(
        widget.product!.productId,
        categoryId: _selectedCategoryId!,
        productName: name,
        description: desc.isNotEmpty ? desc : null,
        price: price,
        stockQuantity: stock,
        imageUrl: imgUrl.isNotEmpty ? imgUrl : null,
        calendarType: _selectedCalendarType,
        status: _selectedStatus,
      );
    } else {
      success = await notifier.createProduct(
        categoryId: _selectedCategoryId!,
        productName: name,
        description: desc.isNotEmpty ? desc : null,
        price: price,
        stockQuantity: stock,
        imageUrl: imgUrl.isNotEmpty ? imgUrl : null,
        calendarType: _selectedCalendarType,
        status: _selectedStatus,
      );
    }

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditMode ? 'Cập nhật sản phẩm thành công!' : 'Thêm sản phẩm thành công!')),
      );
      context.pop(); // Quay lại trang trước
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryListProvider);
    final actionState = ref.watch(adminProductActionNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Cập nhật sản phẩm' : 'Thêm sản phẩm mới'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Tên sản phẩm
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Tên lịch / sản phẩm *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Vui lòng nhập tên sản phẩm';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Danh mục từ API
                  categoriesAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, __) => Text('Lỗi tải danh mục: $err', style: const TextStyle(color: Colors.red)),
                    data: (categories) {
                      final activeCategories = categories.where((c) => c.status == 'Active').toList();
                      // Đảm bảo id đã chọn tồn tại trong list, nếu không set null
                      if (_selectedCategoryId != null && !activeCategories.any((c) => c.categoryId == _selectedCategoryId)) {
                        _selectedCategoryId = null;
                      }

                      return DropdownButtonFormField<int>(
                        initialValue: _selectedCategoryId,
                        decoration: const InputDecoration(
                          labelText: 'Danh mục *',
                          border: OutlineInputBorder(),
                        ),
                        items: activeCategories.map((cat) {
                          return DropdownMenuItem(
                            value: cat.categoryId,
                            child: Text(cat.categoryName),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedCategoryId = val;
                          });
                        },
                        validator: (val) => val == null ? 'Vui lòng chọn danh mục' : null,
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // Loại lịch cố định
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCalendarType,
                    decoration: const InputDecoration(
                      labelText: 'Loại lịch *',
                      border: OutlineInputBorder(),
                    ),
                    items: _calendarTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedCalendarType = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  // Giá
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Giá bán (VND) *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Vui lòng nhập giá';
                      final price = double.tryParse(val);
                      if (price == null || price < 0) return 'Giá trị không hợp lệ (>= 0)';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Số lượng kho
                  TextFormField(
                    controller: _stockController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Số lượng trong kho *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Vui lòng nhập số lượng tồn kho';
                      final stock = int.tryParse(val);
                      if (stock == null || stock < 0) return 'Số lượng không hợp lệ (>= 0)';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Link ảnh
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Địa chỉ ảnh URL (ImageUrl)',
                      border: OutlineInputBorder(),
                      helperText: 'Để trống nếu muốn sử dụng ảnh mặc định.',
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Trạng thái (chỉ khả dụng trong chế độ Edit hoặc nếu tạo mới muốn thiết lập nháp)
                  DropdownButtonFormField<String>(
                    initialValue: _selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Trạng thái bán *',
                      border: OutlineInputBorder(),
                    ),
                    items: _statusOptions.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status == 'Active'
                            ? 'Đang bán (Active)'
                            : status == 'OutOfStock'
                                ? 'Hết hàng (OutOfStock)'
                                : 'Ẩn/Lưu nháp (Hidden)'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedStatus = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  // Nút Submit
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _isEditMode ? 'Cập nhật lịch' : 'Thêm lịch mới',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Nếu có lỗi API
                  if (actionState.error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        actionState.error!,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (actionState.isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
