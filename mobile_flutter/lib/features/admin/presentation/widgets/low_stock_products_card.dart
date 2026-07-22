import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/admin_dashboard_stats.dart';

class LowStockProductsCard extends StatelessWidget {
  final AdminDashboardStats stats;

  const LowStockProductsCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    // Phân tích dữ liệu kho
    final int hetHang = stats.totalOutOfStock;
    final int sapHetHang = stats.totalLowStock;
    
    // Sử dụng tổng sản phẩm thực tế từ API
    final int conHang = (stats.totalProducts - hetHang - sapHetHang) > 0 ? (stats.totalProducts - hetHang - sapHetHang) : 0;
    final int total = stats.totalProducts > 0 ? stats.totalProducts : 1; // Tránh chia cho 0

    final int pctConHang = total > 0 ? ((conHang / total) * 100).round() : 0;
    final int pctSapHetHang = total > 0 ? ((sapHetHang / total) * 100).round() : 0;
    final int pctHetHang = total > 0 ? ((hetHang / total) * 100).round() : 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tình trạng tồn kho',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Xem tất cả',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildInventoryRow(
            color: AppColors.success,
            label: 'Còn hàng',
            count: conHang,
            pct: pctConHang,
          ),
          const SizedBox(height: 16),
          _buildInventoryRow(
            color: AppColors.warning,
            label: 'Sắp hết hàng (≤ 10)',
            count: sapHetHang,
            pct: pctSapHetHang,
          ),
          const SizedBox(height: 16),
          _buildInventoryRow(
            color: AppColors.danger,
            label: 'Hết hàng',
            count: hetHang,
            pct: pctHetHang,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInventoryRow({
    required Color color,
    required String label,
    required int count,
    required int pct,
  }) {
    return Row(
      children: [
        Icon(Icons.circle, color: color, size: 8),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '$count sản phẩm',
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 40,
          child: Text(
            '$pct%',
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
