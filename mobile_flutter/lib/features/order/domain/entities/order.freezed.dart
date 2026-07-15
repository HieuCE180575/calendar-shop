// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$OrderEntity {
  int get orderId => throw _privateConstructorUsedError;
  int get userId => throw _privateConstructorUsedError;
  String get customerName => throw _privateConstructorUsedError;
  String get customerPhone => throw _privateConstructorUsedError;
  String get shippingAddress => throw _privateConstructorUsedError;
  double get subTotal => throw _privateConstructorUsedError;
  double get discountAmount => throw _privateConstructorUsedError;
  double get shippingFee => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  String get paymentMethod => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  List<OrderItemEntity> get items => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OrderEntityCopyWith<OrderEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderEntityCopyWith<$Res> {
  factory $OrderEntityCopyWith(
          OrderEntity value, $Res Function(OrderEntity) then) =
      _$OrderEntityCopyWithImpl<$Res, OrderEntity>;
  @useResult
  $Res call(
      {int orderId,
      int userId,
      String customerName,
      String customerPhone,
      String shippingAddress,
      double subTotal,
      double discountAmount,
      double shippingFee,
      double totalAmount,
      String paymentMethod,
      String status,
      String? note,
      DateTime createdAt,
      List<OrderItemEntity> items});
}

/// @nodoc
class _$OrderEntityCopyWithImpl<$Res, $Val extends OrderEntity>
    implements $OrderEntityCopyWith<$Res> {
  _$OrderEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? userId = null,
    Object? customerName = null,
    Object? customerPhone = null,
    Object? shippingAddress = null,
    Object? subTotal = null,
    Object? discountAmount = null,
    Object? shippingFee = null,
    Object? totalAmount = null,
    Object? paymentMethod = null,
    Object? status = null,
    Object? note = freezed,
    Object? createdAt = null,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: null == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String,
      shippingAddress: null == shippingAddress
          ? _value.shippingAddress
          : shippingAddress // ignore: cast_nullable_to_non_nullable
              as String,
      subTotal: null == subTotal
          ? _value.subTotal
          : subTotal // ignore: cast_nullable_to_non_nullable
              as double,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
      shippingFee: null == shippingFee
          ? _value.shippingFee
          : shippingFee // ignore: cast_nullable_to_non_nullable
              as double,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItemEntity>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderEntityImplCopyWith<$Res>
    implements $OrderEntityCopyWith<$Res> {
  factory _$$OrderEntityImplCopyWith(
          _$OrderEntityImpl value, $Res Function(_$OrderEntityImpl) then) =
      __$$OrderEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int orderId,
      int userId,
      String customerName,
      String customerPhone,
      String shippingAddress,
      double subTotal,
      double discountAmount,
      double shippingFee,
      double totalAmount,
      String paymentMethod,
      String status,
      String? note,
      DateTime createdAt,
      List<OrderItemEntity> items});
}

/// @nodoc
class __$$OrderEntityImplCopyWithImpl<$Res>
    extends _$OrderEntityCopyWithImpl<$Res, _$OrderEntityImpl>
    implements _$$OrderEntityImplCopyWith<$Res> {
  __$$OrderEntityImplCopyWithImpl(
      _$OrderEntityImpl _value, $Res Function(_$OrderEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? userId = null,
    Object? customerName = null,
    Object? customerPhone = null,
    Object? shippingAddress = null,
    Object? subTotal = null,
    Object? discountAmount = null,
    Object? shippingFee = null,
    Object? totalAmount = null,
    Object? paymentMethod = null,
    Object? status = null,
    Object? note = freezed,
    Object? createdAt = null,
    Object? items = null,
  }) {
    return _then(_$OrderEntityImpl(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: null == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String,
      shippingAddress: null == shippingAddress
          ? _value.shippingAddress
          : shippingAddress // ignore: cast_nullable_to_non_nullable
              as String,
      subTotal: null == subTotal
          ? _value.subTotal
          : subTotal // ignore: cast_nullable_to_non_nullable
              as double,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
      shippingFee: null == shippingFee
          ? _value.shippingFee
          : shippingFee // ignore: cast_nullable_to_non_nullable
              as double,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItemEntity>,
    ));
  }
}

/// @nodoc

class _$OrderEntityImpl implements _OrderEntity {
  const _$OrderEntityImpl(
      {required this.orderId,
      required this.userId,
      required this.customerName,
      required this.customerPhone,
      required this.shippingAddress,
      required this.subTotal,
      required this.discountAmount,
      required this.shippingFee,
      required this.totalAmount,
      required this.paymentMethod,
      required this.status,
      this.note,
      required this.createdAt,
      required final List<OrderItemEntity> items})
      : _items = items;

  @override
  final int orderId;
  @override
  final int userId;
  @override
  final String customerName;
  @override
  final String customerPhone;
  @override
  final String shippingAddress;
  @override
  final double subTotal;
  @override
  final double discountAmount;
  @override
  final double shippingFee;
  @override
  final double totalAmount;
  @override
  final String paymentMethod;
  @override
  final String status;
  @override
  final String? note;
  @override
  final DateTime createdAt;
  final List<OrderItemEntity> _items;
  @override
  List<OrderItemEntity> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'OrderEntity(orderId: $orderId, userId: $userId, customerName: $customerName, customerPhone: $customerPhone, shippingAddress: $shippingAddress, subTotal: $subTotal, discountAmount: $discountAmount, shippingFee: $shippingFee, totalAmount: $totalAmount, paymentMethod: $paymentMethod, status: $status, note: $note, createdAt: $createdAt, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderEntityImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.shippingAddress, shippingAddress) ||
                other.shippingAddress == shippingAddress) &&
            (identical(other.subTotal, subTotal) ||
                other.subTotal == subTotal) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.shippingFee, shippingFee) ||
                other.shippingFee == shippingFee) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      orderId,
      userId,
      customerName,
      customerPhone,
      shippingAddress,
      subTotal,
      discountAmount,
      shippingFee,
      totalAmount,
      paymentMethod,
      status,
      note,
      createdAt,
      const DeepCollectionEquality().hash(_items));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderEntityImplCopyWith<_$OrderEntityImpl> get copyWith =>
      __$$OrderEntityImplCopyWithImpl<_$OrderEntityImpl>(this, _$identity);
}

abstract class _OrderEntity implements OrderEntity {
  const factory _OrderEntity(
      {required final int orderId,
      required final int userId,
      required final String customerName,
      required final String customerPhone,
      required final String shippingAddress,
      required final double subTotal,
      required final double discountAmount,
      required final double shippingFee,
      required final double totalAmount,
      required final String paymentMethod,
      required final String status,
      final String? note,
      required final DateTime createdAt,
      required final List<OrderItemEntity> items}) = _$OrderEntityImpl;

  @override
  int get orderId;
  @override
  int get userId;
  @override
  String get customerName;
  @override
  String get customerPhone;
  @override
  String get shippingAddress;
  @override
  double get subTotal;
  @override
  double get discountAmount;
  @override
  double get shippingFee;
  @override
  double get totalAmount;
  @override
  String get paymentMethod;
  @override
  String get status;
  @override
  String? get note;
  @override
  DateTime get createdAt;
  @override
  List<OrderItemEntity> get items;
  @override
  @JsonKey(ignore: true)
  _$$OrderEntityImplCopyWith<_$OrderEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
