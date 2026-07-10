import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_item.freezed.dart';

@freezed
class OrderItemEntity with _$OrderItemEntity {
  const factory OrderItemEntity({
    required int orderItemId,
    required int productId,
    required String productName,
    String? productImageUrl,
    required double unitPrice,
    required int quantity,
    required double totalPrice,
  }) = _OrderItemEntity;
}
