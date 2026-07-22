// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_category_stats_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AdminCategoryStatsModel _$AdminCategoryStatsModelFromJson(
    Map<String, dynamic> json) {
  return _AdminCategoryStatsModel.fromJson(json);
}

/// @nodoc
mixin _$AdminCategoryStatsModel {
  int get totalCategories => throw _privateConstructorUsedError;
  int get activeCategories => throw _privateConstructorUsedError;
  int get hiddenCategories => throw _privateConstructorUsedError;
  List<CategoryProductDistributionModel> get productDistribution =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AdminCategoryStatsModelCopyWith<AdminCategoryStatsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminCategoryStatsModelCopyWith<$Res> {
  factory $AdminCategoryStatsModelCopyWith(AdminCategoryStatsModel value,
          $Res Function(AdminCategoryStatsModel) then) =
      _$AdminCategoryStatsModelCopyWithImpl<$Res, AdminCategoryStatsModel>;
  @useResult
  $Res call(
      {int totalCategories,
      int activeCategories,
      int hiddenCategories,
      List<CategoryProductDistributionModel> productDistribution});
}

/// @nodoc
class _$AdminCategoryStatsModelCopyWithImpl<$Res,
        $Val extends AdminCategoryStatsModel>
    implements $AdminCategoryStatsModelCopyWith<$Res> {
  _$AdminCategoryStatsModelCopyWithImpl(this._value, this._then);

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
              as List<CategoryProductDistributionModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdminCategoryStatsModelImplCopyWith<$Res>
    implements $AdminCategoryStatsModelCopyWith<$Res> {
  factory _$$AdminCategoryStatsModelImplCopyWith(
          _$AdminCategoryStatsModelImpl value,
          $Res Function(_$AdminCategoryStatsModelImpl) then) =
      __$$AdminCategoryStatsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalCategories,
      int activeCategories,
      int hiddenCategories,
      List<CategoryProductDistributionModel> productDistribution});
}

