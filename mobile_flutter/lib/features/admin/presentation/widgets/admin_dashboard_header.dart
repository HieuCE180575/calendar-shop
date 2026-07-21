import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi xuất file: $e'),
            backgroundColor: Colors.red,
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
            decoration: BoxDecoration(
              color: Colors.indigo.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.analytics_rounded,
              color: Colors.indigo.shade800,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Statistics Dashboard',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Du lieu thuc te cap nhat luc ${DateFormat('HH:mm dd/MM/yyyy').format(DateTime.now().toLocal())}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
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
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
