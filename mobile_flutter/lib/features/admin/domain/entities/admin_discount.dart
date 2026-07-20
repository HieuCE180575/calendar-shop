import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_discount.freezed.dart';

@freezed
class AdminDiscount with _$AdminDiscount {
  const factory AdminDiscount({
    required int discountId,
    required String name,
    required String discountType,
    required double discountValue,
    required DateTime startDate,
    required DateTime endDate,
    required String status,
    required DateTime createdAt,
    @Default([]) List<int> productIds,
    @Default([]) List<int> categoryIds,
  }) = _AdminDiscount;
}
