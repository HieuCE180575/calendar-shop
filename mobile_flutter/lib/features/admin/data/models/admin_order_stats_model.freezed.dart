// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_order_stats_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AdminOrderStatsModel _$AdminOrderStatsModelFromJson(Map<String, dynamic> json) {
  return _AdminOrderStatsModel.fromJson(json);
}

/// @nodoc
mixin _$AdminOrderStatsModel {
  int get totalOrders => throw _privateConstructorUsedError;
  double get totalOrdersGrowth => throw _privateConstructorUsedError;
  int get pendingOrders => throw _privateConstructorUsedError;
  int get deliveringOrders => throw _privateConstructorUsedError;
  int get completedOrders => throw _privateConstructorUsedError;
  double get revenueGrowth => throw _privateConstructorUsedError;
  int get cancelledOrders => throw _privateConstructorUsedError;
  List<OrderStatusDistributionModel> get statusDistribution =>
      throw _privateConstructorUsedError;
  List<RevenueByDayModel> get revenueByDay =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AdminOrderStatsModelCopyWith<AdminOrderStatsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminOrderStatsModelCopyWith<$Res> {
  factory $AdminOrderStatsModelCopyWith(AdminOrderStatsModel value,
          $Res Function(AdminOrderStatsModel) then) =
      _$AdminOrderStatsModelCopyWithImpl<$Res, AdminOrderStatsModel>;
  @useResult
  $Res call(
      {int totalOrders,
      double totalOrdersGrowth,
      int pendingOrders,
      int deliveringOrders,
      int completedOrders,
      double revenueGrowth,
      int cancelledOrders,
      List<OrderStatusDistributionModel> statusDistribution,
      List<RevenueByDayModel> revenueByDay});
}

/// @nodoc
class _$AdminOrderStatsModelCopyWithImpl<$Res,
        $Val extends AdminOrderStatsModel>
    implements $AdminOrderStatsModelCopyWith<$Res> {
  _$AdminOrderStatsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalOrders = null,
    Object? totalOrdersGrowth = null,
    Object? pendingOrders = null,
    Object? deliveringOrders = null,
    Object? completedOrders = null,
    Object? revenueGrowth = null,
    Object? cancelledOrders = null,
    Object? statusDistribution = null,
    Object? revenueByDay = null,
  }) {
    return _then(_value.copyWith(
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      totalOrdersGrowth: null == totalOrdersGrowth
          ? _value.totalOrdersGrowth
          : totalOrdersGrowth // ignore: cast_nullable_to_non_nullable
              as double,
      pendingOrders: null == pendingOrders
          ? _value.pendingOrders
          : pendingOrders // ignore: cast_nullable_to_non_nullable
              as int,
      deliveringOrders: null == deliveringOrders
          ? _value.deliveringOrders
          : deliveringOrders // ignore: cast_nullable_to_non_nullable
              as int,
      completedOrders: null == completedOrders
          ? _value.completedOrders
          : completedOrders // ignore: cast_nullable_to_non_nullable
              as int,
      revenueGrowth: null == revenueGrowth
          ? _value.revenueGrowth
          : revenueGrowth // ignore: cast_nullable_to_non_nullable
              as double,
      cancelledOrders: null == cancelledOrders
          ? _value.cancelledOrders
          : cancelledOrders // ignore: cast_nullable_to_non_nullable
              as int,
      statusDistribution: null == statusDistribution
          ? _value.statusDistribution
          : statusDistribution // ignore: cast_nullable_to_non_nullable
              as List<OrderStatusDistributionModel>,
      revenueByDay: null == revenueByDay
          ? _value.revenueByDay
          : revenueByDay // ignore: cast_nullable_to_non_nullable
              as List<RevenueByDayModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdminOrderStatsModelImplCopyWith<$Res>
    implements $AdminOrderStatsModelCopyWith<$Res> {
  factory _$$AdminOrderStatsModelImplCopyWith(_$AdminOrderStatsModelImpl value,
          $Res Function(_$AdminOrderStatsModelImpl) then) =
      __$$AdminOrderStatsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalOrders,
      double totalOrdersGrowth,
      int pendingOrders,
      int deliveringOrders,
      int completedOrders,
      double revenueGrowth,
      int cancelledOrders,
      List<OrderStatusDistributionModel> statusDistribution,
      List<RevenueByDayModel> revenueByDay});
}

/// @nodoc
class __$$AdminOrderStatsModelImplCopyWithImpl<$Res>
    extends _$AdminOrderStatsModelCopyWithImpl<$Res, _$AdminOrderStatsModelImpl>
    implements _$$AdminOrderStatsModelImplCopyWith<$Res> {
  __$$AdminOrderStatsModelImplCopyWithImpl(_$AdminOrderStatsModelImpl _value,
      $Res Function(_$AdminOrderStatsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalOrders = null,
    Object? totalOrdersGrowth = null,
    Object? pendingOrders = null,
    Object? deliveringOrders = null,
    Object? completedOrders = null,
    Object? revenueGrowth = null,
    Object? cancelledOrders = null,
    Object? statusDistribution = null,
    Object? revenueByDay = null,
  }) {
    return _then(_$AdminOrderStatsModelImpl(
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      totalOrdersGrowth: null == totalOrdersGrowth
          ? _value.totalOrdersGrowth
          : totalOrdersGrowth // ignore: cast_nullable_to_non_nullable
              as double,
      pendingOrders: null == pendingOrders
          ? _value.pendingOrders
          : pendingOrders // ignore: cast_nullable_to_non_nullable
              as int,
      deliveringOrders: null == deliveringOrders
          ? _value.deliveringOrders
          : deliveringOrders // ignore: cast_nullable_to_non_nullable
              as int,
      completedOrders: null == completedOrders
          ? _value.completedOrders
          : completedOrders // ignore: cast_nullable_to_non_nullable
              as int,
      revenueGrowth: null == revenueGrowth
          ? _value.revenueGrowth
          : revenueGrowth // ignore: cast_nullable_to_non_nullable
              as double,
      cancelledOrders: null == cancelledOrders
          ? _value.cancelledOrders
          : cancelledOrders // ignore: cast_nullable_to_non_nullable
              as int,
      statusDistribution: null == statusDistribution
          ? _value._statusDistribution
          : statusDistribution // ignore: cast_nullable_to_non_nullable
              as List<OrderStatusDistributionModel>,
      revenueByDay: null == revenueByDay
          ? _value._revenueByDay
          : revenueByDay // ignore: cast_nullable_to_non_nullable
              as List<RevenueByDayModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdminOrderStatsModelImpl implements _AdminOrderStatsModel {
  const _$AdminOrderStatsModelImpl(
      {required this.totalOrders,
      this.totalOrdersGrowth = 0.0,
      required this.pendingOrders,
      required this.deliveringOrders,
      required this.completedOrders,
      this.revenueGrowth = 0.0,
      required this.cancelledOrders,
      required final List<OrderStatusDistributionModel> statusDistribution,
      required final List<RevenueByDayModel> revenueByDay})
      : _statusDistribution = statusDistribution,
        _revenueByDay = revenueByDay;

  factory _$AdminOrderStatsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdminOrderStatsModelImplFromJson(json);

  @override
  final int totalOrders;
  @override
  @JsonKey()
  final double totalOrdersGrowth;
  @override
  final int pendingOrders;
  @override
  final int deliveringOrders;
  @override
  final int completedOrders;
  @override
  @JsonKey()
  final double revenueGrowth;
  @override
  final int cancelledOrders;
  final List<OrderStatusDistributionModel> _statusDistribution;
  @override
  List<OrderStatusDistributionModel> get statusDistribution {
    if (_statusDistribution is EqualUnmodifiableListView)
      return _statusDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_statusDistribution);
  }

  final List<RevenueByDayModel> _revenueByDay;
  @override
  List<RevenueByDayModel> get revenueByDay {
    if (_revenueByDay is EqualUnmodifiableListView) return _revenueByDay;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_revenueByDay);
  }

  @override
  String toString() {
    return 'AdminOrderStatsModel(totalOrders: $totalOrders, totalOrdersGrowth: $totalOrdersGrowth, pendingOrders: $pendingOrders, deliveringOrders: $deliveringOrders, completedOrders: $completedOrders, revenueGrowth: $revenueGrowth, cancelledOrders: $cancelledOrders, statusDistribution: $statusDistribution, revenueByDay: $revenueByDay)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminOrderStatsModelImpl &&
            (identical(other.totalOrders, totalOrders) ||
                other.totalOrders == totalOrders) &&
            (identical(other.totalOrdersGrowth, totalOrdersGrowth) ||
                other.totalOrdersGrowth == totalOrdersGrowth) &&
            (identical(other.pendingOrders, pendingOrders) ||
                other.pendingOrders == pendingOrders) &&
            (identical(other.deliveringOrders, deliveringOrders) ||
                other.deliveringOrders == deliveringOrders) &&
            (identical(other.completedOrders, completedOrders) ||
                other.completedOrders == completedOrders) &&
            (identical(other.revenueGrowth, revenueGrowth) ||
                other.revenueGrowth == revenueGrowth) &&
            (identical(other.cancelledOrders, cancelledOrders) ||
                other.cancelledOrders == cancelledOrders) &&
            const DeepCollectionEquality()
                .equals(other._statusDistribution, _statusDistribution) &&
            const DeepCollectionEquality()
                .equals(other._revenueByDay, _revenueByDay));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalOrders,
      totalOrdersGrowth,
      pendingOrders,
      deliveringOrders,
      completedOrders,
      revenueGrowth,
      cancelledOrders,
      const DeepCollectionEquality().hash(_statusDistribution),
      const DeepCollectionEquality().hash(_revenueByDay));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminOrderStatsModelImplCopyWith<_$AdminOrderStatsModelImpl>
      get copyWith =>
          __$$AdminOrderStatsModelImplCopyWithImpl<_$AdminOrderStatsModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdminOrderStatsModelImplToJson(
      this,
    );
  }
}

abstract class _AdminOrderStatsModel implements AdminOrderStatsModel {
  const factory _AdminOrderStatsModel(
          {required final int totalOrders,
          final double totalOrdersGrowth,
          required final int pendingOrders,
          required final int deliveringOrders,
          required final int completedOrders,
          final double revenueGrowth,
          required final int cancelledOrders,
          required final List<OrderStatusDistributionModel> statusDistribution,
          required final List<RevenueByDayModel> revenueByDay}) =
      _$AdminOrderStatsModelImpl;

  factory _AdminOrderStatsModel.fromJson(Map<String, dynamic> json) =
      _$AdminOrderStatsModelImpl.fromJson;

  @override
  int get totalOrders;
  @override
  double get totalOrdersGrowth;
  @override
  int get pendingOrders;
  @override
  int get deliveringOrders;
  @override
  int get completedOrders;
  @override
  double get revenueGrowth;
  @override
  int get cancelledOrders;
  @override
  List<OrderStatusDistributionModel> get statusDistribution;
  @override
  List<RevenueByDayModel> get revenueByDay;
  @override
  @JsonKey(ignore: true)
  _$$AdminOrderStatsModelImplCopyWith<_$AdminOrderStatsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

OrderStatusDistributionModel _$OrderStatusDistributionModelFromJson(
    Map<String, dynamic> json) {
  return _OrderStatusDistributionModel.fromJson(json);
}

/// @nodoc
mixin _$OrderStatusDistributionModel {
  String get status => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderStatusDistributionModelCopyWith<OrderStatusDistributionModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderStatusDistributionModelCopyWith<$Res> {
  factory $OrderStatusDistributionModelCopyWith(
          OrderStatusDistributionModel value,
          $Res Function(OrderStatusDistributionModel) then) =
      _$OrderStatusDistributionModelCopyWithImpl<$Res,
          OrderStatusDistributionModel>;
  @useResult
  $Res call({String status, int total, double percentage});
}

/// @nodoc
class _$OrderStatusDistributionModelCopyWithImpl<$Res,
        $Val extends OrderStatusDistributionModel>
    implements $OrderStatusDistributionModelCopyWith<$Res> {
  _$OrderStatusDistributionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? total = null,
    Object? percentage = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderStatusDistributionModelImplCopyWith<$Res>
    implements $OrderStatusDistributionModelCopyWith<$Res> {
  factory _$$OrderStatusDistributionModelImplCopyWith(
          _$OrderStatusDistributionModelImpl value,
          $Res Function(_$OrderStatusDistributionModelImpl) then) =
      __$$OrderStatusDistributionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String status, int total, double percentage});
}

/// @nodoc
class __$$OrderStatusDistributionModelImplCopyWithImpl<$Res>
    extends _$OrderStatusDistributionModelCopyWithImpl<$Res,
        _$OrderStatusDistributionModelImpl>
    implements _$$OrderStatusDistributionModelImplCopyWith<$Res> {
  __$$OrderStatusDistributionModelImplCopyWithImpl(
      _$OrderStatusDistributionModelImpl _value,
      $Res Function(_$OrderStatusDistributionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? total = null,
    Object? percentage = null,
  }) {
    return _then(_$OrderStatusDistributionModelImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderStatusDistributionModelImpl
    implements _OrderStatusDistributionModel {
  const _$OrderStatusDistributionModelImpl(
      {required this.status, required this.total, required this.percentage});

  factory _$OrderStatusDistributionModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$OrderStatusDistributionModelImplFromJson(json);

  @override
  final String status;
  @override
  final int total;
  @override
  final double percentage;

  @override
  String toString() {
    return 'OrderStatusDistributionModel(status: $status, total: $total, percentage: $percentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderStatusDistributionModelImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, status, total, percentage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderStatusDistributionModelImplCopyWith<
          _$OrderStatusDistributionModelImpl>
      get copyWith => __$$OrderStatusDistributionModelImplCopyWithImpl<
          _$OrderStatusDistributionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderStatusDistributionModelImplToJson(
      this,
    );
  }
}

abstract class _OrderStatusDistributionModel
    implements OrderStatusDistributionModel {
  const factory _OrderStatusDistributionModel(
      {required final String status,
      required final int total,
      required final double percentage}) = _$OrderStatusDistributionModelImpl;

  factory _OrderStatusDistributionModel.fromJson(Map<String, dynamic> json) =
      _$OrderStatusDistributionModelImpl.fromJson;

  @override
  String get status;
  @override
  int get total;
  @override
  double get percentage;
  @override
  @JsonKey(ignore: true)
  _$$OrderStatusDistributionModelImplCopyWith<
          _$OrderStatusDistributionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

RevenueByDayModel _$RevenueByDayModelFromJson(Map<String, dynamic> json) {
  return _RevenueByDayModel.fromJson(json);
}

/// @nodoc
mixin _$RevenueByDayModel {
  DateTime get date => throw _privateConstructorUsedError;
  double get revenue => throw _privateConstructorUsedError;
  int get orderCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RevenueByDayModelCopyWith<RevenueByDayModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RevenueByDayModelCopyWith<$Res> {
  factory $RevenueByDayModelCopyWith(
          RevenueByDayModel value, $Res Function(RevenueByDayModel) then) =
      _$RevenueByDayModelCopyWithImpl<$Res, RevenueByDayModel>;
  @useResult
  $Res call({DateTime date, double revenue, int orderCount});
}

/// @nodoc
class _$RevenueByDayModelCopyWithImpl<$Res, $Val extends RevenueByDayModel>
    implements $RevenueByDayModelCopyWith<$Res> {
  _$RevenueByDayModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? revenue = null,
    Object? orderCount = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      revenue: null == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as double,
      orderCount: null == orderCount
          ? _value.orderCount
          : orderCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RevenueByDayModelImplCopyWith<$Res>
    implements $RevenueByDayModelCopyWith<$Res> {
  factory _$$RevenueByDayModelImplCopyWith(_$RevenueByDayModelImpl value,
          $Res Function(_$RevenueByDayModelImpl) then) =
      __$$RevenueByDayModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, double revenue, int orderCount});
}

/// @nodoc
class __$$RevenueByDayModelImplCopyWithImpl<$Res>
    extends _$RevenueByDayModelCopyWithImpl<$Res, _$RevenueByDayModelImpl>
    implements _$$RevenueByDayModelImplCopyWith<$Res> {
  __$$RevenueByDayModelImplCopyWithImpl(_$RevenueByDayModelImpl _value,
      $Res Function(_$RevenueByDayModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? revenue = null,
    Object? orderCount = null,
  }) {
    return _then(_$RevenueByDayModelImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      revenue: null == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as double,
      orderCount: null == orderCount
          ? _value.orderCount
          : orderCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RevenueByDayModelImpl implements _RevenueByDayModel {
  const _$RevenueByDayModelImpl(
      {required this.date, required this.revenue, required this.orderCount});

  factory _$RevenueByDayModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RevenueByDayModelImplFromJson(json);

  @override
  final DateTime date;
  @override
  final double revenue;
  @override
  final int orderCount;

  @override
  String toString() {
    return 'RevenueByDayModel(date: $date, revenue: $revenue, orderCount: $orderCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RevenueByDayModelImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.revenue, revenue) || other.revenue == revenue) &&
            (identical(other.orderCount, orderCount) ||
                other.orderCount == orderCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, date, revenue, orderCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RevenueByDayModelImplCopyWith<_$RevenueByDayModelImpl> get copyWith =>
      __$$RevenueByDayModelImplCopyWithImpl<_$RevenueByDayModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RevenueByDayModelImplToJson(
      this,
    );
  }
}

abstract class _RevenueByDayModel implements RevenueByDayModel {
  const factory _RevenueByDayModel(
      {required final DateTime date,
      required final double revenue,
      required final int orderCount}) = _$RevenueByDayModelImpl;

  factory _RevenueByDayModel.fromJson(Map<String, dynamic> json) =
      _$RevenueByDayModelImpl.fromJson;

  @override
  DateTime get date;
  @override
  double get revenue;
  @override
  int get orderCount;
  @override
  @JsonKey(ignore: true)
  _$$RevenueByDayModelImplCopyWith<_$RevenueByDayModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
