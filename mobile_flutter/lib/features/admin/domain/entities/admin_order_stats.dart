import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_order_stats.freezed.dart';

@freezed
class AdminOrderStats with _$AdminOrderStats {
  const factory AdminOrderStats({
    @Default(0) int totalOrders,
    @Default(0.0) double totalOrdersGrowth,
    @Default(0) int pendingOrders,
    @Default(0) int deliveringOrders,
    @Default(0) int completedOrders,
    @Default(0.0) double revenueGrowth,
    @Default(0) int cancelledOrders,
    @Default([]) List<OrderStatusDistribution> statusDistribution,
    @Default([]) List<RevenueByDay> revenueByDay,
  }) = _AdminOrderStats;
}

@freezed
class OrderStatusDistribution with _$OrderStatusDistribution {
  const factory OrderStatusDistribution({
    @Default('') String status,
    @Default(0) int total,
    @Default(0.0) double percentage,
  }) = _OrderStatusDistribution;
}

@freezed
class RevenueByDay with _$RevenueByDay {
  const factory RevenueByDay({
    required DateTime date,
    @Default(0.0) double revenue,
    @Default(0) int orderCount,
  }) = _RevenueByDay;
}
