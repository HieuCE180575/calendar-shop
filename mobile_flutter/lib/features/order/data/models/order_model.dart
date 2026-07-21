import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_item.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
class OrderItemModel with _$OrderItemModel {
  const factory OrderItemModel({
    required int orderItemId,
    required int productId,
    required String productName,
    String? productImageUrl,
    required double unitPrice,
    required int quantity,
    required double totalPrice,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);
}

@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
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
    @Default([]) List<OrderItemModel> items,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
}

extension OrderItemModelMapper on OrderItemModel {
  OrderItemEntity toEntity() => OrderItemEntity(
        orderItemId: orderItemId,
        productId: productId,
        productName: productName,
        productImageUrl: productImageUrl,
        unitPrice: unitPrice,
        quantity: quantity,
        totalPrice: totalPrice,
      );
}

extension OrderModelMapper on OrderModel {
  OrderEntity toEntity() => OrderEntity(
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
        items: items.map((item) => item.toEntity()).toList(),
      );
}
