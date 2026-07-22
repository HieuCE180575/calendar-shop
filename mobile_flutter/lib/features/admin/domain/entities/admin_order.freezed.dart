// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AdminOrderItem {
  int get orderItemId => throw _privateConstructorUsedError;
  int get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String? get productImageUrl => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AdminOrderItemCopyWith<AdminOrderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminOrderItemCopyWith<$Res> {
  factory $AdminOrderItemCopyWith(
          AdminOrderItem value, $Res Function(AdminOrderItem) then) =
      _$AdminOrderItemCopyWithImpl<$Res, AdminOrderItem>;
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
class _$AdminOrderItemCopyWithImpl<$Res, $Val extends AdminOrderItem>
    implements $AdminOrderItemCopyWith<$Res> {
  _$AdminOrderItemCopyWithImpl(this._value, this._then);

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
abstract class _$$AdminOrderItemImplCopyWith<$Res>
    implements $AdminOrderItemCopyWith<$Res> {
  factory _$$AdminOrderItemImplCopyWith(_$AdminOrderItemImpl value,
          $Res Function(_$AdminOrderItemImpl) then) =
      __$$AdminOrderItemImplCopyWithImpl<$Res>;
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
class __$$AdminOrderItemImplCopyWithImpl<$Res>
    extends _$AdminOrderItemCopyWithImpl<$Res, _$AdminOrderItemImpl>
    implements _$$AdminOrderItemImplCopyWith<$Res> {
  __$$AdminOrderItemImplCopyWithImpl(
      _$AdminOrderItemImpl _value, $Res Function(_$AdminOrderItemImpl) _then)
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
    return _then(_$AdminOrderItemImpl(
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

class _$AdminOrderItemImpl implements _AdminOrderItem {
  const _$AdminOrderItemImpl(
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
    return 'AdminOrderItem(orderItemId: $orderItemId, productId: $productId, productName: $productName, productImageUrl: $productImageUrl, unitPrice: $unitPrice, quantity: $quantity, totalPrice: $totalPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminOrderItemImpl &&
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
  _$$AdminOrderItemImplCopyWith<_$AdminOrderItemImpl> get copyWith =>
      __$$AdminOrderItemImplCopyWithImpl<_$AdminOrderItemImpl>(
          this, _$identity);
}

abstract class _AdminOrderItem implements AdminOrderItem {
  const factory _AdminOrderItem(
      {required final int orderItemId,
      required final int productId,
      required final String productName,
      final String? productImageUrl,
      required final double unitPrice,
      required final int quantity,
      required final double totalPrice}) = _$AdminOrderItemImpl;

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
  _$$AdminOrderItemImplCopyWith<_$AdminOrderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AdminOrder {
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
  List<AdminOrderItem> get items => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AdminOrderCopyWith<AdminOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminOrderCopyWith<$Res> {
  factory $AdminOrderCopyWith(
          AdminOrder value, $Res Function(AdminOrder) then) =
      _$AdminOrderCopyWithImpl<$Res, AdminOrder>;
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
      List<AdminOrderItem> items});
}

/// @nodoc
class _$AdminOrderCopyWithImpl<$Res, $Val extends AdminOrder>
    implements $AdminOrderCopyWith<$Res> {
  _$AdminOrderCopyWithImpl(this._value, this._then);

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
              as List<AdminOrderItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdminOrderImplCopyWith<$Res>
    implements $AdminOrderCopyWith<$Res> {
  factory _$$AdminOrderImplCopyWith(
          _$AdminOrderImpl value, $Res Function(_$AdminOrderImpl) then) =
      __$$AdminOrderImplCopyWithImpl<$Res>;
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
      List<AdminOrderItem> items});
}

/// @nodoc
class __$$AdminOrderImplCopyWithImpl<$Res>
    extends _$AdminOrderCopyWithImpl<$Res, _$AdminOrderImpl>
    implements _$$AdminOrderImplCopyWith<$Res> {
  __$$AdminOrderImplCopyWithImpl(
      _$AdminOrderImpl _value, $Res Function(_$AdminOrderImpl) _then)
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
    return _then(_$AdminOrderImpl(
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
              as List<AdminOrderItem>,
    ));
  }
}

/// @nodoc

class _$AdminOrderImpl implements _AdminOrder {
  const _$AdminOrderImpl(
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
      final List<AdminOrderItem> items = const []})
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
  final List<AdminOrderItem> _items;
  @override
  @JsonKey()
  List<AdminOrderItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'AdminOrder(orderId: $orderId, userId: $userId, customerName: $customerName, customerPhone: $customerPhone, shippingAddress: $shippingAddress, subTotal: $subTotal, discountAmount: $discountAmount, shippingFee: $shippingFee, totalAmount: $totalAmount, paymentMethod: $paymentMethod, status: $status, note: $note, createdAt: $createdAt, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminOrderImpl &&
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
  _$$AdminOrderImplCopyWith<_$AdminOrderImpl> get copyWith =>
      __$$AdminOrderImplCopyWithImpl<_$AdminOrderImpl>(this, _$identity);
}

abstract class _AdminOrder implements AdminOrder {
  const factory _AdminOrder(
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
      final List<AdminOrderItem> items}) = _$AdminOrderImpl;

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
  List<AdminOrderItem> get items;
  @override
  @JsonKey(ignore: true)
  _$$AdminOrderImplCopyWith<_$AdminOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
