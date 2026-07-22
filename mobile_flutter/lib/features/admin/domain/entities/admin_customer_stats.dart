import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_customer_stats.freezed.dart';

@freezed
class AdminCustomerStats with _$AdminCustomerStats {
  const factory AdminCustomerStats({
    @Default(0) int totalCustomers,
    @Default(0.0) double totalCustomersGrowth,
    @Default(0) int newCustomers,
    @Default(0.0) double newCustomersGrowth,
    @Default(0) int loyalCustomers,
    @Default(0) int lockedAccounts,
    @Default([]) List<CustomerRankDistribution> rankDistribution,
    @Default([]) List<TopCustomer> topCustomers,
  }) = _AdminCustomerStats;
}

@freezed
class CustomerRankDistribution with _$CustomerRankDistribution {
  const factory CustomerRankDistribution({
    @Default('') String rank,
    @Default(0) int total,
    @Default(0.0) double percentage,
  }) = _CustomerRankDistribution;
}

@freezed
class TopCustomer with _$TopCustomer {
  const factory TopCustomer({
    @Default(0) int userId,
    @Default('') String fullName,
    @Default('') String email,
    @Default('') String rank,
    @Default(0) int totalOrders,
    @Default(0.0) double totalSpent,
  }) = _TopCustomer;
}
