class CheckedCoupon {
  final String code;
  final String discountType;
  final double discountValue;

  const CheckedCoupon({
    required this.code,
    required this.discountType,
    required this.discountValue,
  });

  double calculateDiscount(double subtotal) {
    final discount = discountType == 'Percent'
        ? subtotal * (discountValue / 100)
        : discountValue;

    if (discount < 0) {
      return 0;
    }

    return discount > subtotal ? subtotal : discount;
  }
}