/// @nodoc
class __$$AdminCategoryStatsModelImplCopyWithImpl<$Res>
    extends _$AdminCategoryStatsModelCopyWithImpl<$Res,
        _$AdminCategoryStatsModelImpl>
    implements _$$AdminCategoryStatsModelImplCopyWith<$Res> {
  __$$AdminCategoryStatsModelImplCopyWithImpl(
      _$AdminCategoryStatsModelImpl _value,
      $Res Function(_$AdminCategoryStatsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCategories = null,
    Object? activeCategories = null,
    Object? hiddenCategories = null,
    Object? productDistribution = null,
  }) {
    return _then(_$AdminCategoryStatsModelImpl(
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
              as List<CategoryProductDistributionModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdminCategoryStatsModelImpl implements _AdminCategoryStatsModel {
  const _$AdminCategoryStatsModelImpl(
      {required this.totalCategories,
      required this.activeCategories,
      required this.hiddenCategories,
      required final List<CategoryProductDistributionModel>
          productDistribution})
      : _productDistribution = productDistribution;

  factory _$AdminCategoryStatsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdminCategoryStatsModelImplFromJson(json);

  @override
  final int totalCategories;
  @override
  final int activeCategories;
  @override
  final int hiddenCategories;
  final List<CategoryProductDistributionModel> _productDistribution;
  @override
  List<CategoryProductDistributionModel> get productDistribution {
    if (_productDistribution is EqualUnmodifiableListView)
      return _productDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_productDistribution);
  }

  @override
  String toString() {
    return 'AdminCategoryStatsModel(totalCategories: $totalCategories, activeCategories: $activeCategories, hiddenCategories: $hiddenCategories, productDistribution: $productDistribution)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminCategoryStatsModelImpl &&
            (identical(other.totalCategories, totalCategories) ||
                other.totalCategories == totalCategories) &&
            (identical(other.activeCategories, activeCategories) ||
                other.activeCategories == activeCategories) &&
            (identical(other.hiddenCategories, hiddenCategories) ||
                other.hiddenCategories == hiddenCategories) &&
            const DeepCollectionEquality()
                .equals(other._productDistribution, _productDistribution));
  }

  @JsonKey(ignore: true)
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
  _$$AdminCategoryStatsModelImplCopyWith<_$AdminCategoryStatsModelImpl>
      get copyWith => __$$AdminCategoryStatsModelImplCopyWithImpl<
          _$AdminCategoryStatsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdminCategoryStatsModelImplToJson(
      this,
    );
  }
}

abstract class _AdminCategoryStatsModel implements AdminCategoryStatsModel {
  const factory _AdminCategoryStatsModel(
      {required final int totalCategories,
      required final int activeCategories,
      required final int hiddenCategories,
      required final List<CategoryProductDistributionModel>
          productDistribution}) = _$AdminCategoryStatsModelImpl;

  factory _AdminCategoryStatsModel.fromJson(Map<String, dynamic> json) =
      _$AdminCategoryStatsModelImpl.fromJson;

  @override
  int get totalCategories;
  @override
  int get activeCategories;
  @override
  int get hiddenCategories;
  @override
  List<CategoryProductDistributionModel> get productDistribution;
  @override
  @JsonKey(ignore: true)
  _$$AdminCategoryStatsModelImplCopyWith<_$AdminCategoryStatsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CategoryProductDistributionModel _$CategoryProductDistributionModelFromJson(
    Map<String, dynamic> json) {
  return _CategoryProductDistributionModel.fromJson(json);
}

/// @nodoc
mixin _$CategoryProductDistributionModel {
  String get categoryName => throw _privateConstructorUsedError;
  int get productCount => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CategoryProductDistributionModelCopyWith<CategoryProductDistributionModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryProductDistributionModelCopyWith<$Res> {
  factory $CategoryProductDistributionModelCopyWith(
          CategoryProductDistributionModel value,
          $Res Function(CategoryProductDistributionModel) then) =
      _$CategoryProductDistributionModelCopyWithImpl<$Res,
          CategoryProductDistributionModel>;
  @useResult
  $Res call({String categoryName, int productCount, double percentage});
}

/// @nodoc
class _$CategoryProductDistributionModelCopyWithImpl<$Res,
        $Val extends CategoryProductDistributionModel>
    implements $CategoryProductDistributionModelCopyWith<$Res> {
  _$CategoryProductDistributionModelCopyWithImpl(this._value, this._then);

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
abstract class _$$CategoryProductDistributionModelImplCopyWith<$Res>
    implements $CategoryProductDistributionModelCopyWith<$Res> {
  factory _$$CategoryProductDistributionModelImplCopyWith(
          _$CategoryProductDistributionModelImpl value,
          $Res Function(_$CategoryProductDistributionModelImpl) then) =
      __$$CategoryProductDistributionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String categoryName, int productCount, double percentage});
}

/// @nodoc
class __$$CategoryProductDistributionModelImplCopyWithImpl<$Res>
    extends _$CategoryProductDistributionModelCopyWithImpl<$Res,
        _$CategoryProductDistributionModelImpl>
    implements _$$CategoryProductDistributionModelImplCopyWith<$Res> {
  __$$CategoryProductDistributionModelImplCopyWithImpl(
      _$CategoryProductDistributionModelImpl _value,
      $Res Function(_$CategoryProductDistributionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryName = null,
    Object? productCount = null,
    Object? percentage = null,
  }) {
    return _then(_$CategoryProductDistributionModelImpl(
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
@JsonSerializable()
class _$CategoryProductDistributionModelImpl
    implements _CategoryProductDistributionModel {
  const _$CategoryProductDistributionModelImpl(
      {required this.categoryName,
      required this.productCount,
      required this.percentage});

  factory _$CategoryProductDistributionModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$CategoryProductDistributionModelImplFromJson(json);

  @override
  final String categoryName;
  @override
  final int productCount;
  @override
  final double percentage;

  @override
  String toString() {
    return 'CategoryProductDistributionModel(categoryName: $categoryName, productCount: $productCount, percentage: $percentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryProductDistributionModelImpl &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.productCount, productCount) ||
                other.productCount == productCount) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, categoryName, productCount, percentage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryProductDistributionModelImplCopyWith<
          _$CategoryProductDistributionModelImpl>
      get copyWith => __$$CategoryProductDistributionModelImplCopyWithImpl<
          _$CategoryProductDistributionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryProductDistributionModelImplToJson(
      this,
    );
  }
}

abstract class _CategoryProductDistributionModel
    implements CategoryProductDistributionModel {
  const factory _CategoryProductDistributionModel(
          {required final String categoryName,
          required final int productCount,
          required final double percentage}) =
      _$CategoryProductDistributionModelImpl;

  factory _CategoryProductDistributionModel.fromJson(
          Map<String, dynamic> json) =
      _$CategoryProductDistributionModelImpl.fromJson;

  @override
  String get categoryName;
  @override
  int get productCount;
  @override
  double get percentage;
  @override
  @JsonKey(ignore: true)
  _$$CategoryProductDistributionModelImplCopyWith<
          _$CategoryProductDistributionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
