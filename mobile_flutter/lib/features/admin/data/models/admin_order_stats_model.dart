import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/admin_order_stats.dart';

part 'admin_order_stats_model.freezed.dart';
part 'admin_order_stats_model.g.dart';

@freezed
class AdminOrderStatsModel with _$AdminOrderStatsModel {
  const factory AdminOrderStatsModel({
    required int totalOrders,
    @Default(0.0) double totalOrdersGrowth,
    required int pendingOrders,
    required int deliveringOrders,
    required int completedOrders,
    @Default(0.0) double revenueGrowth,
    required int cancelledOrders,
    required List<OrderStatusDistributionModel> statusDistribution,
    required List<RevenueByDayModel> revenueByDay,
  }) = _AdminOrderStatsModel;

  factory AdminOrderStatsModel.fromJson(Map<String, dynamic> json) =>
      _$AdminOrderStatsModelFromJson(json);
}

@freezed
class OrderStatusDistributionModel with _$OrderStatusDistributionModel {
  const factory OrderStatusDistributionModel({
    required String status,
    required int total,
    required double percentage,
  }) = _OrderStatusDistributionModel;

  factory OrderStatusDistributionModel.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusDistributionModelFromJson(json);
}

@freezed
class RevenueByDayModel with _$RevenueByDayModel {
  const factory RevenueByDayModel({
    required DateTime date,
    required double revenue,
    required int orderCount,
  }) = _RevenueByDayModel;

  factory RevenueByDayModel.fromJson(Map<String, dynamic> json) =>
      _$RevenueByDayModelFromJson(json);
}

extension AdminOrderStatsModelMapper on AdminOrderStatsModel {
  AdminOrderStats toEntity() => AdminOrderStats(
        totalOrders: totalOrders,
        totalOrdersGrowth: totalOrdersGrowth,
        pendingOrders: pendingOrders,
        deliveringOrders: deliveringOrders,
        completedOrders: completedOrders,
        revenueGrowth: revenueGrowth,
        cancelledOrders: cancelledOrders,
        statusDistribution: statusDistribution.map((e) => e.toEntity()).toList(),
        revenueByDay: revenueByDay.map((e) => e.toEntity()).toList(),
      );
}

extension OrderStatusDistributionModelMapper on OrderStatusDistributionModel {
  OrderStatusDistribution toEntity() => OrderStatusDistribution(
        status: status,
        total: total,
        percentage: percentage,
      );
}

extension RevenueByDayModelMapper on RevenueByDayModel {
  RevenueByDay toEntity() => RevenueByDay(
        date: date,
        revenue: revenue,
        orderCount: orderCount,
      );
}
