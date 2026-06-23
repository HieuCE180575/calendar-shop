import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../category/presentation/providers/category_provider.dart';
import '../providers/product_provider.dart';

class ProductListPage extends ConsumerStatefulWidget {
  const ProductListPage({super.key});

  @override
  ConsumerState<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends ConsumerState<ProductListPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Đồng bộ searchController với state hiện tại
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentSearch = ref.read(productFilterProvider).search;
      if (currentSearch != null) {
        _searchController.text = currentSearch;
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productListProvider);
    final filterState = ref.watch(productFilterProvider);
    final categoriesAsync = ref.watch(categoryListProvider);
    final userState = ref.watch(authNotifierProvider);

    final isAdmin = userState.user?.role == 'Admin';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calendar Shop',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        actions: [
          if (isAdmin)
            IconButton(
              onPressed: () => context.go('/admin'),
              icon: const Icon(Icons.admin_panel_settings, color: Colors.blueAccent),
              tooltip: 'Trang quản trị',
            ),
          IconButton(
            onPressed: () => context.push('/cart'),
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
          IconButton(
            onPressed: () => context.push('/orders'),
            icon: const Icon(Icons.receipt_long_outlined),
          ),
          IconButton(
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
          ),
        ],
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm và nút Bộ lọc
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Tìm lịch theo tên...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                ref.read(productFilterProvider.notifier).setSearch(null);
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                    onChanged: (val) {
                      setState(() {}); // Để cập nhật nút clear
                      ref.read(productFilterProvider.notifier).setSearch(val.trim());
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  onPressed: () => _showFilterBottomSheet(context),
                  icon: const Icon(Icons.filter_list),
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lọc danh mục dạng Tabs hàng ngang
          categoriesAsync.when(
            data: (categories) {
              final activeCategories = categories.where((c) => c.status == 'Active').toList();
              return SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: activeCategories.length + 1,
                  itemBuilder: (context, index) {
                    final isAll = index == 0;
                    final cat = isAll ? null : activeCategories[index - 1];
                    final isSelected = isAll
                        ? filterState.categoryId == null
                        : filterState.categoryId == cat?.categoryId;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(isAll ? 'Tất cả' : cat!.categoryName),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            ref
                                .read(productFilterProvider.notifier)
                                .setCategory(cat?.categoryId);
                          }
                        },
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => const SizedBox(height: 48, child: Center(child: LinearProgressIndicator())),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Hiển thị trạng thái lọc hiện tại nếu có
          if (filterState.calendarType != null ||
              filterState.minPrice != null ||
              filterState.maxPrice != null ||
              filterState.sort != 'newest')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Text('Bộ lọc active: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    if (filterState.calendarType != null)
                      _buildFilterChip(
                        filterState.calendarType!,
                        () => ref.read(productFilterProvider.notifier).setCalendarType(null),
                      ),
                    if (filterState.minPrice != null || filterState.maxPrice != null)
                      _buildFilterChip(
                        'Giá: ${_formatPriceRange(filterState.minPrice, filterState.maxPrice)}',
                        () => ref.read(productFilterProvider.notifier).setPrices(null, null),
                      ),
                    if (filterState.sort != 'newest')
                      _buildFilterChip(
                        filterState.sort == 'price_asc' ? 'Giá tăng dần' : 'Giá giảm dần',
                        () => ref.read(productFilterProvider.notifier).setSort('newest'),
                      ),
                    TextButton(
                      onPressed: () {
                        _searchController.clear();
                        ref.read(productFilterProvider.notifier).reset();
                      },
                      child: const Text('Xóa tất cả', style: TextStyle(fontSize: 12, color: Colors.red)),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 8),

          // Grid hiển thị sản phẩm
          Expanded(
            child: productsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, __) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Lỗi: $err', style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(productListProvider),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
              data: (products) {
                if (products.isEmpty) {
                  return const Center(child: Text('Không tìm thấy lịch phù hợp.'));
                }
                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(productListProvider),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () => context.push('/products/${product.productId}'),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Hình ảnh sản phẩm
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.blue.shade100, Colors.blue.shade50],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                                      ? Image.network(
                                          product.imageUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => const Icon(
                                            Icons.calendar_month,
                                            size: 50,
                                            color: Colors.blueAccent,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.calendar_today,
                                          size: 50,
                                          color: Colors.blueAccent,
                                        ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Loại lịch nhỏ
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        product.calendarType,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.blue.shade800,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // Tên sản phẩm
                                    Text(
                                      product.productName,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    // Giá và tồn kho
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          CurrencyFormatter.vnd(product.price),
                                          style: const TextStyle(
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text(
                                          'Tồn: ${product.stockQuantity}',
                                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          // Thanh điều khiển phân trang OData
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: filterState.page > 1
                      ? () => ref.read(productFilterProvider.notifier).prevPage()
                      : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Trang trước'),
                ),
                Text(
                  'Trang ${filterState.page}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                OutlinedButton.icon(
                  onPressed: productsAsync.maybeWhen(
                    data: (products) => products.length == filterState.pageSize,
                    orElse: () => false,
                  )
                      ? () => ref.read(productFilterProvider.notifier).nextPage()
                      : null,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Trang sau'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onDeleted) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Chip(
        label: Text(label, style: const TextStyle(fontSize: 11)),
        deleteIcon: const Icon(Icons.close, size: 14),
        onDeleted: onDeleted,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.all(4),
      ),
    );
  }

  String _formatPriceRange(double? min, double? max) {
    if (min != null && max != null) return '${min.toInt()}k - ${max.toInt()}k';
    if (min != null) return '>= ${min.toInt()}k';
    if (max != null) return '<= ${max.toInt()}k';
    return '';
  }
}

class _FilterBottomSheet extends ConsumerStatefulWidget {
  const _FilterBottomSheet();

  @override
  ConsumerState<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<_FilterBottomSheet> {
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();
  String? _selectedCalendarType;
  String _selectedSort = 'newest';

  final List<String> _calendarTypes = [
    'Wall Calendar',
    'Desk Calendar',
    'Bloc Calendar',
    'Planner',
    'Custom Calendar'
  ];

  @override
  void initState() {
    super.initState();
    final filter = ref.read(productFilterProvider);
    if (filter.minPrice != null) _minPriceController.text = filter.minPrice!.toInt().toString();
    if (filter.maxPrice != null) _maxPriceController.text = filter.maxPrice!.toInt().toString();
    _selectedCalendarType = filter.calendarType;
    _selectedSort = filter.sort;
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bộ lọc nâng cao',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
            const Divider(),

            // 1. Sắp xếp
            const Text('Sắp xếp theo', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedSort,
              items: const [
                DropdownMenuItem(value: 'newest', child: Text('Mới nhất')),
                DropdownMenuItem(value: 'price_asc', child: Text('Giá: Thấp đến Cao')),
                DropdownMenuItem(value: 'price_desc', child: Text('Giá: Cao đến Thấp')),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedSort = val;
                  });
                }
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            const SizedBox(height: 16),

            // 2. Loại lịch
            const Text('Loại lịch', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _calendarTypes.map((type) {
                final isSelected = _selectedCalendarType == type;
                return ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCalendarType = selected ? type : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // 3. Khoảng giá
            const Text('Khoảng giá (VND)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Giá tối thiểu',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('đến'),
                ),
                Expanded(
                  child: TextField(
                    controller: _maxPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Giá tối đa',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 4. Các nút áp dụng
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(productFilterProvider.notifier).reset();
                      Navigator.pop(context);
                    },
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final min = double.tryParse(_minPriceController.text);
                      final max = double.tryParse(_maxPriceController.text);

                      ref.read(productFilterProvider.notifier).setSort(_selectedSort);
                      ref.read(productFilterProvider.notifier).setCalendarType(_selectedCalendarType);
                      ref.read(productFilterProvider.notifier).setPrices(min, max);

                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Áp dụng'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
