import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/admin_discount.dart';
import '../../../../../core/utils/currency_formatter.dart';

import '../../../product/presentation/providers/product_provider.dart';
import '../../../category/presentation/providers/category_provider.dart';

class AdminDiscountDetailPage extends ConsumerWidget {
  final AdminDiscount discount;

  const AdminDiscountDetailPage({super.key, required this.discount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPercent = discount.discountType == 'Percent';
    final statusColor = discount.status == 'Active' ? Colors.green : Colors.grey;

    final categoriesAsync = ref.watch(categoryListProvider);
    final productsAsync = ref.watch(adminProductListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chi tiết Giảm giá'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue.shade700),
            onPressed: () => context.push('/admin/discounts/edit', extra: discount),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(
              title: 'Thông tin chung',
              icon: Icons.info_outline,
              children: [
                _buildInfoRow('Tên chương trình', discount.name),
                _buildInfoRow('ID', '#${discount.discountId}'),
                _buildInfoRow(
                  'Trạng thái',
                  discount.status,
                  valueColor: statusColor,
                ),
                _buildInfoRow(
                  'Giá trị giảm',
                  isPercent
                      ? '${discount.discountValue}%'
                      : CurrencyFormatter.vnd(discount.discountValue),
                  valueColor: Colors.blue.shade700,
                  isBold: true,
                ),
                _buildInfoRow(
                  'Ngày bắt đầu',
                  DateFormat('dd/MM/yyyy HH:mm').format(discount.startDate.toLocal()),
                ),
                _buildInfoRow(
                  'Ngày kết thúc',
                  DateFormat('dd/MM/yyyy HH:mm').format(discount.endDate.toLocal()),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              title: 'Phạm vi áp dụng',
              icon: Icons.list_alt,
              children: [
                if (discount.categoryIds.isNotEmpty) ...[
                  const Text('Danh mục áp dụng:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 8),
                  categoriesAsync.when(
                    data: (categories) => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: discount.categoryIds.map((id) {
                        final cat = categories.where((c) => c.categoryId == id).firstOrNull;
                        return Chip(
                          label: Text(cat?.categoryName ?? 'Danh mục #$id'),
                          backgroundColor: Colors.blue.shade50,
                          labelStyle: TextStyle(color: Colors.blue.shade700),
                        );
                      }).toList(),
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (e, _) => const Text('Lỗi tải danh mục'),
                  ),
                  const SizedBox(height: 16),
                ],
                if (discount.productIds.isNotEmpty) ...[
                  const Text('Sản phẩm áp dụng:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 8),
                  productsAsync.when(
                    data: (products) => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: discount.productIds.map((id) {
                        final prod = products.where((p) => p.productId == id).firstOrNull;
                        return Chip(
                          label: Text(prod?.productName ?? 'Sản phẩm #$id'),
                          backgroundColor: Colors.orange.shade50,
                          labelStyle: TextStyle(color: Colors.orange.shade700),
                        );
                      }).toList(),
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (e, _) => const Text('Lỗi tải sản phẩm'),
                  ),
                ],
                if (discount.categoryIds.isEmpty && discount.productIds.isEmpty)
                  const Text('Chưa áp dụng cho danh mục hay sản phẩm nào.', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? Colors.black87,
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
