import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/admin_dashboard_provider.dart';
import 'dashboard_section_card.dart';

class AdminDashboardHeader extends ConsumerStatefulWidget {
  const AdminDashboardHeader({super.key});

  @override
  ConsumerState<AdminDashboardHeader> createState() => _AdminDashboardHeaderState();
}

class _AdminDashboardHeaderState extends ConsumerState<AdminDashboardHeader> {
  bool _isExporting = false;

  Future<void> _exportRevenue() async {
    setState(() => _isExporting = true);
    try {
      final bytes = await ref.read(exportRevenueExcelUseCaseProvider)();
      final userProfile = Platform.environment['USERPROFILE'];
      final downloadsDir = userProfile != null ? '$userProfile\\Downloads' : '.';
      final fileName = 'Revenue_${DateTime.now().millisecondsSinceEpoch}.xlsx';

      final file = File('$downloadsDir\\$fileName');
      await file.writeAsBytes(bytes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Xuất file thành công tại: Downloads\\$fileName'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi xuất file: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bảng điều khiển',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Chào mừng bạn trở lại! Hôm nay là một ngày tuyệt vời để quản lý cửa hàng.',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: ref.watch(dashboardDaysFilterProvider),
                icon: const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textSecondary),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    ref.read(dashboardDaysFilterProvider.notifier).setDays(newValue);
                  }
                },
                items: const [
                  DropdownMenuItem(value: 1, child: Text('1 ngày qua')),
                  DropdownMenuItem(value: 3, child: Text('3 ngày qua')),
                  DropdownMenuItem(value: 7, child: Text('7 ngày qua')),
                  DropdownMenuItem(value: 30, child: Text('30 ngày qua')),
                  DropdownMenuItem(value: 90, child: Text('90 ngày qua')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
