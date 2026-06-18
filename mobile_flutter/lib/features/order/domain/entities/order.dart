class OrderEntity {
  final int orderId;
  final String customerName;
  final String customerPhone;
  final String shippingAddress;
  final double totalAmount;
  final String status;
  final DateTime createdAt;

  const OrderEntity({
    required this.orderId,
    required this.customerName,
    required this.customerPhone,
    required this.shippingAddress,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });
}
