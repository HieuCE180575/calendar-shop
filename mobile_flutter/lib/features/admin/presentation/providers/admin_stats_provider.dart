import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/constants/api_constants.dart';
import '../../data/models/admin_customer_stats_model.dart';
import '../../data/models/admin_product_stats_model.dart';
import '../../data/models/admin_category_stats_model.dart';
import '../../data/models/admin_discount_stats_model.dart';
import '../../data/models/admin_order_stats_model.dart';
import '../../domain/entities/admin_customer_stats.dart';
import '../../domain/entities/admin_product_stats.dart';
import '../../domain/entities/admin_category_stats.dart';
import '../../domain/entities/admin_discount_stats.dart';
import '../../domain/entities/admin_order_stats.dart';
import '../../data/models/admin_coupon_stats_model.dart';
import '../../domain/entities/admin_coupon_stats.dart';

import 'admin_dashboard_provider.dart';

final adminCustomerStatsProvider = FutureProvider.autoDispose<AdminCustomerStats>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final days = ref.watch(dashboardDaysFilterProvider);
  final response = await apiClient.dio.get('${ApiConstants.users}/stats?days=$days');
  return AdminCustomerStatsModel.fromJson(response.data).toEntity();
});

final adminProductStatsProvider = FutureProvider.autoDispose<AdminProductStats>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final days = ref.watch(dashboardDaysFilterProvider);
  final response = await apiClient.dio.get('${ApiConstants.products}/stats?days=$days');
  return AdminProductStatsModel.fromJson(response.data).toEntity();
});

final adminCategoryStatsProvider = FutureProvider.autoDispose<AdminCategoryStats>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.dio.get('${ApiConstants.categories}/stats');
  return AdminCategoryStatsModel.fromJson(response.data).toEntity();
});

final adminDiscountStatsProvider = FutureProvider.autoDispose<AdminDiscountStats>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.dio.get('${ApiConstants.discounts}/stats');
  return AdminDiscountStatsModel.fromJson(response.data).toEntity();
});

final adminOrderStatsProvider = FutureProvider.autoDispose<AdminOrderStats>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final days = ref.watch(dashboardDaysFilterProvider);
  final response = await apiClient.dio.get('${ApiConstants.orders}/admin/stats?days=$days');
  return AdminOrderStatsModel.fromJson(response.data).toEntity();
});

final adminCouponStatsProvider = FutureProvider.autoDispose<AdminCouponStats>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final days = ref.watch(dashboardDaysFilterProvider);
  final response = await apiClient.dio.get('${ApiConstants.coupons}/stats?days=$days');
  return AdminCouponStatsModel.fromJson(response.data).toEntity();
});
