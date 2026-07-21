// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_result_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RegisterResultModel _$RegisterResultModelFromJson(Map<String, dynamic> json) {
  return _RegisterResultModel.fromJson(json);
}

/// @nodoc
mixin _$RegisterResultModel {
  String get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RegisterResultModelCopyWith<RegisterResultModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterResultModelCopyWith<$Res> {
  factory $RegisterResultModelCopyWith(
          RegisterResultModel value, $Res Function(RegisterResultModel) then) =
      _$RegisterResultModelCopyWithImpl<$Res, RegisterResultModel>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$RegisterResultModelCopyWithImpl<$Res, $Val extends RegisterResultModel>
    implements $RegisterResultModelCopyWith<$Res> {
  _$RegisterResultModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegisterResultModelImplCopyWith<$Res>
    implements $RegisterResultModelCopyWith<$Res> {
  factory _$$RegisterResultModelImplCopyWith(_$RegisterResultModelImpl value,
          $Res Function(_$RegisterResultModelImpl) then) =
      __$$RegisterResultModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$RegisterResultModelImplCopyWithImpl<$Res>
    extends _$RegisterResultModelCopyWithImpl<$Res, _$RegisterResultModelImpl>
    implements _$$RegisterResultModelImplCopyWith<$Res> {
  __$$RegisterResultModelImplCopyWithImpl(_$RegisterResultModelImpl _value,
      $Res Function(_$RegisterResultModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$RegisterResultModelImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterResultModelImpl implements _RegisterResultModel {
  const _$RegisterResultModelImpl({required this.message});

  factory _$RegisterResultModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegisterResultModelImplFromJson(json);

  @override
  final String message;

  @override
  String toString() {
    return 'RegisterResultModel(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterResultModelImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterResultModelImplCopyWith<_$RegisterResultModelImpl> get copyWith =>
      __$$RegisterResultModelImplCopyWithImpl<_$RegisterResultModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterResultModelImplToJson(
      this,
    );
  }
}

abstract class _RegisterResultModel implements RegisterResultModel {
  const factory _RegisterResultModel({required final String message}) =
      _$RegisterResultModelImpl;

  factory _RegisterResultModel.fromJson(Map<String, dynamic> json) =
      _$RegisterResultModelImpl.fromJson;

  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$RegisterResultModelImplCopyWith<_$RegisterResultModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
