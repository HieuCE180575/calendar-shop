import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../providers/admin_discount_provider.dart';
import '../providers/admin_stats_provider.dart';
import '../widgets/admin_page_layout.dart';
import '../widgets/admin_discount_stats_section.dart';

class AdminDiscountListPage extends ConsumerStatefulWidget {
  const AdminDiscountListPage({super.key});

  @override
  ConsumerState<AdminDiscountListPage> createState() => _AdminDiscountListPageState();
}

class _AdminDiscountListPageState extends ConsumerState<AdminDiscountListPage> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _showFilterAndSortDialog() {
    final filter = ref.read(adminDiscountFilterProvider);
    String? statusFilter = filter.filterStatus;
    DateTime? startDateFilter = filter.filterStartDate;
    DateTime? endDateFilter = filter.filterEndDate;
    String? discountValueSort = filter.sortByDiscountValue;
    
    final dateFormat = DateFormat('dd/MM/yyyy');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                left: 16, 
                right: 16, 
                top: 16, 
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Bộ lọc', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String?>(
                      decoration: const InputDecoration(labelText: 'Trạng thái'),
                      initialValue: statusFilter,
                      items: const [
                        DropdownMenuItem(value: null, child: Text('Tất cả')),
                        DropdownMenuItem(value: 'Active', child: Text('Đang hoạt động (Active)')),
                        DropdownMenuItem(value: 'Inactive', child: Text('Đã ẩn (Inactive)')),
                      ],
                      onChanged: (val) => setState(() => statusFilter = val),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: startDateFilter ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );
                              if (pickedDate != null) {
                                setState(() => startDateFilter = pickedDate);
                              }
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(labelText: 'Từ ngày (Bắt đầu)'),
                              child: Text(startDateFilter != null ? dateFormat.format(startDateFilter!) : 'Chưa chọn'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: endDateFilter ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  // Đặt giờ là 23:59:59 cho end date
                                  endDateFilter = DateTime(
                                    pickedDate.year,
                                    pickedDate.month,
                                    pickedDate.day,
                                    23, 59, 59,
                                  );
                                });
                              }
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(labelText: 'Đến ngày (Kết thúc)'),
                              child: Text(endDateFilter != null ? dateFormat.format(endDateFilter!) : 'Chưa chọn'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text('Sắp xếp', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String?>(
                      decoration: const InputDecoration(labelText: 'Mức giảm'),
                      initialValue: discountValueSort,
                      items: const [
                        DropdownMenuItem(value: null, child: Text('Không sắp xếp')),
                        DropdownMenuItem(value: 'asc', child: Text('Tăng dần')),
                        DropdownMenuItem(value: 'desc', child: Text('Giảm dần')),
                      ],
                      onChanged: (val) => setState(() => discountValueSort = val),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            ref.read(adminDiscountFilterProvider.notifier).resetFilter();
                            _searchController.clear();
                            Navigator.pop(context);
                          },
                          child: const Text('Xóa bộ lọc'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(minimumSize: const Size(120, 48)),
                          onPressed: () {
                            ref.read(adminDiscountFilterProvider.notifier).updateFilterAndSort(
                                  filterStatus: statusFilter,
                                  filterStartDate: startDateFilter,
                                  filterEndDate: endDateFilter,
                                  sortByDiscountValue: discountValueSort,
                                );
                            Navigator.pop(context);
                          },
                          child: const Text('Áp dụng'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(adminDiscountFilterProvider);
    final discountsAsync = ref.watch(adminDiscountListProvider);
    final actionState = ref.watch(adminDiscountActionNotifierProvider);

    return AdminPageLayout(
      title: 'Quản lý Giảm giá',
      currentRoute: '/admin/discounts',
      actions: [
        IconButton(
          icon: const Icon(Icons.sort),
          onPressed: _showFilterAndSortDialog,
        ),
        IconButton(
          icon: const Icon(Icons.add_box_outlined, size: 28, color: Colors.blue),
          onPressed: () => context.push('/admin/discounts/add'),
          tooltip: 'Thêm khuyến mãi mới',
        ),
      ],
      child: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(adminDiscountStatsProvider);
              ref.invalidate(adminDiscountListProvider);
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AdminDiscountStatsSection(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm giảm giá...',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        prefixIcon: Icon(Icons.search, color: Colors.blue.shade700),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: filter.searchQuery?.isNotEmpty == true
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  ref.read(adminDiscountFilterProvider.notifier).updateSearchQuery(null);
                                },
                              )
                            : null,
                      ),
                      onChanged: (val) {
                        if (_debounce?.isActive ?? false) _debounce?.cancel();
                        _debounce = Timer(const Duration(milliseconds: 500), () {
                          ref.read(adminDiscountFilterProvider.notifier).updateSearchQuery(val.trim());
                        });
                      },
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
                discountsAsync.when(
                  loading: () => const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, __) => SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Lỗi: $err', style: const TextStyle(color: Colors.red)),
                          ElevatedButton(
                            onPressed: () => ref.invalidate(adminDiscountListProvider),
                            child: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  data: (data) {
                    final discounts = data.items;
                    final totalCount = data.totalCount;
                    final totalPages = (totalCount / filter.pageSize).ceil();

                    if (discounts.isEmpty) {
                      return const SliverFillRemaining(
                        child: Center(child: Text('Chưa có chương trình giảm giá nào.', style: TextStyle(color: Colors.grey))),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index == discounts.length) {
                                // Pagination
                                if (totalPages > 1) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    color: Colors.transparent,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.chevron_left),
                                          onPressed: filter.page > 1
                                              ? () => ref.read(adminDiscountFilterProvider.notifier).updatePage(filter.page - 1)
                                              : null,
                                        ),
                                        Text('Trang ${filter.page} / $totalPages'),
                                        IconButton(
                                          icon: const Icon(Icons.chevron_right),
                                          onPressed: filter.page < totalPages
                                              ? () => ref.read(adminDiscountFilterProvider.notifier).updatePage(filter.page + 1)
                                              : null,
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                            }
                            
                            final discount = discounts[index];
                            final isPercent = discount.discountType == 'Percent';
                            
                            Color statusColor = discount.status == 'Active' ? Colors.green : Colors.grey;

                            return Card(
                              color: Colors.white,
                              elevation: 1,
                              shadowColor: Colors.black.withValues(alpha: 0.05),
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  context.push('/admin/discounts/detail', extra: discount);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              discount.name,
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              isPercent
                                                  ? 'Giảm: ${discount.discountValue}%'
                                                  : 'Giảm: ${CurrencyFormatter.vnd(discount.discountValue)}',
                                              style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold, fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.category_outlined, size: 16, color: Colors.grey.shade600),
                                                const SizedBox(width: 4),
                                                Expanded(child: Text(discount.productIds.isNotEmpty ? 'Phạm vi: ${discount.productIds.length} Sản phẩm' : 'Phạm vi: ${discount.categoryIds.length} Danh mục', style: TextStyle(color: Colors.grey.shade800, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey.shade600),
                                                const SizedBox(width: 4),
                                                Expanded(child: Text('${DateFormat('dd/MM').format(discount.startDate.toLocal())} - ${DateFormat('dd/MM/yyyy').format(discount.endDate.toLocal())}', style: TextStyle(color: Colors.grey.shade800, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: statusColor.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              discount.status,
                                              style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit, color: Colors.blue.shade700),
                                            onPressed: () => context.push('/admin/discounts/edit', extra: discount),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title: const Text('Xác nhận xóa'),
                                                  content: const Text('Bạn có chắc chắn muốn xóa giảm giá này?'),
                                                  actions: [
                                                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.red,
                                                        minimumSize: const Size(80, 48),
                                                      ),
                                                      onPressed: () async {
                                                        Navigator.pop(ctx);
                                                        final success = await ref
                                                            .read(adminDiscountActionNotifierProvider.notifier)
                                                            .deleteDiscount(discount.discountId);
                                                        if (success && context.mounted) {
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                              const SnackBar(content: Text('Đã xóa discount')));
                                                        }
                                                      },
                                                      child: const Text('Xóa'),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: discounts.length + 1, // +1 for pagination
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          if (actionState)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
