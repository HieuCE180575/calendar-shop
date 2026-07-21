import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _getStyle(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: config.borderColor, width: 1),
      ),
      child: Text(
        config.label,
        style: TextStyle(
          color: config.textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  _ChipConfig _getStyle(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'chờ xác nhận':
        return _ChipConfig(
          label: 'Chờ xác nhận',
          textColor: AppColors.warning,
          backgroundColor: const Color(0xFFFFF7ED),
          borderColor: const Color(0xFFFFEDD5),
        );
      case 'confirmed':
      case 'đã xác nhận':
        return _ChipConfig(
          label: 'Đã xác nhận',
          textColor: AppColors.primary,
          backgroundColor: AppColors.primaryLight,
          borderColor: const Color(0xFFBFDBFE),
        );
      case 'shipping':
      case 'đang giao':
        return _ChipConfig(
          label: 'Đang giao hàng',
          textColor: const Color(0xFF0284C7),
          backgroundColor: const Color(0xFFF0F9FF),
          borderColor: const Color(0xFFBAE6FD),
        );
      case 'delivered':
      case 'đã giao':
      case 'active':
      case 'hoạt động':
        return _ChipConfig(
          label: status.toLowerCase() == 'active' ? 'Hoạt động' : 'Đã giao hàng',
          textColor: AppColors.success,
          backgroundColor: const Color(0xFFECFDF5),
          borderColor: const Color(0xFFA7F3D0),
        );
      case 'cancelled':
      case 'đã hủy':
      case 'inactive':
      case 'tắt':
        return _ChipConfig(
          label: status.toLowerCase() == 'inactive' ? 'Đã ẩn' : 'Đã hủy',
          textColor: AppColors.danger,
          backgroundColor: const Color(0xFFFEF2F2),
          borderColor: const Color(0xFFFECACA),
        );
      default:
        return _ChipConfig(
          label: status,
          textColor: AppColors.textSecondary,
          backgroundColor: AppColors.background,
          borderColor: AppColors.border,
        );
    }
  }
}

class _ChipConfig {
  final String label;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;

  _ChipConfig({
    required this.label,
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
  });
}
