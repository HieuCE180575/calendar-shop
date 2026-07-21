// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forgot_password_result_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ForgotPasswordResultModel _$ForgotPasswordResultModelFromJson(
    Map<String, dynamic> json) {
  return _ForgotPasswordResultModel.fromJson(json);
}

/// @nodoc
mixin _$ForgotPasswordResultModel {
  String get message => throw _privateConstructorUsedError;
  DateTime? get expiredAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ForgotPasswordResultModelCopyWith<ForgotPasswordResultModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForgotPasswordResultModelCopyWith<$Res> {
  factory $ForgotPasswordResultModelCopyWith(ForgotPasswordResultModel value,
          $Res Function(ForgotPasswordResultModel) then) =
      _$ForgotPasswordResultModelCopyWithImpl<$Res, ForgotPasswordResultModel>;
  @useResult
  $Res call({String message, DateTime? expiredAt});
}

/// @nodoc
class _$ForgotPasswordResultModelCopyWithImpl<$Res,
        $Val extends ForgotPasswordResultModel>
    implements $ForgotPasswordResultModelCopyWith<$Res> {
  _$ForgotPasswordResultModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? expiredAt = freezed,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      expiredAt: freezed == expiredAt
          ? _value.expiredAt
          : expiredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ForgotPasswordResultModelImplCopyWith<$Res>
    implements $ForgotPasswordResultModelCopyWith<$Res> {
  factory _$$ForgotPasswordResultModelImplCopyWith(
          _$ForgotPasswordResultModelImpl value,
          $Res Function(_$ForgotPasswordResultModelImpl) then) =
      __$$ForgotPasswordResultModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, DateTime? expiredAt});
}

/// @nodoc
class __$$ForgotPasswordResultModelImplCopyWithImpl<$Res>
    extends _$ForgotPasswordResultModelCopyWithImpl<$Res,
        _$ForgotPasswordResultModelImpl>
    implements _$$ForgotPasswordResultModelImplCopyWith<$Res> {
  __$$ForgotPasswordResultModelImplCopyWithImpl(
      _$ForgotPasswordResultModelImpl _value,
      $Res Function(_$ForgotPasswordResultModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? expiredAt = freezed,
  }) {
    return _then(_$ForgotPasswordResultModelImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      expiredAt: freezed == expiredAt
          ? _value.expiredAt
          : expiredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ForgotPasswordResultModelImpl implements _ForgotPasswordResultModel {
  const _$ForgotPasswordResultModelImpl(
      {required this.message, this.expiredAt});

  factory _$ForgotPasswordResultModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ForgotPasswordResultModelImplFromJson(json);

  @override
  final String message;
  @override
  final DateTime? expiredAt;

  @override
  String toString() {
    return 'ForgotPasswordResultModel(message: $message, expiredAt: $expiredAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForgotPasswordResultModelImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.expiredAt, expiredAt) ||
                other.expiredAt == expiredAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, message, expiredAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ForgotPasswordResultModelImplCopyWith<_$ForgotPasswordResultModelImpl>
      get copyWith => __$$ForgotPasswordResultModelImplCopyWithImpl<
          _$ForgotPasswordResultModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ForgotPasswordResultModelImplToJson(
      this,
    );
  }
}

abstract class _ForgotPasswordResultModel implements ForgotPasswordResultModel {
  const factory _ForgotPasswordResultModel(
      {required final String message,
      final DateTime? expiredAt}) = _$ForgotPasswordResultModelImpl;

  factory _ForgotPasswordResultModel.fromJson(Map<String, dynamic> json) =
      _$ForgotPasswordResultModelImpl.fromJson;

  @override
  String get message;
  @override
  DateTime? get expiredAt;
  @override
  @JsonKey(ignore: true)
  _$$ForgotPasswordResultModelImplCopyWith<_$ForgotPasswordResultModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
