import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_order.freezed.dart';

@freezed
class AdminOrderItem with _$AdminOrderItem {
  const factory AdminOrderItem({
    required int orderItemId,
    required int productId,
    required String productName,
    String? productImageUrl,
    required double unitPrice,
    required int quantity,
    required double totalPrice,
  }) = _AdminOrderItem;
}

@freezed
class AdminOrder with _$AdminOrder {
  const factory AdminOrder({
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
    @Default([]) List<AdminOrderItem> items,
  }) = _AdminOrder;
}
