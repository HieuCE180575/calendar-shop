import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_search_bar.dart';
import '../../../../core/widgets/category_tab_bar.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
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
    final cartState = ref.watch(cartProvider);
    final cartCount = cartState.value?.length ?? 0;
    final isAdmin = userState.user?.role == 'Admin';

    final categories = ['Tất cả'];
    categoriesAsync.whenData((cats) {
      for (var c in cats) {
        categories.add(c.categoryName);
      }
    });

    String selectedCatName = 'Tất cả';
    if (filterState.categoryId != null && categoriesAsync.value != null) {
      final found = categoriesAsync.value!.firstWhere(
        (c) => c.categoryId == filterState.categoryId,
        orElse: () => categoriesAsync.value!.first,
      );
      selectedCatName = found.categoryName;
    }

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          children: [
            // Search Input with Filter Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: AppSearchBar(
                controller: _searchController,
                hintText: 'Tìm kiếm sản phẩm...',
                onChanged: (value) {
                  ref.read(productFilterProvider.notifier).setSearch(value);
                },
                onFilterTap: () => _showFilterBottomSheet(context),
              ),
            ),

            // Horizontal Category Pill Scrollbar
            CategoryTabBar(
              categories: categories,
              selectedCategory: selectedCatName,
              onSelectCategory: (name) {
                if (name == 'Tất cả') {
                  ref.read(productFilterProvider.notifier).setCategory(null);
                } else if (categoriesAsync.value != null) {
                  final cat = categoriesAsync.value!.firstWhere((c) => c.categoryName == name);
                  ref.read(productFilterProvider.notifier).setCategory(cat.categoryId);
                }
              },
            ),

            const SizedBox(height: 12),

            // Main Product Grid (2 Columns)
            Expanded(
              child: productsAsync.when(
                data: (products) {
                  if (products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off, size: 64, color: AppColors.textMuted),
                          const SizedBox(height: 12),
                          const Text(
                            'Không tìm thấy sản phẩm nào',
                            style: TextStyle(fontSize: 15, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(160, 40),
                              backgroundColor: AppColors.primary,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              ref.read(productFilterProvider.notifier).reset();
                            },
                            icon: const Icon(Icons.refresh, size: 18),
                            label: const Text('Xóa bộ lọc'),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(productListProvider);
                    },
                    child: GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.68,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final p = products[index];
                        return ProductCard(
                          product: p,
                          onTap: () => context.push('/products/${p.productId}'),
                          onFavoriteTap: () {
                            context.push('/favorites');
                          },
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                error: (err, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.danger, size: 48),
                      const SizedBox(height: 12),
                      Text('Lỗi: $err', style: const TextStyle(color: AppColors.textSecondary)),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(productListProvider),
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
  String? _selectedSortBy;

  @override
  void initState() {
    super.initState();
    final filter = ref.read(productFilterProvider);
    if (filter.minPrice != null) _minPriceController.text = filter.minPrice.toString();
    if (filter.maxPrice != null) _maxPriceController.text = filter.maxPrice.toString();
    _selectedCalendarType = filter.calendarType;
    _selectedSortBy = filter.sort;
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
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Bộ lọc & Sắp xếp',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),

          // Sắp xếp
          const Text('Sắp xếp theo giá', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Mặc định'),
                selected: _selectedSortBy == 'newest',
                onSelected: (val) => setState(() => _selectedSortBy = 'newest'),
              ),
              ChoiceChip(
                label: const Text('Giá: Thấp -> Cao'),
                selected: _selectedSortBy == 'price_asc',
                onSelected: (val) => setState(() => _selectedSortBy = 'price_asc'),
              ),
              ChoiceChip(
                label: const Text('Giá: Cao -> Thấp'),
                selected: _selectedSortBy == 'price_desc',
                onSelected: (val) => setState(() => _selectedSortBy = 'price_desc'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Khoảng giá
          const Text('Khoảng giá (VNĐ)', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _minPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Tối thiểu'),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('-'),
              ),
              Expanded(
                child: TextField(
                  controller: _maxPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Tối đa'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Loại lịch
          const Text('Loại lịch', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['Tất cả', 'Lịch bloc', 'Lịch treo tường', 'Lịch để bàn', 'Lịch custom'].map((type) {
              final isSelected = (type == 'Tất cả' && _selectedCalendarType == null) || _selectedCalendarType == type;
              return ChoiceChip(
                label: Text(type),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedCalendarType = (type == 'Tất cả') ? null : type;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(productFilterProvider.notifier).reset();
                    Navigator.pop(context);
                  },
                  child: const Text('Thiết lập lại'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final minP = double.tryParse(_minPriceController.text);
                    final maxP = double.tryParse(_maxPriceController.text);
                    ref.read(productFilterProvider.notifier).setPrices(minP, maxP);
                    ref.read(productFilterProvider.notifier).setCalendarType(_selectedCalendarType);
                    if (_selectedSortBy != null) {
                      ref.read(productFilterProvider.notifier).setSort(_selectedSortBy!);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Áp dụng'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
