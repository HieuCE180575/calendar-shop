class CreateOrderInput {
  const CreateOrderInput({
    required this.customerName,
    required this.customerPhone,
    required this.shippingAddress,
    required this.paymentMethod,
    this.couponCode,
    this.note,
  });

  final String customerName;
  final String customerPhone;
  final String shippingAddress;
  final String paymentMethod;
  final String? couponCode;
  final String? note;
}
