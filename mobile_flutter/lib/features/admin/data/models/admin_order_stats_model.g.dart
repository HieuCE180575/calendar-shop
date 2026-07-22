// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdminOrderStatsModelImpl _$$AdminOrderStatsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AdminOrderStatsModelImpl(
      totalOrders: (json['totalOrders'] as num).toInt(),
      totalOrdersGrowth: (json['totalOrdersGrowth'] as num?)?.toDouble() ?? 0.0,
      pendingOrders: (json['pendingOrders'] as num).toInt(),
      deliveringOrders: (json['deliveringOrders'] as num).toInt(),
      completedOrders: (json['completedOrders'] as num).toInt(),
      revenueGrowth: (json['revenueGrowth'] as num?)?.toDouble() ?? 0.0,
      cancelledOrders: (json['cancelledOrders'] as num).toInt(),
      statusDistribution: (json['statusDistribution'] as List<dynamic>)
          .map((e) =>
              OrderStatusDistributionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      revenueByDay: (json['revenueByDay'] as List<dynamic>)
          .map((e) => RevenueByDayModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AdminOrderStatsModelImplToJson(
        _$AdminOrderStatsModelImpl instance) =>
    <String, dynamic>{
      'totalOrders': instance.totalOrders,
      'totalOrdersGrowth': instance.totalOrdersGrowth,
      'pendingOrders': instance.pendingOrders,
      'deliveringOrders': instance.deliveringOrders,
      'completedOrders': instance.completedOrders,
      'revenueGrowth': instance.revenueGrowth,
      'cancelledOrders': instance.cancelledOrders,
      'statusDistribution': instance.statusDistribution,
      'revenueByDay': instance.revenueByDay,
    };

_$OrderStatusDistributionModelImpl _$$OrderStatusDistributionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OrderStatusDistributionModelImpl(
      status: json['status'] as String,
      total: (json['total'] as num).toInt(),
      percentage: (json['percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$$OrderStatusDistributionModelImplToJson(
        _$OrderStatusDistributionModelImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'total': instance.total,
      'percentage': instance.percentage,
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
