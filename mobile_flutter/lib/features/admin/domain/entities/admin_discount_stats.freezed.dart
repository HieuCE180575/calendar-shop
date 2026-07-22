// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_discount_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AdminDiscountStats {
  int get totalDiscounts => throw _privateConstructorUsedError;
  int get activeDiscounts => throw _privateConstructorUsedError;
  int get expiredDiscounts => throw _privateConstructorUsedError;
  List<DiscountTypeDistribution> get typeDistribution =>
      throw _privateConstructorUsedError;
  List<TopDiscount> get topDiscounts => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AdminDiscountStatsCopyWith<AdminDiscountStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminDiscountStatsCopyWith<$Res> {
  factory $AdminDiscountStatsCopyWith(
          AdminDiscountStats value, $Res Function(AdminDiscountStats) then) =
      _$AdminDiscountStatsCopyWithImpl<$Res, AdminDiscountStats>;
  @useResult
  $Res call(
      {int totalDiscounts,
      int activeDiscounts,
      int expiredDiscounts,
      List<DiscountTypeDistribution> typeDistribution,
      List<TopDiscount> topDiscounts});
}

/// @nodoc
class _$AdminDiscountStatsCopyWithImpl<$Res, $Val extends AdminDiscountStats>
    implements $AdminDiscountStatsCopyWith<$Res> {
  _$AdminDiscountStatsCopyWithImpl(this._value, this._then);

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
              as List<DiscountTypeDistribution>,
      topDiscounts: null == topDiscounts
          ? _value.topDiscounts
          : topDiscounts // ignore: cast_nullable_to_non_nullable
              as List<TopDiscount>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdminDiscountStatsImplCopyWith<$Res>
    implements $AdminDiscountStatsCopyWith<$Res> {
  factory _$$AdminDiscountStatsImplCopyWith(_$AdminDiscountStatsImpl value,
          $Res Function(_$AdminDiscountStatsImpl) then) =
      __$$AdminDiscountStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalDiscounts,
      int activeDiscounts,
      int expiredDiscounts,
      List<DiscountTypeDistribution> typeDistribution,
      List<TopDiscount> topDiscounts});
}

/// @nodoc
class __$$AdminDiscountStatsImplCopyWithImpl<$Res>
    extends _$AdminDiscountStatsCopyWithImpl<$Res, _$AdminDiscountStatsImpl>
    implements _$$AdminDiscountStatsImplCopyWith<$Res> {
  __$$AdminDiscountStatsImplCopyWithImpl(_$AdminDiscountStatsImpl _value,
      $Res Function(_$AdminDiscountStatsImpl) _then)
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
    return _then(_$AdminDiscountStatsImpl(
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
              as List<DiscountTypeDistribution>,
      topDiscounts: null == topDiscounts
          ? _value._topDiscounts
          : topDiscounts // ignore: cast_nullable_to_non_nullable
              as List<TopDiscount>,
    ));
  }
}

/// @nodoc

class _$AdminDiscountStatsImpl implements _AdminDiscountStats {
  const _$AdminDiscountStatsImpl(
      {this.totalDiscounts = 0,
      this.activeDiscounts = 0,
      this.expiredDiscounts = 0,
      final List<DiscountTypeDistribution> typeDistribution = const [],
      final List<TopDiscount> topDiscounts = const []})
      : _typeDistribution = typeDistribution,
        _topDiscounts = topDiscounts;

  @override
  @JsonKey()
  final int totalDiscounts;
  @override
  @JsonKey()
  final int activeDiscounts;
  @override
  @JsonKey()
  final int expiredDiscounts;
  final List<DiscountTypeDistribution> _typeDistribution;
  @override
  @JsonKey()
  List<DiscountTypeDistribution> get typeDistribution {
    if (_typeDistribution is EqualUnmodifiableListView)
      return _typeDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_typeDistribution);
  }

  final List<TopDiscount> _topDiscounts;
  @override
  @JsonKey()
  List<TopDiscount> get topDiscounts {
    if (_topDiscounts is EqualUnmodifiableListView) return _topDiscounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topDiscounts);
  }

  @override
  String toString() {
    return 'AdminDiscountStats(totalDiscounts: $totalDiscounts, activeDiscounts: $activeDiscounts, expiredDiscounts: $expiredDiscounts, typeDistribution: $typeDistribution, topDiscounts: $topDiscounts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminDiscountStatsImpl &&
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
  _$$AdminDiscountStatsImplCopyWith<_$AdminDiscountStatsImpl> get copyWith =>
      __$$AdminDiscountStatsImplCopyWithImpl<_$AdminDiscountStatsImpl>(
          this, _$identity);
}

abstract class _AdminDiscountStats implements AdminDiscountStats {
  const factory _AdminDiscountStats(
      {final int totalDiscounts,
      final int activeDiscounts,
      final int expiredDiscounts,
      final List<DiscountTypeDistribution> typeDistribution,
      final List<TopDiscount> topDiscounts}) = _$AdminDiscountStatsImpl;

