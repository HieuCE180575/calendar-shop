import 'package:freezed_annotation/freezed_annotation.dart';

import 'order_item.dart';

part 'order.freezed.dart';

@freezed
class OrderEntity with _$OrderEntity {
  const factory OrderEntity({
    required int orderId,
    required int userId,
    required String customerName,
    required String customerPhone,
    required String shippingAddress,
    required double subTotal,
    required double discountAmount,
    required double shippingFee,
    required double totalAmount,
    required String paymentMethod,
    required String status,
    String? note,
    required DateTime createdAt,
    required List<OrderItemEntity> items,
  }) = _OrderEntity;
}
