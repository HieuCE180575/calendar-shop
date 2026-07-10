// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$OrderItemEntity {
  int get orderItemId => throw _privateConstructorUsedError;
  int get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String? get productImageUrl => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OrderItemEntityCopyWith<OrderItemEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemEntityCopyWith<$Res> {
  factory $OrderItemEntityCopyWith(
          OrderItemEntity value, $Res Function(OrderItemEntity) then) =
      _$OrderItemEntityCopyWithImpl<$Res, OrderItemEntity>;
  @useResult
  $Res call(
      {int orderItemId,
      int productId,
      String productName,
      String? productImageUrl,
      double unitPrice,
      int quantity,
      double totalPrice});
}

/// @nodoc
class _$OrderItemEntityCopyWithImpl<$Res, $Val extends OrderItemEntity>
    implements $OrderItemEntityCopyWith<$Res> {
  _$OrderItemEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderItemId = null,
    Object? productId = null,
    Object? productName = null,
    Object? productImageUrl = freezed,
    Object? unitPrice = null,
    Object? quantity = null,
    Object? totalPrice = null,
  }) {
    return _then(_value.copyWith(
      orderItemId: null == orderItemId
          ? _value.orderItemId
          : orderItemId // ignore: cast_nullable_to_non_nullable
              as int,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      productImageUrl: freezed == productImageUrl
          ? _value.productImageUrl
          : productImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderItemEntityImplCopyWith<$Res>
    implements $OrderItemEntityCopyWith<$Res> {
  factory _$$OrderItemEntityImplCopyWith(_$OrderItemEntityImpl value,
          $Res Function(_$OrderItemEntityImpl) then) =
      __$$OrderItemEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int orderItemId,
      int productId,
      String productName,
      String? productImageUrl,
      double unitPrice,
      int quantity,
      double totalPrice});
}

/// @nodoc
class __$$OrderItemEntityImplCopyWithImpl<$Res>
    extends _$OrderItemEntityCopyWithImpl<$Res, _$OrderItemEntityImpl>
    implements _$$OrderItemEntityImplCopyWith<$Res> {
  __$$OrderItemEntityImplCopyWithImpl(
      _$OrderItemEntityImpl _value, $Res Function(_$OrderItemEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderItemId = null,
    Object? productId = null,
    Object? productName = null,
    Object? productImageUrl = freezed,
    Object? unitPrice = null,
    Object? quantity = null,
    Object? totalPrice = null,
  }) {
    return _then(_$OrderItemEntityImpl(
      orderItemId: null == orderItemId
          ? _value.orderItemId
          : orderItemId // ignore: cast_nullable_to_non_nullable
              as int,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      productImageUrl: freezed == productImageUrl
          ? _value.productImageUrl
          : productImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$OrderItemEntityImpl implements _OrderItemEntity {
  const _$OrderItemEntityImpl(
      {required this.orderItemId,
      required this.productId,
      required this.productName,
      this.productImageUrl,
      required this.unitPrice,
      required this.quantity,
      required this.totalPrice});

  @override
  final int orderItemId;
  @override
  final int productId;
  @override
  final String productName;
  @override
  final String? productImageUrl;
  @override
  final double unitPrice;
  @override
  final int quantity;
  @override
  final double totalPrice;

  @override
  String toString() {
    return 'OrderItemEntity(orderItemId: $orderItemId, productId: $productId, productName: $productName, productImageUrl: $productImageUrl, unitPrice: $unitPrice, quantity: $quantity, totalPrice: $totalPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemEntityImpl &&
            (identical(other.orderItemId, orderItemId) ||
                other.orderItemId == orderItemId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productImageUrl, productImageUrl) ||
                other.productImageUrl == productImageUrl) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice));
  }

  @override
  int get hashCode => Object.hash(runtimeType, orderItemId, productId,
      productName, productImageUrl, unitPrice, quantity, totalPrice);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemEntityImplCopyWith<_$OrderItemEntityImpl> get copyWith =>
      __$$OrderItemEntityImplCopyWithImpl<_$OrderItemEntityImpl>(
          this, _$identity);
}

abstract class _OrderItemEntity implements OrderItemEntity {
  const factory _OrderItemEntity(
      {required final int orderItemId,
      required final int productId,
      required final String productName,
      final String? productImageUrl,
      required final double unitPrice,
      required final int quantity,
      required final double totalPrice}) = _$OrderItemEntityImpl;

  @override
  int get orderItemId;
  @override
  int get productId;
  @override
  String get productName;
  @override
  String? get productImageUrl;
  @override
  double get unitPrice;
  @override
  int get quantity;
  @override
  double get totalPrice;
  @override
  @JsonKey(ignore: true)
  _$$OrderItemEntityImplCopyWith<_$OrderItemEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
