// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_category_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AdminCategoryStats {
  int get totalCategories => throw _privateConstructorUsedError;
  int get activeCategories => throw _privateConstructorUsedError;
  int get hiddenCategories => throw _privateConstructorUsedError;
  List<CategoryProductDistribution> get productDistribution =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AdminCategoryStatsCopyWith<AdminCategoryStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminCategoryStatsCopyWith<$Res> {
  factory $AdminCategoryStatsCopyWith(
          AdminCategoryStats value, $Res Function(AdminCategoryStats) then) =
      _$AdminCategoryStatsCopyWithImpl<$Res, AdminCategoryStats>;
  @useResult
  $Res call(
      {int totalCategories,
      int activeCategories,
      int hiddenCategories,
      List<CategoryProductDistribution> productDistribution});
}

/// @nodoc
class _$AdminCategoryStatsCopyWithImpl<$Res, $Val extends AdminCategoryStats>
    implements $AdminCategoryStatsCopyWith<$Res> {
  _$AdminCategoryStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCategories = null,
    Object? activeCategories = null,
    Object? hiddenCategories = null,
    Object? productDistribution = null,
  }) {
    return _then(_value.copyWith(
      totalCategories: null == totalCategories
          ? _value.totalCategories
          : totalCategories // ignore: cast_nullable_to_non_nullable
              as int,
      activeCategories: null == activeCategories
          ? _value.activeCategories
          : activeCategories // ignore: cast_nullable_to_non_nullable
              as int,
      hiddenCategories: null == hiddenCategories
          ? _value.hiddenCategories
          : hiddenCategories // ignore: cast_nullable_to_non_nullable
              as int,
      productDistribution: null == productDistribution
          ? _value.productDistribution
          : productDistribution // ignore: cast_nullable_to_non_nullable
              as List<CategoryProductDistribution>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdminCategoryStatsImplCopyWith<$Res>
    implements $AdminCategoryStatsCopyWith<$Res> {
  factory _$$AdminCategoryStatsImplCopyWith(_$AdminCategoryStatsImpl value,
          $Res Function(_$AdminCategoryStatsImpl) then) =
      __$$AdminCategoryStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalCategories,
      int activeCategories,
      int hiddenCategories,
      List<CategoryProductDistribution> productDistribution});
}

/// @nodoc
class __$$AdminCategoryStatsImplCopyWithImpl<$Res>
    extends _$AdminCategoryStatsCopyWithImpl<$Res, _$AdminCategoryStatsImpl>
    implements _$$AdminCategoryStatsImplCopyWith<$Res> {
  __$$AdminCategoryStatsImplCopyWithImpl(_$AdminCategoryStatsImpl _value,
      $Res Function(_$AdminCategoryStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCategories = null,
    Object? activeCategories = null,
    Object? hiddenCategories = null,
    Object? productDistribution = null,
  }) {
    return _then(_$AdminCategoryStatsImpl(
      totalCategories: null == totalCategories
          ? _value.totalCategories
          : totalCategories // ignore: cast_nullable_to_non_nullable
              as int,
      activeCategories: null == activeCategories
          ? _value.activeCategories
          : activeCategories // ignore: cast_nullable_to_non_nullable
              as int,
      hiddenCategories: null == hiddenCategories
          ? _value.hiddenCategories
          : hiddenCategories // ignore: cast_nullable_to_non_nullable
              as int,
      productDistribution: null == productDistribution
          ? _value._productDistribution
          : productDistribution // ignore: cast_nullable_to_non_nullable
              as List<CategoryProductDistribution>,
    ));
  }
}

/// @nodoc

class _$AdminCategoryStatsImpl implements _AdminCategoryStats {
  const _$AdminCategoryStatsImpl(
      {this.totalCategories = 0,
      this.activeCategories = 0,
      this.hiddenCategories = 0,
      final List<CategoryProductDistribution> productDistribution = const []})
      : _productDistribution = productDistribution;

  @override
  @JsonKey()
  final int totalCategories;
  @override
  @JsonKey()
  final int activeCategories;
  @override
  @JsonKey()
  final int hiddenCategories;
  final List<CategoryProductDistribution> _productDistribution;
  @override
  @JsonKey()
  List<CategoryProductDistribution> get productDistribution {
    if (_productDistribution is EqualUnmodifiableListView)
      return _productDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_productDistribution);
  }

  @override
  String toString() {
    return 'AdminCategoryStats(totalCategories: $totalCategories, activeCategories: $activeCategories, hiddenCategories: $hiddenCategories, productDistribution: $productDistribution)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminCategoryStatsImpl &&
            (identical(other.totalCategories, totalCategories) ||
                other.totalCategories == totalCategories) &&
            (identical(other.activeCategories, activeCategories) ||
                other.activeCategories == activeCategories) &&
            (identical(other.hiddenCategories, hiddenCategories) ||
                other.hiddenCategories == hiddenCategories) &&
            const DeepCollectionEquality()
                .equals(other._productDistribution, _productDistribution));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalCategories,
      activeCategories,
      hiddenCategories,
      const DeepCollectionEquality().hash(_productDistribution));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminCategoryStatsImplCopyWith<_$AdminCategoryStatsImpl> get copyWith =>
      __$$AdminCategoryStatsImplCopyWithImpl<_$AdminCategoryStatsImpl>(
          this, _$identity);
}

