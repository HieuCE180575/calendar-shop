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
    return DashboardSectionCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.analytics_rounded,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thống kê tổng quan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Dữ liệu thực tế cập nhật lúc ${DateFormat('HH:mm dd/MM/yyyy').format(DateTime.now().toLocal())}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: _isExporting ? null : _exportRevenue,
            icon: _isExporting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.download),
            label: const Text('Export Doanh Thu'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size(0, 48), 
            ),
          ),
        ],
      ),
    );
  }
}
