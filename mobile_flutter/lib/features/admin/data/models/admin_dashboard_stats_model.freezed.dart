// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_dashboard_stats_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AdminDashboardStatsModel _$AdminDashboardStatsModelFromJson(
    Map<String, dynamic> json) {
  return _AdminDashboardStatsModel.fromJson(json);
}

/// @nodoc
mixin _$AdminDashboardStatsModel {
  int get totalUsers => throw _privateConstructorUsedError;
  double get totalRevenue => throw _privateConstructorUsedError;
  int get totalOrders => throw _privateConstructorUsedError;
  int get totalProductsSold => throw _privateConstructorUsedError;
  List<StatusCountModel> get ordersByStatus =>
      throw _privateConstructorUsedError;
  List<BestSellingProductModel> get bestSelling =>
      throw _privateConstructorUsedError;
  List<RevenueByDayModel> get revenueByDay =>
      throw _privateConstructorUsedError;
  List<RevenueByMonthModel> get revenueByMonth =>
      throw _privateConstructorUsedError;
  List<RecentOrderModel> get recentOrders => throw _privateConstructorUsedError;
  List<LowStockProductModel> get lowStockProducts =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AdminDashboardStatsModelCopyWith<AdminDashboardStatsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminDashboardStatsModelCopyWith<$Res> {
  factory $AdminDashboardStatsModelCopyWith(AdminDashboardStatsModel value,
          $Res Function(AdminDashboardStatsModel) then) =
      _$AdminDashboardStatsModelCopyWithImpl<$Res, AdminDashboardStatsModel>;
  @useResult
  $Res call(
      {int totalUsers,
      double totalRevenue,
      int totalOrders,
      int totalProductsSold,
      List<StatusCountModel> ordersByStatus,
      List<BestSellingProductModel> bestSelling,
      List<RevenueByDayModel> revenueByDay,
      List<RevenueByMonthModel> revenueByMonth,
      List<RecentOrderModel> recentOrders,
      List<LowStockProductModel> lowStockProducts});
}

/// @nodoc
class _$AdminDashboardStatsModelCopyWithImpl<$Res,
        $Val extends AdminDashboardStatsModel>
    implements $AdminDashboardStatsModelCopyWith<$Res> {
  _$AdminDashboardStatsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalUsers = null,
    Object? totalRevenue = null,
    Object? totalOrders = null,
    Object? totalProductsSold = null,
    Object? ordersByStatus = null,
    Object? bestSelling = null,
    Object? revenueByDay = null,
    Object? revenueByMonth = null,
    Object? recentOrders = null,
    Object? lowStockProducts = null,
  }) {
    return _then(_value.copyWith(
      totalUsers: null == totalUsers
          ? _value.totalUsers
          : totalUsers // ignore: cast_nullable_to_non_nullable
              as int,
      totalRevenue: null == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      totalProductsSold: null == totalProductsSold
          ? _value.totalProductsSold
          : totalProductsSold // ignore: cast_nullable_to_non_nullable
              as int,
      ordersByStatus: null == ordersByStatus
          ? _value.ordersByStatus
          : ordersByStatus // ignore: cast_nullable_to_non_nullable
              as List<StatusCountModel>,
      bestSelling: null == bestSelling
          ? _value.bestSelling
          : bestSelling // ignore: cast_nullable_to_non_nullable
              as List<BestSellingProductModel>,
      revenueByDay: null == revenueByDay
          ? _value.revenueByDay
          : revenueByDay // ignore: cast_nullable_to_non_nullable
              as List<RevenueByDayModel>,
      revenueByMonth: null == revenueByMonth
          ? _value.revenueByMonth
          : revenueByMonth // ignore: cast_nullable_to_non_nullable
              as List<RevenueByMonthModel>,
      recentOrders: null == recentOrders
          ? _value.recentOrders
          : recentOrders // ignore: cast_nullable_to_non_nullable
              as List<RecentOrderModel>,
      lowStockProducts: null == lowStockProducts
          ? _value.lowStockProducts
          : lowStockProducts // ignore: cast_nullable_to_non_nullable
              as List<LowStockProductModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdminDashboardStatsModelImplCopyWith<$Res>
    implements $AdminDashboardStatsModelCopyWith<$Res> {
  factory _$$AdminDashboardStatsModelImplCopyWith(
          _$AdminDashboardStatsModelImpl value,
          $Res Function(_$AdminDashboardStatsModelImpl) then) =
      __$$AdminDashboardStatsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalUsers,
      double totalRevenue,
      int totalOrders,
      int totalProductsSold,
      List<StatusCountModel> ordersByStatus,
      List<BestSellingProductModel> bestSelling,
      List<RevenueByDayModel> revenueByDay,
      List<RevenueByMonthModel> revenueByMonth,
      List<RecentOrderModel> recentOrders,
      List<LowStockProductModel> lowStockProducts});
}

/// @nodoc
class __$$AdminDashboardStatsModelImplCopyWithImpl<$Res>
    extends _$AdminDashboardStatsModelCopyWithImpl<$Res,
        _$AdminDashboardStatsModelImpl>
    implements _$$AdminDashboardStatsModelImplCopyWith<$Res> {
  __$$AdminDashboardStatsModelImplCopyWithImpl(
      _$AdminDashboardStatsModelImpl _value,
      $Res Function(_$AdminDashboardStatsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalUsers = null,
    Object? totalRevenue = null,
    Object? totalOrders = null,
    Object? totalProductsSold = null,
    Object? ordersByStatus = null,
    Object? bestSelling = null,
    Object? revenueByDay = null,
    Object? revenueByMonth = null,
    Object? recentOrders = null,
    Object? lowStockProducts = null,
  }) {
    return _then(_$AdminDashboardStatsModelImpl(
      totalUsers: null == totalUsers
          ? _value.totalUsers
          : totalUsers // ignore: cast_nullable_to_non_nullable
              as int,
      totalRevenue: null == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      totalProductsSold: null == totalProductsSold
          ? _value.totalProductsSold
          : totalProductsSold // ignore: cast_nullable_to_non_nullable
              as int,
      ordersByStatus: null == ordersByStatus
          ? _value._ordersByStatus
          : ordersByStatus // ignore: cast_nullable_to_non_nullable
              as List<StatusCountModel>,
      bestSelling: null == bestSelling
          ? _value._bestSelling
          : bestSelling // ignore: cast_nullable_to_non_nullable
              as List<BestSellingProductModel>,
      revenueByDay: null == revenueByDay
          ? _value._revenueByDay
          : revenueByDay // ignore: cast_nullable_to_non_nullable
              as List<RevenueByDayModel>,
      revenueByMonth: null == revenueByMonth
          ? _value._revenueByMonth
          : revenueByMonth // ignore: cast_nullable_to_non_nullable
              as List<RevenueByMonthModel>,
      recentOrders: null == recentOrders
          ? _value._recentOrders
          : recentOrders // ignore: cast_nullable_to_non_nullable
              as List<RecentOrderModel>,
      lowStockProducts: null == lowStockProducts
          ? _value._lowStockProducts
          : lowStockProducts // ignore: cast_nullable_to_non_nullable
              as List<LowStockProductModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdminDashboardStatsModelImpl implements _AdminDashboardStatsModel {
  const _$AdminDashboardStatsModelImpl(
      {required this.totalUsers,
      required this.totalRevenue,
      required this.totalOrders,
      required this.totalProductsSold,
      required final List<StatusCountModel> ordersByStatus,
      required final List<BestSellingProductModel> bestSelling,
      required final List<RevenueByDayModel> revenueByDay,
      required final List<RevenueByMonthModel> revenueByMonth,
      required final List<RecentOrderModel> recentOrders,
      required final List<LowStockProductModel> lowStockProducts})
      : _ordersByStatus = ordersByStatus,
        _bestSelling = bestSelling,
        _revenueByDay = revenueByDay,
        _revenueByMonth = revenueByMonth,
        _recentOrders = recentOrders,
        _lowStockProducts = lowStockProducts;

  factory _$AdminDashboardStatsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdminDashboardStatsModelImplFromJson(json);

  @override
  final int totalUsers;
  @override
  final double totalRevenue;
  @override
  final int totalOrders;
  @override
  final int totalProductsSold;
  final List<StatusCountModel> _ordersByStatus;
  @override
  List<StatusCountModel> get ordersByStatus {
    if (_ordersByStatus is EqualUnmodifiableListView) return _ordersByStatus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ordersByStatus);
  }

  final List<BestSellingProductModel> _bestSelling;
  @override
  List<BestSellingProductModel> get bestSelling {
    if (_bestSelling is EqualUnmodifiableListView) return _bestSelling;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bestSelling);
  }

  final List<RevenueByDayModel> _revenueByDay;
  @override
  List<RevenueByDayModel> get revenueByDay {
    if (_revenueByDay is EqualUnmodifiableListView) return _revenueByDay;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_revenueByDay);
  }

  final List<RevenueByMonthModel> _revenueByMonth;
  @override
  List<RevenueByMonthModel> get revenueByMonth {
    if (_revenueByMonth is EqualUnmodifiableListView) return _revenueByMonth;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_revenueByMonth);
  }

  final List<RecentOrderModel> _recentOrders;
  @override
  List<RecentOrderModel> get recentOrders {
    if (_recentOrders is EqualUnmodifiableListView) return _recentOrders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentOrders);
  }

  final List<LowStockProductModel> _lowStockProducts;
  @override
  List<LowStockProductModel> get lowStockProducts {
    if (_lowStockProducts is EqualUnmodifiableListView)
      return _lowStockProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lowStockProducts);
  }

  @override
  String toString() {
    return 'AdminDashboardStatsModel(totalUsers: $totalUsers, totalRevenue: $totalRevenue, totalOrders: $totalOrders, totalProductsSold: $totalProductsSold, ordersByStatus: $ordersByStatus, bestSelling: $bestSelling, revenueByDay: $revenueByDay, revenueByMonth: $revenueByMonth, recentOrders: $recentOrders, lowStockProducts: $lowStockProducts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminDashboardStatsModelImpl &&
            (identical(other.totalUsers, totalUsers) ||
                other.totalUsers == totalUsers) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(other.totalOrders, totalOrders) ||
                other.totalOrders == totalOrders) &&
            (identical(other.totalProductsSold, totalProductsSold) ||
                other.totalProductsSold == totalProductsSold) &&
            const DeepCollectionEquality()
                .equals(other._ordersByStatus, _ordersByStatus) &&
            const DeepCollectionEquality()
                .equals(other._bestSelling, _bestSelling) &&
            const DeepCollectionEquality()
                .equals(other._revenueByDay, _revenueByDay) &&
            const DeepCollectionEquality()
                .equals(other._revenueByMonth, _revenueByMonth) &&
            const DeepCollectionEquality()
                .equals(other._recentOrders, _recentOrders) &&
            const DeepCollectionEquality()
                .equals(other._lowStockProducts, _lowStockProducts));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalUsers,
      totalRevenue,
      totalOrders,
      totalProductsSold,
      const DeepCollectionEquality().hash(_ordersByStatus),
      const DeepCollectionEquality().hash(_bestSelling),
      const DeepCollectionEquality().hash(_revenueByDay),
      const DeepCollectionEquality().hash(_revenueByMonth),
      const DeepCollectionEquality().hash(_recentOrders),
      const DeepCollectionEquality().hash(_lowStockProducts));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminDashboardStatsModelImplCopyWith<_$AdminDashboardStatsModelImpl>
      get copyWith => __$$AdminDashboardStatsModelImplCopyWithImpl<
          _$AdminDashboardStatsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdminDashboardStatsModelImplToJson(
      this,
    );
  }
}

