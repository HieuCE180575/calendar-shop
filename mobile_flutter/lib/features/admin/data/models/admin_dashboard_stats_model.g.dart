// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdminDashboardStatsModelImpl _$$AdminDashboardStatsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AdminDashboardStatsModelImpl(
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      totalOrders: (json['totalOrders'] as num).toInt(),
      totalProductsSold: (json['totalProductsSold'] as num).toInt(),
      ordersByStatus: (json['ordersByStatus'] as List<dynamic>)
          .map((e) => StatusCountModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      bestSelling: (json['bestSelling'] as List<dynamic>)
          .map((e) =>
              BestSellingProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      revenueByDay: (json['revenueByDay'] as List<dynamic>)
          .map((e) => RevenueByDayModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      revenueByMonth: (json['revenueByMonth'] as List<dynamic>)
          .map((e) => RevenueByMonthModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AdminDashboardStatsModelImplToJson(
        _$AdminDashboardStatsModelImpl instance) =>
    <String, dynamic>{
      'totalRevenue': instance.totalRevenue,
      'totalOrders': instance.totalOrders,
      'totalProductsSold': instance.totalProductsSold,
      'ordersByStatus': instance.ordersByStatus,
      'bestSelling': instance.bestSelling,
      'revenueByDay': instance.revenueByDay,
      'revenueByMonth': instance.revenueByMonth,
    };

_$StatusCountModelImpl _$$StatusCountModelImplFromJson(
        Map<String, dynamic> json) =>
    _$StatusCountModelImpl(
      status: json['status'] as String,
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$$StatusCountModelImplToJson(
        _$StatusCountModelImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'total': instance.total,
    };

_$BestSellingProductModelImpl _$$BestSellingProductModelImplFromJson(
        Map<String, dynamic> json) =>
    _$BestSellingProductModelImpl(
      productId: (json['productId'] as num).toInt(),
      productName: json['productName'] as String,
      totalSold: (json['totalSold'] as num).toInt(),
    );

Map<String, dynamic> _$$BestSellingProductModelImplToJson(
        _$BestSellingProductModelImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'totalSold': instance.totalSold,
    };

_$RevenueByDayModelImpl _$$RevenueByDayModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RevenueByDayModelImpl(
      date: DateTime.parse(json['date'] as String),
      revenue: (json['revenue'] as num).toDouble(),
      orderCount: (json['orderCount'] as num).toInt(),
    );

Map<String, dynamic> _$$RevenueByDayModelImplToJson(
        _$RevenueByDayModelImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'revenue': instance.revenue,
      'orderCount': instance.orderCount,
    };

_$RevenueByMonthModelImpl _$$RevenueByMonthModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RevenueByMonthModelImpl(
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      revenue: (json['revenue'] as num).toDouble(),
      orderCount: (json['orderCount'] as num).toInt(),
    );

Map<String, dynamic> _$$RevenueByMonthModelImplToJson(
        _$RevenueByMonthModelImpl instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'revenue': instance.revenue,
      'orderCount': instance.orderCount,
    };
