// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdminCustomerStatsModelImpl _$$AdminCustomerStatsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AdminCustomerStatsModelImpl(
      totalCustomers: (json['totalCustomers'] as num).toInt(),
      totalCustomersGrowth:
          (json['totalCustomersGrowth'] as num?)?.toDouble() ?? 0.0,
      newCustomers: (json['newCustomers'] as num).toInt(),
      newCustomersGrowth:
          (json['newCustomersGrowth'] as num?)?.toDouble() ?? 0.0,
      loyalCustomers: (json['loyalCustomers'] as num).toInt(),
      lockedAccounts: (json['lockedAccounts'] as num).toInt(),
      rankDistribution: (json['rankDistribution'] as List<dynamic>)
          .map((e) =>
              CustomerRankDistributionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      topCustomers: (json['topCustomers'] as List<dynamic>)
          .map((e) => TopCustomerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AdminCustomerStatsModelImplToJson(
        _$AdminCustomerStatsModelImpl instance) =>
    <String, dynamic>{
      'totalCustomers': instance.totalCustomers,
      'totalCustomersGrowth': instance.totalCustomersGrowth,
      'newCustomers': instance.newCustomers,
      'newCustomersGrowth': instance.newCustomersGrowth,
      'loyalCustomers': instance.loyalCustomers,
      'lockedAccounts': instance.lockedAccounts,
      'rankDistribution': instance.rankDistribution,
      'topCustomers': instance.topCustomers,
    };

_$CustomerRankDistributionModelImpl
    _$$CustomerRankDistributionModelImplFromJson(Map<String, dynamic> json) =>
        _$CustomerRankDistributionModelImpl(
          rank: json['rank'] as String,
          total: (json['total'] as num).toInt(),
          percentage: (json['percentage'] as num).toDouble(),
        );

Map<String, dynamic> _$$CustomerRankDistributionModelImplToJson(
        _$CustomerRankDistributionModelImpl instance) =>
    <String, dynamic>{
      'rank': instance.rank,
      'total': instance.total,
      'percentage': instance.percentage,
    };

_$TopCustomerModelImpl _$$TopCustomerModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TopCustomerModelImpl(
      userId: (json['userId'] as num).toInt(),
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      rank: json['rank'] as String,
      totalOrders: (json['totalOrders'] as num).toInt(),
      totalSpent: (json['totalSpent'] as num).toDouble(),
    );

Map<String, dynamic> _$$TopCustomerModelImplToJson(
        _$TopCustomerModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'fullName': instance.fullName,
      'email': instance.email,
      'rank': instance.rank,
      'totalOrders': instance.totalOrders,
      'totalSpent': instance.totalSpent,
    };