abstract class _AdminDashboardStatsModel implements AdminDashboardStatsModel {
  const factory _AdminDashboardStatsModel(
          {required final int totalUsers,
          required final double totalRevenue,
          required final int totalOrders,
          required final int totalProductsSold,
          required final List<StatusCountModel> ordersByStatus,
          required final List<BestSellingProductModel> bestSelling,
          required final List<RevenueByDayModel> revenueByDay,
          required final List<RevenueByMonthModel> revenueByMonth,
          required final List<RecentOrderModel> recentOrders,
          required final List<LowStockProductModel> lowStockProducts}) =
      _$AdminDashboardStatsModelImpl;

  factory _AdminDashboardStatsModel.fromJson(Map<String, dynamic> json) =
      _$AdminDashboardStatsModelImpl.fromJson;

  @override
  int get totalUsers;
  @override
  double get totalRevenue;
  @override
  int get totalOrders;
  @override
  int get totalProductsSold;
  @override
  List<StatusCountModel> get ordersByStatus;
  @override
  List<BestSellingProductModel> get bestSelling;
  @override
  List<RevenueByDayModel> get revenueByDay;
  @override
  List<RevenueByMonthModel> get revenueByMonth;
  @override
  List<RecentOrderModel> get recentOrders;
  @override
  List<LowStockProductModel> get lowStockProducts;
  @override
  @JsonKey(ignore: true)
  _$$AdminDashboardStatsModelImplCopyWith<_$AdminDashboardStatsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

StatusCountModel _$StatusCountModelFromJson(Map<String, dynamic> json) {
  return _StatusCountModel.fromJson(json);
}

/// @nodoc
mixin _$StatusCountModel {
  String get status => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StatusCountModelCopyWith<StatusCountModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatusCountModelCopyWith<$Res> {
  factory $StatusCountModelCopyWith(
          StatusCountModel value, $Res Function(StatusCountModel) then) =
      _$StatusCountModelCopyWithImpl<$Res, StatusCountModel>;
  @useResult
  $Res call({String status, int total});
}

/// @nodoc
class _$StatusCountModelCopyWithImpl<$Res, $Val extends StatusCountModel>
    implements $StatusCountModelCopyWith<$Res> {
  _$StatusCountModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? total = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StatusCountModelImplCopyWith<$Res>
    implements $StatusCountModelCopyWith<$Res> {
  factory _$$StatusCountModelImplCopyWith(_$StatusCountModelImpl value,
          $Res Function(_$StatusCountModelImpl) then) =
      __$$StatusCountModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String status, int total});
}

/// @nodoc
class __$$StatusCountModelImplCopyWithImpl<$Res>
    extends _$StatusCountModelCopyWithImpl<$Res, _$StatusCountModelImpl>
    implements _$$StatusCountModelImplCopyWith<$Res> {
  __$$StatusCountModelImplCopyWithImpl(_$StatusCountModelImpl _value,
      $Res Function(_$StatusCountModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? total = null,
  }) {
    return _then(_$StatusCountModelImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StatusCountModelImpl implements _StatusCountModel {
  const _$StatusCountModelImpl({required this.status, required this.total});

  factory _$StatusCountModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StatusCountModelImplFromJson(json);

  @override
  final String status;
  @override
  final int total;

  @override
  String toString() {
    return 'StatusCountModel(status: $status, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatusCountModelImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, status, total);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StatusCountModelImplCopyWith<_$StatusCountModelImpl> get copyWith =>
      __$$StatusCountModelImplCopyWithImpl<_$StatusCountModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StatusCountModelImplToJson(
      this,
    );
  }
}

abstract class _StatusCountModel implements StatusCountModel {
  const factory _StatusCountModel(
      {required final String status,
      required final int total}) = _$StatusCountModelImpl;

  factory _StatusCountModel.fromJson(Map<String, dynamic> json) =
      _$StatusCountModelImpl.fromJson;

  @override
  String get status;
  @override
  int get total;
  @override
  @JsonKey(ignore: true)
  _$$StatusCountModelImplCopyWith<_$StatusCountModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BestSellingProductModel _$BestSellingProductModelFromJson(
    Map<String, dynamic> json) {
  return _BestSellingProductModel.fromJson(json);
}

/// @nodoc
mixin _$BestSellingProductModel {
  int get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  int get totalSold => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BestSellingProductModelCopyWith<BestSellingProductModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BestSellingProductModelCopyWith<$Res> {
  factory $BestSellingProductModelCopyWith(BestSellingProductModel value,
          $Res Function(BestSellingProductModel) then) =
      _$BestSellingProductModelCopyWithImpl<$Res, BestSellingProductModel>;
  @useResult
  $Res call({int productId, String productName, int totalSold});
}

/// @nodoc
class _$BestSellingProductModelCopyWithImpl<$Res,
        $Val extends BestSellingProductModel>
    implements $BestSellingProductModelCopyWith<$Res> {
  _$BestSellingProductModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? totalSold = null,
  }) {
    return _then(_value.copyWith(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      totalSold: null == totalSold
          ? _value.totalSold
          : totalSold // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BestSellingProductModelImplCopyWith<$Res>
    implements $BestSellingProductModelCopyWith<$Res> {
  factory _$$BestSellingProductModelImplCopyWith(
          _$BestSellingProductModelImpl value,
          $Res Function(_$BestSellingProductModelImpl) then) =
      __$$BestSellingProductModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int productId, String productName, int totalSold});
}

/// @nodoc
class __$$BestSellingProductModelImplCopyWithImpl<$Res>
    extends _$BestSellingProductModelCopyWithImpl<$Res,
        _$BestSellingProductModelImpl>
    implements _$$BestSellingProductModelImplCopyWith<$Res> {
  __$$BestSellingProductModelImplCopyWithImpl(
      _$BestSellingProductModelImpl _value,
      $Res Function(_$BestSellingProductModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? totalSold = null,
  }) {
    return _then(_$BestSellingProductModelImpl(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      totalSold: null == totalSold
          ? _value.totalSold
          : totalSold // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BestSellingProductModelImpl implements _BestSellingProductModel {
  const _$BestSellingProductModelImpl(
      {required this.productId,
      required this.productName,
      required this.totalSold});

  factory _$BestSellingProductModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BestSellingProductModelImplFromJson(json);

  @override
  final int productId;
  @override
  final String productName;
  @override
  final int totalSold;

  @override
  String toString() {
    return 'BestSellingProductModel(productId: $productId, productName: $productName, totalSold: $totalSold)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BestSellingProductModelImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.totalSold, totalSold) ||
                other.totalSold == totalSold));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, productId, productName, totalSold);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BestSellingProductModelImplCopyWith<_$BestSellingProductModelImpl>
      get copyWith => __$$BestSellingProductModelImplCopyWithImpl<
          _$BestSellingProductModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BestSellingProductModelImplToJson(
      this,
    );
  }
}

abstract class _BestSellingProductModel implements BestSellingProductModel {
  const factory _BestSellingProductModel(
      {required final int productId,
      required final String productName,
      required final int totalSold}) = _$BestSellingProductModelImpl;

  factory _BestSellingProductModel.fromJson(Map<String, dynamic> json) =
      _$BestSellingProductModelImpl.fromJson;

  @override
  int get productId;
  @override
  String get productName;
  @override
  int get totalSold;
  @override
  @JsonKey(ignore: true)
  _$$BestSellingProductModelImplCopyWith<_$BestSellingProductModelImpl>
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

RevenueByMonthModel _$RevenueByMonthModelFromJson(Map<String, dynamic> json) {
  return _RevenueByMonthModel.fromJson(json);
}

/// @nodoc
mixin _$RevenueByMonthModel {
  int get year => throw _privateConstructorUsedError;
  int get month => throw _privateConstructorUsedError;
  double get revenue => throw _privateConstructorUsedError;
  int get orderCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RevenueByMonthModelCopyWith<RevenueByMonthModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RevenueByMonthModelCopyWith<$Res> {
  factory $RevenueByMonthModelCopyWith(
          RevenueByMonthModel value, $Res Function(RevenueByMonthModel) then) =
      _$RevenueByMonthModelCopyWithImpl<$Res, RevenueByMonthModel>;
  @useResult
  $Res call({int year, int month, double revenue, int orderCount});
}

/// @nodoc
class _$RevenueByMonthModelCopyWithImpl<$Res, $Val extends RevenueByMonthModel>
    implements $RevenueByMonthModelCopyWith<$Res> {
  _$RevenueByMonthModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? month = null,
    Object? revenue = null,
    Object? orderCount = null,
  }) {
    return _then(_value.copyWith(
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
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
abstract class _$$RevenueByMonthModelImplCopyWith<$Res>
    implements $RevenueByMonthModelCopyWith<$Res> {
  factory _$$RevenueByMonthModelImplCopyWith(_$RevenueByMonthModelImpl value,
          $Res Function(_$RevenueByMonthModelImpl) then) =
      __$$RevenueByMonthModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int year, int month, double revenue, int orderCount});
}

/// @nodoc
class __$$RevenueByMonthModelImplCopyWithImpl<$Res>
    extends _$RevenueByMonthModelCopyWithImpl<$Res, _$RevenueByMonthModelImpl>
    implements _$$RevenueByMonthModelImplCopyWith<$Res> {
  __$$RevenueByMonthModelImplCopyWithImpl(_$RevenueByMonthModelImpl _value,
      $Res Function(_$RevenueByMonthModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? month = null,
    Object? revenue = null,
    Object? orderCount = null,
  }) {
    return _then(_$RevenueByMonthModelImpl(
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
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
class _$RevenueByMonthModelImpl implements _RevenueByMonthModel {
  const _$RevenueByMonthModelImpl(
      {required this.year,
      required this.month,
      required this.revenue,
      required this.orderCount});

  factory _$RevenueByMonthModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RevenueByMonthModelImplFromJson(json);

  @override
  final int year;
  @override
  final int month;
  @override
  final double revenue;
  @override
  final int orderCount;

  @override
  String toString() {
    return 'RevenueByMonthModel(year: $year, month: $month, revenue: $revenue, orderCount: $orderCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RevenueByMonthModelImpl &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.revenue, revenue) || other.revenue == revenue) &&
            (identical(other.orderCount, orderCount) ||
                other.orderCount == orderCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, year, month, revenue, orderCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RevenueByMonthModelImplCopyWith<_$RevenueByMonthModelImpl> get copyWith =>
      __$$RevenueByMonthModelImplCopyWithImpl<_$RevenueByMonthModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RevenueByMonthModelImplToJson(
      this,
    );
  }
}

abstract class _RevenueByMonthModel implements RevenueByMonthModel {
  const factory _RevenueByMonthModel(
      {required final int year,
      required final int month,
      required final double revenue,
      required final int orderCount}) = _$RevenueByMonthModelImpl;

  factory _RevenueByMonthModel.fromJson(Map<String, dynamic> json) =
      _$RevenueByMonthModelImpl.fromJson;

  @override
  int get year;
  @override
  int get month;
  @override
  double get revenue;
  @override
  int get orderCount;
  @override
  @JsonKey(ignore: true)
  _$$RevenueByMonthModelImplCopyWith<_$RevenueByMonthModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecentOrderModel _$RecentOrderModelFromJson(Map<String, dynamic> json) {
  return _RecentOrderModel.fromJson(json);
}

/// @nodoc
mixin _$RecentOrderModel {
  int get orderId => throw _privateConstructorUsedError;
  String get customerName => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RecentOrderModelCopyWith<RecentOrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentOrderModelCopyWith<$Res> {
  factory $RecentOrderModelCopyWith(
          RecentOrderModel value, $Res Function(RecentOrderModel) then) =
      _$RecentOrderModelCopyWithImpl<$Res, RecentOrderModel>;
  @useResult
  $Res call(
      {int orderId,
      String customerName,
      double totalAmount,
      String status,
      DateTime createdAt});
}

/// @nodoc
class _$RecentOrderModelCopyWithImpl<$Res, $Val extends RecentOrderModel>
    implements $RecentOrderModelCopyWith<$Res> {
  _$RecentOrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? customerName = null,
    Object? totalAmount = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecentOrderModelImplCopyWith<$Res>
    implements $RecentOrderModelCopyWith<$Res> {
  factory _$$RecentOrderModelImplCopyWith(_$RecentOrderModelImpl value,
          $Res Function(_$RecentOrderModelImpl) then) =
      __$$RecentOrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int orderId,
      String customerName,
      double totalAmount,
      String status,
      DateTime createdAt});
}

/// @nodoc
class __$$RecentOrderModelImplCopyWithImpl<$Res>
    extends _$RecentOrderModelCopyWithImpl<$Res, _$RecentOrderModelImpl>
    implements _$$RecentOrderModelImplCopyWith<$Res> {
  __$$RecentOrderModelImplCopyWithImpl(_$RecentOrderModelImpl _value,
      $Res Function(_$RecentOrderModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? customerName = null,
    Object? totalAmount = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(_$RecentOrderModelImpl(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecentOrderModelImpl implements _RecentOrderModel {
  const _$RecentOrderModelImpl(
      {required this.orderId,
      required this.customerName,
      required this.totalAmount,
      required this.status,
      required this.createdAt});

  factory _$RecentOrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecentOrderModelImplFromJson(json);

  @override
  final int orderId;
  @override
  final String customerName;
  @override
  final double totalAmount;
  @override
  final String status;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'RecentOrderModel(orderId: $orderId, customerName: $customerName, totalAmount: $totalAmount, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecentOrderModelImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, orderId, customerName, totalAmount, status, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecentOrderModelImplCopyWith<_$RecentOrderModelImpl> get copyWith =>
      __$$RecentOrderModelImplCopyWithImpl<_$RecentOrderModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecentOrderModelImplToJson(
      this,
    );
  }
}

abstract class _RecentOrderModel implements RecentOrderModel {
  const factory _RecentOrderModel(
      {required final int orderId,
      required final String customerName,
      required final double totalAmount,
      required final String status,
      required final DateTime createdAt}) = _$RecentOrderModelImpl;

  factory _RecentOrderModel.fromJson(Map<String, dynamic> json) =
      _$RecentOrderModelImpl.fromJson;

  @override
  int get orderId;
  @override
  String get customerName;
  @override
  double get totalAmount;
  @override
  String get status;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$RecentOrderModelImplCopyWith<_$RecentOrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LowStockProductModel _$LowStockProductModelFromJson(Map<String, dynamic> json) {
  return _LowStockProductModel.fromJson(json);
}

/// @nodoc
mixin _$LowStockProductModel {
  int get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  int get stockQuantity => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LowStockProductModelCopyWith<LowStockProductModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LowStockProductModelCopyWith<$Res> {
  factory $LowStockProductModelCopyWith(LowStockProductModel value,
          $Res Function(LowStockProductModel) then) =
      _$LowStockProductModelCopyWithImpl<$Res, LowStockProductModel>;
  @useResult
  $Res call({int productId, String productName, int stockQuantity});
}

/// @nodoc
class _$LowStockProductModelCopyWithImpl<$Res,
        $Val extends LowStockProductModel>
    implements $LowStockProductModelCopyWith<$Res> {
  _$LowStockProductModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? stockQuantity = null,
  }) {
    return _then(_value.copyWith(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      stockQuantity: null == stockQuantity
          ? _value.stockQuantity
          : stockQuantity // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LowStockProductModelImplCopyWith<$Res>
    implements $LowStockProductModelCopyWith<$Res> {
  factory _$$LowStockProductModelImplCopyWith(_$LowStockProductModelImpl value,
          $Res Function(_$LowStockProductModelImpl) then) =
      __$$LowStockProductModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int productId, String productName, int stockQuantity});
}

/// @nodoc
class __$$LowStockProductModelImplCopyWithImpl<$Res>
    extends _$LowStockProductModelCopyWithImpl<$Res, _$LowStockProductModelImpl>
    implements _$$LowStockProductModelImplCopyWith<$Res> {
  __$$LowStockProductModelImplCopyWithImpl(_$LowStockProductModelImpl _value,
      $Res Function(_$LowStockProductModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? stockQuantity = null,
  }) {
    return _then(_$LowStockProductModelImpl(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      stockQuantity: null == stockQuantity
          ? _value.stockQuantity
          : stockQuantity // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LowStockProductModelImpl implements _LowStockProductModel {
  const _$LowStockProductModelImpl(
      {required this.productId,
      required this.productName,
      required this.stockQuantity});

  factory _$LowStockProductModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LowStockProductModelImplFromJson(json);

  @override
  final int productId;
  @override
  final String productName;
  @override
  final int stockQuantity;

  @override
  String toString() {
    return 'LowStockProductModel(productId: $productId, productName: $productName, stockQuantity: $stockQuantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LowStockProductModelImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.stockQuantity, stockQuantity) ||
                other.stockQuantity == stockQuantity));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, productId, productName, stockQuantity);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LowStockProductModelImplCopyWith<_$LowStockProductModelImpl>
      get copyWith =>
          __$$LowStockProductModelImplCopyWithImpl<_$LowStockProductModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LowStockProductModelImplToJson(
      this,
    );
  }
}

abstract class _LowStockProductModel implements LowStockProductModel {
  const factory _LowStockProductModel(
      {required final int productId,
      required final String productName,
      required final int stockQuantity}) = _$LowStockProductModelImpl;

  factory _LowStockProductModel.fromJson(Map<String, dynamic> json) =
      _$LowStockProductModelImpl.fromJson;

  @override
  int get productId;
  @override
  String get productName;
  @override
  int get stockQuantity;
  @override
  @JsonKey(ignore: true)
  _$$LowStockProductModelImplCopyWith<_$LowStockProductModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