abstract class _AdminCategoryStats implements AdminCategoryStats {
  const factory _AdminCategoryStats(
          {final int totalCategories,
          final int activeCategories,
          final int hiddenCategories,
          final List<CategoryProductDistribution> productDistribution}) =
      _$AdminCategoryStatsImpl;

  @override
  int get totalCategories;
  @override
  int get activeCategories;
  @override
  int get hiddenCategories;
  @override
  List<CategoryProductDistribution> get productDistribution;
  @override
  @JsonKey(ignore: true)
  _$$AdminCategoryStatsImplCopyWith<_$AdminCategoryStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CategoryProductDistribution {
  String get categoryName => throw _privateConstructorUsedError;
  int get productCount => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CategoryProductDistributionCopyWith<CategoryProductDistribution>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryProductDistributionCopyWith<$Res> {
  factory $CategoryProductDistributionCopyWith(
          CategoryProductDistribution value,
          $Res Function(CategoryProductDistribution) then) =
      _$CategoryProductDistributionCopyWithImpl<$Res,
          CategoryProductDistribution>;
  @useResult
  $Res call({String categoryName, int productCount, double percentage});
}

/// @nodoc
class _$CategoryProductDistributionCopyWithImpl<$Res,
        $Val extends CategoryProductDistribution>
    implements $CategoryProductDistributionCopyWith<$Res> {
  _$CategoryProductDistributionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryName = null,
    Object? productCount = null,
    Object? percentage = null,
  }) {
    return _then(_value.copyWith(
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      productCount: null == productCount
          ? _value.productCount
          : productCount // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryProductDistributionImplCopyWith<$Res>
    implements $CategoryProductDistributionCopyWith<$Res> {
  factory _$$CategoryProductDistributionImplCopyWith(
          _$CategoryProductDistributionImpl value,
          $Res Function(_$CategoryProductDistributionImpl) then) =
      __$$CategoryProductDistributionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String categoryName, int productCount, double percentage});
}

/// @nodoc
class __$$CategoryProductDistributionImplCopyWithImpl<$Res>
    extends _$CategoryProductDistributionCopyWithImpl<$Res,
        _$CategoryProductDistributionImpl>
    implements _$$CategoryProductDistributionImplCopyWith<$Res> {
  __$$CategoryProductDistributionImplCopyWithImpl(
      _$CategoryProductDistributionImpl _value,
      $Res Function(_$CategoryProductDistributionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryName = null,
    Object? productCount = null,
    Object? percentage = null,
  }) {
    return _then(_$CategoryProductDistributionImpl(
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      productCount: null == productCount
          ? _value.productCount
          : productCount // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$CategoryProductDistributionImpl
    implements _CategoryProductDistribution {
  const _$CategoryProductDistributionImpl(
      {this.categoryName = '', this.productCount = 0, this.percentage = 0.0});

  @override
  @JsonKey()
  final String categoryName;
  @override
  @JsonKey()
  final int productCount;
  @override
  @JsonKey()
  final double percentage;

  @override
  String toString() {
    return 'CategoryProductDistribution(categoryName: $categoryName, productCount: $productCount, percentage: $percentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryProductDistributionImpl &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.productCount, productCount) ||
                other.productCount == productCount) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, categoryName, productCount, percentage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryProductDistributionImplCopyWith<_$CategoryProductDistributionImpl>
      get copyWith => __$$CategoryProductDistributionImplCopyWithImpl<
          _$CategoryProductDistributionImpl>(this, _$identity);
}

abstract class _CategoryProductDistribution
    implements CategoryProductDistribution {
  const factory _CategoryProductDistribution(
      {final String categoryName,
      final int productCount,
      final double percentage}) = _$CategoryProductDistributionImpl;

  @override
  String get categoryName;
  @override
  int get productCount;
  @override
  double get percentage;
  @override
  @JsonKey(ignore: true)
  _$$CategoryProductDistributionImplCopyWith<_$CategoryProductDistributionImpl>
      get copyWith => throw _privateConstructorUsedError;
}
