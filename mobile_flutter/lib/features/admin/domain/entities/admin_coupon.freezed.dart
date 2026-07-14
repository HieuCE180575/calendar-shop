// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_coupon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AdminCoupon {
  int get couponId => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get discountType => throw _privateConstructorUsedError;
  double get discountValue => throw _privateConstructorUsedError;
  double get minOrderValue => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  int? get usageLimit => throw _privateConstructorUsedError;
  int get usedCount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AdminCouponCopyWith<AdminCoupon> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminCouponCopyWith<$Res> {
  factory $AdminCouponCopyWith(
          AdminCoupon value, $Res Function(AdminCoupon) then) =
      _$AdminCouponCopyWithImpl<$Res, AdminCoupon>;
  @useResult
  $Res call(
      {int couponId,
      String code,
      String? description,
      String discountType,
      double discountValue,
      double minOrderValue,
      DateTime startDate,
      DateTime endDate,
      int? usageLimit,
      int usedCount,
      String status,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$AdminCouponCopyWithImpl<$Res, $Val extends AdminCoupon>
    implements $AdminCouponCopyWith<$Res> {
  _$AdminCouponCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? couponId = null,
    Object? code = null,
    Object? description = freezed,
    Object? discountType = null,
    Object? discountValue = null,
    Object? minOrderValue = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? usageLimit = freezed,
    Object? usedCount = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      couponId: null == couponId
          ? _value.couponId
          : couponId // ignore: cast_nullable_to_non_nullable
              as int,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      discountType: null == discountType
          ? _value.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as String,
      discountValue: null == discountValue
          ? _value.discountValue
          : discountValue // ignore: cast_nullable_to_non_nullable
              as double,
      minOrderValue: null == minOrderValue
          ? _value.minOrderValue
          : minOrderValue // ignore: cast_nullable_to_non_nullable
              as double,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      usageLimit: freezed == usageLimit
          ? _value.usageLimit
          : usageLimit // ignore: cast_nullable_to_non_nullable
              as int?,
      usedCount: null == usedCount
          ? _value.usedCount
          : usedCount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdminCouponImplCopyWith<$Res>
    implements $AdminCouponCopyWith<$Res> {
  factory _$$AdminCouponImplCopyWith(
          _$AdminCouponImpl value, $Res Function(_$AdminCouponImpl) then) =
      __$$AdminCouponImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int couponId,
      String code,
      String? description,
      String discountType,
      double discountValue,
      double minOrderValue,
      DateTime startDate,
      DateTime endDate,
      int? usageLimit,
      int usedCount,
      String status,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$AdminCouponImplCopyWithImpl<$Res>
    extends _$AdminCouponCopyWithImpl<$Res, _$AdminCouponImpl>
    implements _$$AdminCouponImplCopyWith<$Res> {
  __$$AdminCouponImplCopyWithImpl(
      _$AdminCouponImpl _value, $Res Function(_$AdminCouponImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? couponId = null,
    Object? code = null,
    Object? description = freezed,
    Object? discountType = null,
    Object? discountValue = null,
    Object? minOrderValue = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? usageLimit = freezed,
    Object? usedCount = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$AdminCouponImpl(
      couponId: null == couponId
          ? _value.couponId
          : couponId // ignore: cast_nullable_to_non_nullable
              as int,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      discountType: null == discountType
          ? _value.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as String,
      discountValue: null == discountValue
          ? _value.discountValue
          : discountValue // ignore: cast_nullable_to_non_nullable
              as double,
      minOrderValue: null == minOrderValue
          ? _value.minOrderValue
          : minOrderValue // ignore: cast_nullable_to_non_nullable
              as double,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      usageLimit: freezed == usageLimit
          ? _value.usageLimit
          : usageLimit // ignore: cast_nullable_to_non_nullable
              as int?,
      usedCount: null == usedCount
          ? _value.usedCount
          : usedCount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$AdminCouponImpl implements _AdminCoupon {
  const _$AdminCouponImpl(
      {required this.couponId,
      required this.code,
      this.description,
      required this.discountType,
      required this.discountValue,
      required this.minOrderValue,
      required this.startDate,
      required this.endDate,
      this.usageLimit,
      required this.usedCount,
      required this.status,
      required this.createdAt,
      this.updatedAt});

  @override
  final int couponId;
  @override
  final String code;
  @override
  final String? description;
  @override
  final String discountType;
  @override
  final double discountValue;
  @override
  final double minOrderValue;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final int? usageLimit;
  @override
  final int usedCount;
  @override
  final String status;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'AdminCoupon(couponId: $couponId, code: $code, description: $description, discountType: $discountType, discountValue: $discountValue, minOrderValue: $minOrderValue, startDate: $startDate, endDate: $endDate, usageLimit: $usageLimit, usedCount: $usedCount, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminCouponImpl &&
            (identical(other.couponId, couponId) ||
                other.couponId == couponId) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.discountValue, discountValue) ||
                other.discountValue == discountValue) &&
            (identical(other.minOrderValue, minOrderValue) ||
                other.minOrderValue == minOrderValue) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.usageLimit, usageLimit) ||
                other.usageLimit == usageLimit) &&
            (identical(other.usedCount, usedCount) ||
                other.usedCount == usedCount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      couponId,
      code,
      description,
      discountType,
      discountValue,
      minOrderValue,
      startDate,
      endDate,
      usageLimit,
      usedCount,
      status,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminCouponImplCopyWith<_$AdminCouponImpl> get copyWith =>
      __$$AdminCouponImplCopyWithImpl<_$AdminCouponImpl>(this, _$identity);
}

abstract class _AdminCoupon implements AdminCoupon {
  const factory _AdminCoupon(
      {required final int couponId,
      required final String code,
      final String? description,
      required final String discountType,
      required final double discountValue,
      required final double minOrderValue,
      required final DateTime startDate,
      required final DateTime endDate,
      final int? usageLimit,
      required final int usedCount,
      required final String status,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$AdminCouponImpl;

  @override
  int get couponId;
  @override
  String get code;
  @override
  String? get description;
  @override
  String get discountType;
  @override
  double get discountValue;
  @override
  double get minOrderValue;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  int? get usageLimit;
  @override
  int get usedCount;
  @override
  String get status;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$AdminCouponImplCopyWith<_$AdminCouponImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
