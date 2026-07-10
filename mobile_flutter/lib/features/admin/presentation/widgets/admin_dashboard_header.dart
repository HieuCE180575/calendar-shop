import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dashboard_section_card.dart';

class AdminDashboardHeader extends StatelessWidget {
  const AdminDashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardSectionCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.1),
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
        ],
      ),
    );
  }
}
