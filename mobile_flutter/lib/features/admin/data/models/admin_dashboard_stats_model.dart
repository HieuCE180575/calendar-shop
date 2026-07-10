import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/admin_dashboard_stats.dart';

part 'admin_dashboard_stats_model.freezed.dart';
part 'admin_dashboard_stats_model.g.dart';

@freezed
class AdminDashboardStatsModel with _$AdminDashboardStatsModel {
  const factory AdminDashboardStatsModel({
    required double totalRevenue,
    required int totalOrders,
    required int totalProductsSold,
    required List<StatusCountModel> ordersByStatus,
    required List<BestSellingProductModel> bestSelling,
    required List<RevenueByDayModel> revenueByDay,
    required List<RevenueByMonthModel> revenueByMonth,
  }) = _AdminDashboardStatsModel;

  factory AdminDashboardStatsModel.fromJson(Map<String, dynamic> json) =>
      _$AdminDashboardStatsModelFromJson(json);
}

@freezed
class StatusCountModel with _$StatusCountModel {
  const factory StatusCountModel({
    required String status,
    required int total,
  }) = _StatusCountModel;

  factory StatusCountModel.fromJson(Map<String, dynamic> json) =>
      _$StatusCountModelFromJson(json);
}

@freezed
class BestSellingProductModel with _$BestSellingProductModel {
  const factory BestSellingProductModel({
    required int productId,
    required String productName,
    required int totalSold,
  }) = _BestSellingProductModel;

  factory BestSellingProductModel.fromJson(Map<String, dynamic> json) =>
      _$BestSellingProductModelFromJson(json);
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

@freezed
class RevenueByMonthModel with _$RevenueByMonthModel {
  const factory RevenueByMonthModel({
    required int year,
    required int month,
    required double revenue,
    required int orderCount,
  }) = _RevenueByMonthModel;

  factory RevenueByMonthModel.fromJson(Map<String, dynamic> json) =>
      _$RevenueByMonthModelFromJson(json);
}

extension AdminDashboardStatsModelMapper on AdminDashboardStatsModel {
  AdminDashboardStats toEntity() => AdminDashboardStats(
        totalRevenue: totalRevenue,
        totalOrders: totalOrders,
        totalProductsSold: totalProductsSold,
        ordersByStatus: ordersByStatus.map((e) => e.toEntity()).toList(),
        bestSelling: bestSelling.map((e) => e.toEntity()).toList(),
        revenueByDay: revenueByDay.map((e) => e.toEntity()).toList(),
        revenueByMonth: revenueByMonth.map((e) => e.toEntity()).toList(),
      );
}

extension StatusCountModelMapper on StatusCountModel {
  StatusCount toEntity() => StatusCount(
        status: status,
        total: total,
      );
}

extension BestSellingProductModelMapper on BestSellingProductModel {
  BestSellingProduct toEntity() => BestSellingProduct(
        productId: productId,
        productName: productName,
        totalSold: totalSold,
      );
}

extension RevenueByDayModelMapper on RevenueByDayModel {
  RevenueByDay toEntity() => RevenueByDay(
        date: date,
        revenue: revenue,
        orderCount: orderCount,
      );
}

extension RevenueByMonthModelMapper on RevenueByMonthModel {
  RevenueByMonth toEntity() => RevenueByMonth(
        year: year,
        month: month,
        revenue: revenue,
        orderCount: orderCount,
      );
}
