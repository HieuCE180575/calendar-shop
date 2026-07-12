import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/admin_coupon.dart';
import '../providers/admin_coupon_provider.dart';

class AdminCouponListPage extends ConsumerWidget {
  const AdminCouponListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couponsAsync = ref.watch(adminCouponListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý mã giảm giá'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/admin/coupons/new'),
        icon: const Icon(Icons.add),
        label: const Text('Tạo mã'),
      ),
      body: couponsAsync.when(
        data: (coupons) {
          if (coupons.isEmpty) {
            return const Center(
              child: Text('Chưa có mã giảm giá nào.'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(adminCouponListProvider);
              await ref.read(adminCouponListProvider.future);
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: coupons.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final coupon = coupons[index];
                return _CouponCard(coupon: coupon);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Không tải được danh sách mã giảm giá.\n$error'),
          ),
        ),
      ),
    );
  }
}

class _CouponCard extends ConsumerWidget {
  final AdminCoupon coupon;

  const _CouponCard({required this.coupon});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final dateFormat = DateFormat('dd/MM/yyyy');
    final isActive = coupon.status == 'Active';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    coupon.code,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Switch(
                  value: isActive,
                  onChanged: (value) async {
                    final messenger = ScaffoldMessenger.of(context);
                    final success = await ref
                        .read(adminCouponActionNotifierProvider.notifier)
                        .updateStatus(
                          coupon.couponId,
                          value ? 'Active' : 'Inactive',
                        );
                    if (!context.mounted) return;
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? 'Đã cập nhật trạng thái mã giảm giá.'
                              : (ref.read(adminCouponActionNotifierProvider).error ??
                                  'Cập nhật trạng thái thất bại.'),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            if ((coupon.description ?? '').trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(coupon.description!),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoChip(
                  label: 'Loại',
                  value: coupon.discountType == 'Percent'
                      ? 'Phần trăm'
                      : 'Số tiền',
                ),
                _InfoChip(
                  label: 'Giảm',
                  value: coupon.discountType == 'Percent'
                      ? '${coupon.discountValue.toStringAsFixed(0)}%'
                      : currencyFormat.format(coupon.discountValue),
                ),
                _InfoChip(
                  label: 'Đơn tối thiểu',
                  value: currencyFormat.format(coupon.minOrderValue),
                ),
                _InfoChip(
                  label: 'Hiệu lực',
                  value:
                      '${dateFormat.format(coupon.startDate.toLocal())} - ${dateFormat.format(coupon.endDate.toLocal())}',
                ),
                _InfoChip(
                  label: 'Đã dùng',
                  value: coupon.usageLimit == null
                      ? '${coupon.usedCount} / Không giới hạn'
                      : '${coupon.usedCount} / ${coupon.usageLimit}',
                ),
                _InfoChip(label: 'Trạng thái', value: coupon.status),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: () => context.push('/admin/coupons/edit', extra: coupon),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Chỉnh sửa'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;

  const _InfoChip({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