  @override
  int get totalDiscounts;
  @override
  int get activeDiscounts;
  @override
  int get expiredDiscounts;
  @override
  List<DiscountTypeDistribution> get typeDistribution;
  @override
  List<TopDiscount> get topDiscounts;
  @override
  @JsonKey(ignore: true)
  _$$AdminDiscountStatsImplCopyWith<_$AdminDiscountStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DiscountTypeDistribution {
  String get type => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DiscountTypeDistributionCopyWith<DiscountTypeDistribution> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiscountTypeDistributionCopyWith<$Res> {
  factory $DiscountTypeDistributionCopyWith(DiscountTypeDistribution value,
          $Res Function(DiscountTypeDistribution) then) =
      _$DiscountTypeDistributionCopyWithImpl<$Res, DiscountTypeDistribution>;
  @useResult
  $Res call({String type, int total, double percentage});
}

/// @nodoc
class _$DiscountTypeDistributionCopyWithImpl<$Res,
        $Val extends DiscountTypeDistribution>
    implements $DiscountTypeDistributionCopyWith<$Res> {
  _$DiscountTypeDistributionCopyWithImpl(this._value, this._then);

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
abstract class _$$DiscountTypeDistributionImplCopyWith<$Res>
    implements $DiscountTypeDistributionCopyWith<$Res> {
  factory _$$DiscountTypeDistributionImplCopyWith(
          _$DiscountTypeDistributionImpl value,
          $Res Function(_$DiscountTypeDistributionImpl) then) =
      __$$DiscountTypeDistributionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, int total, double percentage});
}

/// @nodoc
class __$$DiscountTypeDistributionImplCopyWithImpl<$Res>
    extends _$DiscountTypeDistributionCopyWithImpl<$Res,
        _$DiscountTypeDistributionImpl>
    implements _$$DiscountTypeDistributionImplCopyWith<$Res> {
  __$$DiscountTypeDistributionImplCopyWithImpl(
      _$DiscountTypeDistributionImpl _value,
      $Res Function(_$DiscountTypeDistributionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? total = null,
    Object? percentage = null,
  }) {
    return _then(_$DiscountTypeDistributionImpl(
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

class _$DiscountTypeDistributionImpl implements _DiscountTypeDistribution {
  const _$DiscountTypeDistributionImpl(
      {this.type = '', this.total = 0, this.percentage = 0.0});

  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey()
  final int total;
  @override
  @JsonKey()
  final double percentage;

  @override
  String toString() {
    return 'DiscountTypeDistribution(type: $type, total: $total, percentage: $percentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiscountTypeDistributionImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type, total, percentage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DiscountTypeDistributionImplCopyWith<_$DiscountTypeDistributionImpl>
      get copyWith => __$$DiscountTypeDistributionImplCopyWithImpl<
          _$DiscountTypeDistributionImpl>(this, _$identity);
}

abstract class _DiscountTypeDistribution implements DiscountTypeDistribution {
  const factory _DiscountTypeDistribution(
      {final String type,
      final int total,
      final double percentage}) = _$DiscountTypeDistributionImpl;

  @override
  String get type;
  @override
  int get total;
  @override
  double get percentage;
  @override
  @JsonKey(ignore: true)
  _$$DiscountTypeDistributionImplCopyWith<_$DiscountTypeDistributionImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TopDiscount {
  int get discountId => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  int get usageCount => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TopDiscountCopyWith<TopDiscount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopDiscountCopyWith<$Res> {
  factory $TopDiscountCopyWith(
          TopDiscount value, $Res Function(TopDiscount) then) =
      _$TopDiscountCopyWithImpl<$Res, TopDiscount>;
  @useResult
  $Res call({int discountId, String code, int usageCount});
}

/// @nodoc
class _$TopDiscountCopyWithImpl<$Res, $Val extends TopDiscount>
    implements $TopDiscountCopyWith<$Res> {
  _$TopDiscountCopyWithImpl(this._value, this._then);

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
abstract class _$$TopDiscountImplCopyWith<$Res>
    implements $TopDiscountCopyWith<$Res> {
  factory _$$TopDiscountImplCopyWith(
          _$TopDiscountImpl value, $Res Function(_$TopDiscountImpl) then) =
      __$$TopDiscountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int discountId, String code, int usageCount});
}

/// @nodoc
class __$$TopDiscountImplCopyWithImpl<$Res>
    extends _$TopDiscountCopyWithImpl<$Res, _$TopDiscountImpl>
    implements _$$TopDiscountImplCopyWith<$Res> {
  __$$TopDiscountImplCopyWithImpl(
      _$TopDiscountImpl _value, $Res Function(_$TopDiscountImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? discountId = null,
    Object? code = null,
    Object? usageCount = null,
  }) {
    return _then(_$TopDiscountImpl(
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

class _$TopDiscountImpl implements _TopDiscount {
  const _$TopDiscountImpl(
      {this.discountId = 0, this.code = '', this.usageCount = 0});

  @override
  @JsonKey()
  final int discountId;
  @override
  @JsonKey()
  final String code;
  @override
  @JsonKey()
  final int usageCount;

  @override
  String toString() {
    return 'TopDiscount(discountId: $discountId, code: $code, usageCount: $usageCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopDiscountImpl &&
            (identical(other.discountId, discountId) ||
                other.discountId == discountId) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.usageCount, usageCount) ||
                other.usageCount == usageCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, discountId, code, usageCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TopDiscountImplCopyWith<_$TopDiscountImpl> get copyWith =>
      __$$TopDiscountImplCopyWithImpl<_$TopDiscountImpl>(this, _$identity);
}

abstract class _TopDiscount implements TopDiscount {
  const factory _TopDiscount(
      {final int discountId,
      final String code,
      final int usageCount}) = _$TopDiscountImpl;

  @override
  int get discountId;
  @override
  String get code;
  @override
  int get usageCount;
  @override
  @JsonKey(ignore: true)
  _$$TopDiscountImplCopyWith<_$TopDiscountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
