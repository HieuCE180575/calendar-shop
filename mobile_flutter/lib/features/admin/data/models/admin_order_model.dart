import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/admin_order.dart';

part 'admin_order_model.freezed.dart';
part 'admin_order_model.g.dart';

@freezed
class AdminOrderItemModel with _$AdminOrderItemModel {
  const factory AdminOrderItemModel({
    required int orderItemId,
    required int productId,
    required String productName,
    String? productImageUrl,
    required double unitPrice,
    required int quantity,
    required double totalPrice,
  }) = _AdminOrderItemModel;

  factory AdminOrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$AdminOrderItemModelFromJson(json);
}

@freezed
class AdminOrderModel with _$AdminOrderModel {
  const factory AdminOrderModel({
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
    @Default([]) List<AdminOrderItemModel> items,
  }) = _AdminOrderModel;

  factory AdminOrderModel.fromJson(Map<String, dynamic> json) =>
      _$AdminOrderModelFromJson(json);
}

extension AdminOrderItemModelMapper on AdminOrderItemModel {
  AdminOrderItem toEntity() => AdminOrderItem(
        orderItemId: orderItemId,
        productId: productId,
        productName: productName,
        productImageUrl: productImageUrl,
        unitPrice: unitPrice,
        quantity: quantity,
        totalPrice: totalPrice,
      );
}

extension AdminOrderModelMapper on AdminOrderModel {
  AdminOrder toEntity() => AdminOrder(
        orderId: orderId,
        userId: userId,
        customerName: customerName,
        customerPhone: customerPhone,
        shippingAddress: shippingAddress,
        subTotal: subTotal,
        discountAmount: discountAmount,
        shippingFee: shippingFee,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
        status: status,
        note: note,
        createdAt: createdAt,
        items: items.map((e) => e.toEntity()).toList(),
      );
}
