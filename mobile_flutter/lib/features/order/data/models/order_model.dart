import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/order.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
    required int orderId,
    required String customerName,
    required String customerPhone,
    required String shippingAddress,
    required double totalAmount,
    required String status,
    required DateTime createdAt,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
}

extension OrderModelMapper on OrderModel {
  OrderEntity toEntity() => OrderEntity(
        orderId: orderId,
        customerName: customerName,
        customerPhone: customerPhone,
        shippingAddress: shippingAddress,
        totalAmount: totalAmount,
        status: status,
        createdAt: createdAt,
      );
}
