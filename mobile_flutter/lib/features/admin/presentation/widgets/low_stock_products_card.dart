import 'package:flutter/material.dart';

import '../../domain/entities/admin_dashboard_stats.dart';

class LowStockProductsCard extends StatelessWidget {
  final List<LowStockProduct> products;

  const LowStockProductsCard({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
                const SizedBox(width: 8),
                const Text(
                  'CANH BAO HET HANG',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final product = products[index];
                final isCritical = product.stockQuantity == 0;
                
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: isCritical ? Colors.red.shade100 : Colors.orange.shade100,
                    child: Icon(
                      Icons.inventory_2_outlined,
                      color: isCritical ? Colors.red.shade700 : Colors.orange.shade700,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    product.productName,
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isCritical ? Colors.red.shade50 : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isCritical ? Colors.red.shade200 : Colors.orange.shade200,
                      ),
                    ),
                    child: Text(
                      'Ton: ${product.stockQuantity}',
                      style: TextStyle(
                        color: isCritical ? Colors.red.shade700 : Colors.orange.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
