// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_discount_stats_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AdminDiscountStatsModel _$AdminDiscountStatsModelFromJson(
    Map<String, dynamic> json) {
  return _AdminDiscountStatsModel.fromJson(json);
}

/// @nodoc
mixin _$AdminDiscountStatsModel {
  int get totalDiscounts => throw _privateConstructorUsedError;
  int get activeDiscounts => throw _privateConstructorUsedError;
  int get expiredDiscounts => throw _privateConstructorUsedError;
  List<DiscountTypeDistributionModel> get typeDistribution =>
      throw _privateConstructorUsedError;
  List<TopDiscountModel> get topDiscounts => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AdminDiscountStatsModelCopyWith<AdminDiscountStatsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminDiscountStatsModelCopyWith<$Res> {
  factory $AdminDiscountStatsModelCopyWith(AdminDiscountStatsModel value,
          $Res Function(AdminDiscountStatsModel) then) =
      _$AdminDiscountStatsModelCopyWithImpl<$Res, AdminDiscountStatsModel>;
  @useResult
  $Res call(
      {int totalDiscounts,
      int activeDiscounts,
      int expiredDiscounts,
      List<DiscountTypeDistributionModel> typeDistribution,
      List<TopDiscountModel> topDiscounts});
}

/// @nodoc
class _$AdminDiscountStatsModelCopyWithImpl<$Res,
        $Val extends AdminDiscountStatsModel>
    implements $AdminDiscountStatsModelCopyWith<$Res> {
  _$AdminDiscountStatsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalDiscounts = null,
    Object? activeDiscounts = null,
    Object? expiredDiscounts = null,
    Object? typeDistribution = null,
    Object? topDiscounts = null,
  }) {
    return _then(_value.copyWith(
      totalDiscounts: null == totalDiscounts
          ? _value.totalDiscounts
          : totalDiscounts // ignore: cast_nullable_to_non_nullable
              as int,
      activeDiscounts: null == activeDiscounts
          ? _value.activeDiscounts
          : activeDiscounts // ignore: cast_nullable_to_non_nullable
              as int,
      expiredDiscounts: null == expiredDiscounts
          ? _value.expiredDiscounts
          : expiredDiscounts // ignore: cast_nullable_to_non_nullable
              as int,
      typeDistribution: null == typeDistribution
          ? _value.typeDistribution
          : typeDistribution // ignore: cast_nullable_to_non_nullable
              as List<DiscountTypeDistributionModel>,
      topDiscounts: null == topDiscounts
          ? _value.topDiscounts
          : topDiscounts // ignore: cast_nullable_to_non_nullable
              as List<TopDiscountModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdminDiscountStatsModelImplCopyWith<$Res>
    implements $AdminDiscountStatsModelCopyWith<$Res> {
  factory _$$AdminDiscountStatsModelImplCopyWith(
          _$AdminDiscountStatsModelImpl value,
          $Res Function(_$AdminDiscountStatsModelImpl) then) =
      __$$AdminDiscountStatsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalDiscounts,
      int activeDiscounts,
      int expiredDiscounts,
      List<DiscountTypeDistributionModel> typeDistribution,
      List<TopDiscountModel> topDiscounts});
}

/// @nodoc
class __$$AdminDiscountStatsModelImplCopyWithImpl<$Res>
    extends _$AdminDiscountStatsModelCopyWithImpl<$Res,
        _$AdminDiscountStatsModelImpl>
    implements _$$AdminDiscountStatsModelImplCopyWith<$Res> {
  __$$AdminDiscountStatsModelImplCopyWithImpl(
      _$AdminDiscountStatsModelImpl _value,
      $Res Function(_$AdminDiscountStatsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalDiscounts = null,
    Object? activeDiscounts = null,
    Object? expiredDiscounts = null,
    Object? typeDistribution = null,
    Object? topDiscounts = null,
  }) {
    return _then(_$AdminDiscountStatsModelImpl(
      totalDiscounts: null == totalDiscounts
          ? _value.totalDiscounts
          : totalDiscounts // ignore: cast_nullable_to_non_nullable
              as int,
      activeDiscounts: null == activeDiscounts
          ? _value.activeDiscounts
          : activeDiscounts // ignore: cast_nullable_to_non_nullable
              as int,
      expiredDiscounts: null == expiredDiscounts
          ? _value.expiredDiscounts
          : expiredDiscounts // ignore: cast_nullable_to_non_nullable
              as int,
      typeDistribution: null == typeDistribution
          ? _value._typeDistribution
          : typeDistribution // ignore: cast_nullable_to_non_nullable
              as List<DiscountTypeDistributionModel>,
      topDiscounts: null == topDiscounts
          ? _value._topDiscounts
          : topDiscounts // ignore: cast_nullable_to_non_nullable
              as List<TopDiscountModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdminDiscountStatsModelImpl implements _AdminDiscountStatsModel {
  const _$AdminDiscountStatsModelImpl(
      {required this.totalDiscounts,
      required this.activeDiscounts,
      required this.expiredDiscounts,
      required final List<DiscountTypeDistributionModel> typeDistribution,
      required final List<TopDiscountModel> topDiscounts})
      : _typeDistribution = typeDistribution,
        _topDiscounts = topDiscounts;

  factory _$AdminDiscountStatsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdminDiscountStatsModelImplFromJson(json);

  @override
  final int totalDiscounts;
  @override
  final int activeDiscounts;
  @override
  final int expiredDiscounts;
  final List<DiscountTypeDistributionModel> _typeDistribution;
  @override
  List<DiscountTypeDistributionModel> get typeDistribution {
    if (_typeDistribution is EqualUnmodifiableListView)
      return _typeDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_typeDistribution);
  }

  final List<TopDiscountModel> _topDiscounts;
  @override
  List<TopDiscountModel> get topDiscounts {
    if (_topDiscounts is EqualUnmodifiableListView) return _topDiscounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topDiscounts);
  }

  @override
  String toString() {
    return 'AdminDiscountStatsModel(totalDiscounts: $totalDiscounts, activeDiscounts: $activeDiscounts, expiredDiscounts: $expiredDiscounts, typeDistribution: $typeDistribution, topDiscounts: $topDiscounts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminDiscountStatsModelImpl &&
            (identical(other.totalDiscounts, totalDiscounts) ||
                other.totalDiscounts == totalDiscounts) &&
            (identical(other.activeDiscounts, activeDiscounts) ||
                other.activeDiscounts == activeDiscounts) &&
            (identical(other.expiredDiscounts, expiredDiscounts) ||
                other.expiredDiscounts == expiredDiscounts) &&
            const DeepCollectionEquality()
                .equals(other._typeDistribution, _typeDistribution) &&
            const DeepCollectionEquality()
                .equals(other._topDiscounts, _topDiscounts));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalDiscounts,
      activeDiscounts,
      expiredDiscounts,
      const DeepCollectionEquality().hash(_typeDistribution),
      const DeepCollectionEquality().hash(_topDiscounts));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminDiscountStatsModelImplCopyWith<_$AdminDiscountStatsModelImpl>
      get copyWith => __$$AdminDiscountStatsModelImplCopyWithImpl<
          _$AdminDiscountStatsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdminDiscountStatsModelImplToJson(
      this,
    );
  }
}

abstract class _AdminDiscountStatsModel implements AdminDiscountStatsModel {
  const factory _AdminDiscountStatsModel(
          {required final int totalDiscounts,
          required final int activeDiscounts,
          required final int expiredDiscounts,
          required final List<DiscountTypeDistributionModel> typeDistribution,
          required final List<TopDiscountModel> topDiscounts}) =
      _$AdminDiscountStatsModelImpl;

  factory _AdminDiscountStatsModel.fromJson(Map<String, dynamic> json) =
      _$AdminDiscountStatsModelImpl.fromJson;

  @override
  int get totalDiscounts;
  @override
  int get activeDiscounts;
  @override
  int get expiredDiscounts;
  @override
  List<DiscountTypeDistributionModel> get typeDistribution;
  @override
  List<TopDiscountModel> get topDiscounts;
  @override
  @JsonKey(ignore: true)
  _$$AdminDiscountStatsModelImplCopyWith<_$AdminDiscountStatsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

DiscountTypeDistributionModel _$DiscountTypeDistributionModelFromJson(
    Map<String, dynamic> json) {
  return _DiscountTypeDistributionModel.fromJson(json);
}

/// @nodoc
mixin _$DiscountTypeDistributionModel {
  String get type => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DiscountTypeDistributionModelCopyWith<DiscountTypeDistributionModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiscountTypeDistributionModelCopyWith<$Res> {
  factory $DiscountTypeDistributionModelCopyWith(
          DiscountTypeDistributionModel value,
          $Res Function(DiscountTypeDistributionModel) then) =
      _$DiscountTypeDistributionModelCopyWithImpl<$Res,
          DiscountTypeDistributionModel>;
  @useResult
  $Res call({String type, int total, double percentage});
}

/// @nodoc
class _$DiscountTypeDistributionModelCopyWithImpl<$Res,
        $Val extends DiscountTypeDistributionModel>
    implements $DiscountTypeDistributionModelCopyWith<$Res> {
  _$DiscountTypeDistributionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? total = null,
    Object? percentage = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
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
abstract class _$$DiscountTypeDistributionModelImplCopyWith<$Res>
    implements $DiscountTypeDistributionModelCopyWith<$Res> {
  factory _$$DiscountTypeDistributionModelImplCopyWith(
          _$DiscountTypeDistributionModelImpl value,
          $Res Function(_$DiscountTypeDistributionModelImpl) then) =
      __$$DiscountTypeDistributionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, int total, double percentage});
}

/// @nodoc
class __$$DiscountTypeDistributionModelImplCopyWithImpl<$Res>
    extends _$DiscountTypeDistributionModelCopyWithImpl<$Res,
        _$DiscountTypeDistributionModelImpl>
    implements _$$DiscountTypeDistributionModelImplCopyWith<$Res> {
  __$$DiscountTypeDistributionModelImplCopyWithImpl(
      _$DiscountTypeDistributionModelImpl _value,
      $Res Function(_$DiscountTypeDistributionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? total = null,
    Object? percentage = null,
  }) {
    return _then(_$DiscountTypeDistributionModelImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
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
class _$DiscountTypeDistributionModelImpl
    implements _DiscountTypeDistributionModel {
  const _$DiscountTypeDistributionModelImpl(
      {required this.type, required this.total, required this.percentage});

  factory _$DiscountTypeDistributionModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$DiscountTypeDistributionModelImplFromJson(json);

  @override
  final String type;
  @override
  final int total;
  @override
  final double percentage;

  @override
  String toString() {
    return 'DiscountTypeDistributionModel(type: $type, total: $total, percentage: $percentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiscountTypeDistributionModelImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, total, percentage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DiscountTypeDistributionModelImplCopyWith<
          _$DiscountTypeDistributionModelImpl>
      get copyWith => __$$DiscountTypeDistributionModelImplCopyWithImpl<
          _$DiscountTypeDistributionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DiscountTypeDistributionModelImplToJson(
      this,
    );
  }
}

abstract class _DiscountTypeDistributionModel
    implements DiscountTypeDistributionModel {
  const factory _DiscountTypeDistributionModel(
      {required final String type,
      required final int total,
      required final double percentage}) = _$DiscountTypeDistributionModelImpl;

  factory _DiscountTypeDistributionModel.fromJson(Map<String, dynamic> json) =
      _$DiscountTypeDistributionModelImpl.fromJson;

  @override
  String get type;
  @override
  int get total;
  @override
  double get percentage;
  @override
  @JsonKey(ignore: true)
  _$$DiscountTypeDistributionModelImplCopyWith<
          _$DiscountTypeDistributionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TopDiscountModel _$TopDiscountModelFromJson(Map<String, dynamic> json) {
  return _TopDiscountModel.fromJson(json);
}

/// @nodoc
mixin _$TopDiscountModel {
  int get discountId => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  int get usageCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TopDiscountModelCopyWith<TopDiscountModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopDiscountModelCopyWith<$Res> {
  factory $TopDiscountModelCopyWith(
          TopDiscountModel value, $Res Function(TopDiscountModel) then) =
      _$TopDiscountModelCopyWithImpl<$Res, TopDiscountModel>;
  @useResult
  $Res call({int discountId, String code, int usageCount});
}

/// @nodoc
class _$TopDiscountModelCopyWithImpl<$Res, $Val extends TopDiscountModel>
    implements $TopDiscountModelCopyWith<$Res> {
  _$TopDiscountModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? discountId = null,
    Object? code = null,
    Object? usageCount = null,
  }) {
    return _then(_value.copyWith(
      discountId: null == discountId
          ? _value.discountId
          : discountId // ignore: cast_nullable_to_non_nullable
              as int,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      usageCount: null == usageCount
          ? _value.usageCount
          : usageCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TopDiscountModelImplCopyWith<$Res>
    implements $TopDiscountModelCopyWith<$Res> {
  factory _$$TopDiscountModelImplCopyWith(_$TopDiscountModelImpl value,
          $Res Function(_$TopDiscountModelImpl) then) =
      __$$TopDiscountModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int discountId, String code, int usageCount});
}

/// @nodoc
class __$$TopDiscountModelImplCopyWithImpl<$Res>
    extends _$TopDiscountModelCopyWithImpl<$Res, _$TopDiscountModelImpl>
    implements _$$TopDiscountModelImplCopyWith<$Res> {
  __$$TopDiscountModelImplCopyWithImpl(_$TopDiscountModelImpl _value,
      $Res Function(_$TopDiscountModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? discountId = null,
    Object? code = null,
    Object? usageCount = null,
  }) {
    return _then(_$TopDiscountModelImpl(
      discountId: null == discountId
          ? _value.discountId
          : discountId // ignore: cast_nullable_to_non_nullable
              as int,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      usageCount: null == usageCount
          ? _value.usageCount
          : usageCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TopDiscountModelImpl implements _TopDiscountModel {
  const _$TopDiscountModelImpl(
      {required this.discountId, required this.code, required this.usageCount});

  factory _$TopDiscountModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopDiscountModelImplFromJson(json);

  @override
  final int discountId;
  @override
  final String code;
  @override
  final int usageCount;

  @override
  String toString() {
    return 'TopDiscountModel(discountId: $discountId, code: $code, usageCount: $usageCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopDiscountModelImpl &&
            (identical(other.discountId, discountId) ||
                other.discountId == discountId) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.usageCount, usageCount) ||
                other.usageCount == usageCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, discountId, code, usageCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TopDiscountModelImplCopyWith<_$TopDiscountModelImpl> get copyWith =>
      __$$TopDiscountModelImplCopyWithImpl<_$TopDiscountModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TopDiscountModelImplToJson(
      this,
    );
  }
}

abstract class _TopDiscountModel implements TopDiscountModel {
  const factory _TopDiscountModel(
      {required final int discountId,
      required final String code,
      required final int usageCount}) = _$TopDiscountModelImpl;

  factory _TopDiscountModel.fromJson(Map<String, dynamic> json) =
      _$TopDiscountModelImpl.fromJson;

  @override
  int get discountId;
  @override
  String get code;
  @override
  int get usageCount;
  @override
  @JsonKey(ignore: true)
  _$$TopDiscountModelImplCopyWith<_$TopDiscountModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
