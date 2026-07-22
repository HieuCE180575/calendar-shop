import '../../domain/entities/checked_coupon.dart';

class CheckedCouponModel {
  final String code;
  final String discountType;
  final double discountValue;

  const CheckedCouponModel({
    required this.code,
    required this.discountType,
    required this.discountValue,
  });

  factory CheckedCouponModel.fromJson(Map<String, dynamic> json) {
    return CheckedCouponModel(
      code: json['code'] as String,
      discountType: json['discountType'] as String,
      discountValue: (json['discountValue'] as num).toDouble(),
    );
  }

  CheckedCoupon toEntity() => CheckedCoupon(
        code: code,
        discountType: discountType,
        discountValue: discountValue,
      );
}
