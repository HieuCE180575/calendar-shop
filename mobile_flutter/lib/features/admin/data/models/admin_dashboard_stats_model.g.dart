// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdminDashboardStatsModelImpl _$$AdminDashboardStatsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AdminDashboardStatsModelImpl(
      totalUsers: (json['totalUsers'] as num).toInt(),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      totalOrders: (json['totalOrders'] as num).toInt(),
      totalProductsSold: (json['totalProductsSold'] as num).toInt(),
      totalOrdersGrowth: (json['totalOrdersGrowth'] as num).toDouble(),
      totalRevenueGrowth: (json['totalRevenueGrowth'] as num).toDouble(),
      newProductsCount: (json['newProductsCount'] as num).toInt(),
      totalProducts: (json['totalProducts'] as num).toInt(),
      totalOutOfStock: (json['totalOutOfStock'] as num).toInt(),
      totalLowStock: (json['totalLowStock'] as num).toInt(),
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
      recentOrders: (json['recentOrders'] as List<dynamic>)
          .map((e) => RecentOrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      lowStockProducts: (json['lowStockProducts'] as List<dynamic>)
          .map((e) => LowStockProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AdminDashboardStatsModelImplToJson(
        _$AdminDashboardStatsModelImpl instance) =>
    <String, dynamic>{
      'totalUsers': instance.totalUsers,
      'totalRevenue': instance.totalRevenue,
      'totalOrders': instance.totalOrders,
      'totalProductsSold': instance.totalProductsSold,
      'totalOrdersGrowth': instance.totalOrdersGrowth,
      'totalRevenueGrowth': instance.totalRevenueGrowth,
      'newProductsCount': instance.newProductsCount,
      'totalProducts': instance.totalProducts,
      'totalOutOfStock': instance.totalOutOfStock,
      'totalLowStock': instance.totalLowStock,
      'ordersByStatus': instance.ordersByStatus,
      'bestSelling': instance.bestSelling,
      'revenueByDay': instance.revenueByDay,
      'revenueByMonth': instance.revenueByMonth,
      'recentOrders': instance.recentOrders,
      'lowStockProducts': instance.lowStockProducts,
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

_$RecentOrderModelImpl _$$RecentOrderModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RecentOrderModelImpl(
      orderId: (json['orderId'] as num).toInt(),
      customerName: json['customerName'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      productName: json['productName'] as String,
      productImageUrl: json['productImageUrl'] as String?,
    );

Map<String, dynamic> _$$RecentOrderModelImplToJson(
        _$RecentOrderModelImpl instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'customerName': instance.customerName,
      'totalAmount': instance.totalAmount,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'productName': instance.productName,
      'productImageUrl': instance.productImageUrl,
    };

_$LowStockProductModelImpl _$$LowStockProductModelImplFromJson(
        Map<String, dynamic> json) =>
    _$LowStockProductModelImpl(
      productId: (json['productId'] as num).toInt(),
      productName: json['productName'] as String,
      stockQuantity: (json['stockQuantity'] as num).toInt(),
    );

Map<String, dynamic> _$$LowStockProductModelImplToJson(
        _$LowStockProductModelImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'stockQuantity': instance.stockQuantity,
    };
