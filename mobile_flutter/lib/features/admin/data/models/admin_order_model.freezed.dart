// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AdminOrderItemModel _$AdminOrderItemModelFromJson(Map<String, dynamic> json) {
  return _AdminOrderItemModel.fromJson(json);
}

/// @nodoc
mixin _$AdminOrderItemModel {
  int get orderItemId => throw _privateConstructorUsedError;
  int get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String? get productImageUrl => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AdminOrderItemModelCopyWith<AdminOrderItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminOrderItemModelCopyWith<$Res> {
  factory $AdminOrderItemModelCopyWith(
          AdminOrderItemModel value, $Res Function(AdminOrderItemModel) then) =
      _$AdminOrderItemModelCopyWithImpl<$Res, AdminOrderItemModel>;
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
class _$AdminOrderItemModelCopyWithImpl<$Res, $Val extends AdminOrderItemModel>
    implements $AdminOrderItemModelCopyWith<$Res> {
  _$AdminOrderItemModelCopyWithImpl(this._value, this._then);

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
abstract class _$$AdminOrderItemModelImplCopyWith<$Res>
    implements $AdminOrderItemModelCopyWith<$Res> {
  factory _$$AdminOrderItemModelImplCopyWith(_$AdminOrderItemModelImpl value,
          $Res Function(_$AdminOrderItemModelImpl) then) =
      __$$AdminOrderItemModelImplCopyWithImpl<$Res>;
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
class __$$AdminOrderItemModelImplCopyWithImpl<$Res>
    extends _$AdminOrderItemModelCopyWithImpl<$Res, _$AdminOrderItemModelImpl>
    implements _$$AdminOrderItemModelImplCopyWith<$Res> {
  __$$AdminOrderItemModelImplCopyWithImpl(_$AdminOrderItemModelImpl _value,
      $Res Function(_$AdminOrderItemModelImpl) _then)
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
    return _then(_$AdminOrderItemModelImpl(
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
@JsonSerializable()
class _$AdminOrderItemModelImpl implements _AdminOrderItemModel {
  const _$AdminOrderItemModelImpl(
      {required this.orderItemId,
      required this.productId,
      required this.productName,
      this.productImageUrl,
      required this.unitPrice,
      required this.quantity,
      required this.totalPrice});

  factory _$AdminOrderItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdminOrderItemModelImplFromJson(json);

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
    return 'AdminOrderItemModel(orderItemId: $orderItemId, productId: $productId, productName: $productName, productImageUrl: $productImageUrl, unitPrice: $unitPrice, quantity: $quantity, totalPrice: $totalPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminOrderItemModelImpl &&
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

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, orderItemId, productId,
      productName, productImageUrl, unitPrice, quantity, totalPrice);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminOrderItemModelImplCopyWith<_$AdminOrderItemModelImpl> get copyWith =>
      __$$AdminOrderItemModelImplCopyWithImpl<_$AdminOrderItemModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdminOrderItemModelImplToJson(
      this,
    );
  }
}

abstract class _AdminOrderItemModel implements AdminOrderItemModel {
  const factory _AdminOrderItemModel(
      {required final int orderItemId,
      required final int productId,
      required final String productName,
      final String? productImageUrl,
      required final double unitPrice,
      required final int quantity,
      required final double totalPrice}) = _$AdminOrderItemModelImpl;

  factory _AdminOrderItemModel.fromJson(Map<String, dynamic> json) =
      _$AdminOrderItemModelImpl.fromJson;

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
  _$$AdminOrderItemModelImplCopyWith<_$AdminOrderItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AdminOrderModel _$AdminOrderModelFromJson(Map<String, dynamic> json) {
  return _AdminOrderModel.fromJson(json);
}

/// @nodoc
mixin _$AdminOrderModel {
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
  List<AdminOrderItemModel> get items => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AdminOrderModelCopyWith<AdminOrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminOrderModelCopyWith<$Res> {
  factory $AdminOrderModelCopyWith(
          AdminOrderModel value, $Res Function(AdminOrderModel) then) =
      _$AdminOrderModelCopyWithImpl<$Res, AdminOrderModel>;
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
      List<AdminOrderItemModel> items});
}

/// @nodoc
class _$AdminOrderModelCopyWithImpl<$Res, $Val extends AdminOrderModel>
    implements $AdminOrderModelCopyWith<$Res> {
  _$AdminOrderModelCopyWithImpl(this._value, this._then);

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
              as List<AdminOrderItemModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdminOrderModelImplCopyWith<$Res>
    implements $AdminOrderModelCopyWith<$Res> {
  factory _$$AdminOrderModelImplCopyWith(_$AdminOrderModelImpl value,
          $Res Function(_$AdminOrderModelImpl) then) =
      __$$AdminOrderModelImplCopyWithImpl<$Res>;
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
      List<AdminOrderItemModel> items});
}

/// @nodoc
class __$$AdminOrderModelImplCopyWithImpl<$Res>
    extends _$AdminOrderModelCopyWithImpl<$Res, _$AdminOrderModelImpl>
    implements _$$AdminOrderModelImplCopyWith<$Res> {
  __$$AdminOrderModelImplCopyWithImpl(
      _$AdminOrderModelImpl _value, $Res Function(_$AdminOrderModelImpl) _then)
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
    return _then(_$AdminOrderModelImpl(
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
              as List<AdminOrderItemModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdminOrderModelImpl implements _AdminOrderModel {
  const _$AdminOrderModelImpl(
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
      final List<AdminOrderItemModel> items = const []})
      : _items = items;

  factory _$AdminOrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdminOrderModelImplFromJson(json);

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
  final List<AdminOrderItemModel> _items;
  @override
  @JsonKey()
  List<AdminOrderItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'AdminOrderModel(orderId: $orderId, userId: $userId, customerName: $customerName, customerPhone: $customerPhone, shippingAddress: $shippingAddress, subTotal: $subTotal, discountAmount: $discountAmount, shippingFee: $shippingFee, totalAmount: $totalAmount, paymentMethod: $paymentMethod, status: $status, note: $note, createdAt: $createdAt, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminOrderModelImpl &&
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

  @JsonKey(ignore: true)
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
  _$$AdminOrderModelImplCopyWith<_$AdminOrderModelImpl> get copyWith =>
      __$$AdminOrderModelImplCopyWithImpl<_$AdminOrderModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdminOrderModelImplToJson(
      this,
    );
  }
}

abstract class _AdminOrderModel implements AdminOrderModel {
  const factory _AdminOrderModel(
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
      final List<AdminOrderItemModel> items}) = _$AdminOrderModelImpl;

  factory _AdminOrderModel.fromJson(Map<String, dynamic> json) =
      _$AdminOrderModelImpl.fromJson;

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
  List<AdminOrderItemModel> get items;
  @override
  @JsonKey(ignore: true)
  _$$AdminOrderModelImplCopyWith<_$AdminOrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
