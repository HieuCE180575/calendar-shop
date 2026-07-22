import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/admin_dashboard_stats.dart';
import 'admin_dashboard_formatters.dart';
import 'dashboard_section_card.dart';

class DailyRevenueChartCard extends StatelessWidget {
  final List<RevenueByDay> data;

  const DailyRevenueChartCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const _EmptyChartCard(
        title: 'Doanh thu theo ngày',
        message: 'Chưa có dữ liệu doanh thu theo ngày',
      );
    }

    final maxVal = data.map((e) => e.revenue).reduce((a, b) => a > b ? a : b);
    final maxScale = maxVal > 0 ? maxVal : 1.0;

    return DashboardSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Doanh thu theo ngày (Gần đây nhất)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                final barHeight = (item.revenue / maxScale) * 120;
                final dateStr = DateFormat('dd/MM').format(item.date);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        AdminDashboardFormatters.compactRevenue(item.revenue),
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 28,
                        height: barHeight > 5 ? barHeight : 5,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dateStr,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MonthlyRevenueChartCard extends StatefulWidget {
  final List<RevenueByMonth> data;

  const MonthlyRevenueChartCard({super.key, required this.data});

  @override
  State<MonthlyRevenueChartCard> createState() => _MonthlyRevenueChartCardState();
}

class _MonthlyRevenueChartCardState extends State<MonthlyRevenueChartCard> {
  int _monthsFilter = 6;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    if (data.isEmpty) {
      return const _EmptyChartCard(
        title: 'Doanh thu theo tháng',
        message: 'Chưa có dữ liệu doanh thu theo tháng',
      );
    }

    final maxVal = data.map((e) => e.revenue).reduce((a, b) => a > b ? a : b);
    final maxScale = maxVal > 0 ? maxVal * 1.2 : 1.0; // Thêm 20% đệm ở trên cùng

    // Chỉ lấy số tháng gần nhất theo filter
    final displayData = data.length > _monthsFilter ? data.sublist(data.length - _monthsFilter) : data;

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
                'Doanh thu theo tháng',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _monthsFilter,
                    icon: const Icon(Icons.keyboard_arrow_down, size: 14, color: AppColors.textSecondary),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _monthsFilter = newValue;
                        });
                      }
                    },
                    items: const [
                      DropdownMenuItem(value: 3, child: Text('3 tháng qua')),
                      DropdownMenuItem(value: 6, child: Text('6 tháng qua')),
                      DropdownMenuItem(value: 12, child: Text('12 tháng qua')),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Icon(Icons.circle, size: 8, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                'Doanh thu (đ)',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            width: double.infinity,
            child: Row(
              children: [
                // Y-axis labels
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(5, (index) {
                    final value = maxScale - (maxScale * index / 4);
                    String label = value == 0 ? '0' : '${(value / 1000000).toStringAsFixed(0)}tr đ';
                    return Text(
                      label,
                      style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                    );
                  }),
                ),
                const SizedBox(width: 8),
                // Chart area
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: CustomPaint(
                          size: Size.infinite,
                          painter: _LineChartPainter(
                            data: displayData.map((e) => e.revenue).toList(),
                            maxVal: maxScale,
                            lineColor: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // X-axis labels
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: displayData.map((item) {
                          return Text(
                            '${item.month.toString().padLeft(2, '0')}/${item.year}',
                            style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final double maxVal;
  final Color lineColor;

  _LineChartPainter({
    required this.data,
    required this.maxVal,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paintLine = Paint()
      ..color = lineColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final paintFill = Paint()
      ..color = lineColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final paintDot = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
      
    final paintDotBorder = Paint()
      ..color = lineColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final paintGrid = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw horizontal grid lines (4 intervals)
    for (int i = 0; i <= 4; i++) {
      final y = size.height - (size.height * i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paintGrid);
    }

    if (data.length == 1) {
      final y = size.height - (data[0] / maxVal) * size.height;
      canvas.drawCircle(Offset(size.width / 2, y), 4, paintDot);
      canvas.drawCircle(Offset(size.width / 2, y), 4, paintDotBorder);
      return;
    }

    final stepX = size.width / (data.length - 1);
    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height - (data[i] / maxVal) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, paintFill);
    canvas.drawPath(path, paintLine);

    // Draw dots at nodes
    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height - (data[i] / maxVal) * size.height;
      canvas.drawCircle(Offset(x, y), 4, paintDot);
      canvas.drawCircle(Offset(x, y), 4, paintDotBorder);
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.maxVal != maxVal;
  }
}

class _EmptyChartCard extends StatelessWidget {
  final String title;
  final String message;

  const _EmptyChartCard({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return DashboardSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
