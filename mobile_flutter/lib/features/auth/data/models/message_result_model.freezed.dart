// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_result_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MessageResultModel _$MessageResultModelFromJson(Map<String, dynamic> json) {
  return _MessageResultModel.fromJson(json);
}

/// @nodoc
mixin _$MessageResultModel {
  String get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageResultModelCopyWith<MessageResultModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageResultModelCopyWith<$Res> {
  factory $MessageResultModelCopyWith(
          MessageResultModel value, $Res Function(MessageResultModel) then) =
      _$MessageResultModelCopyWithImpl<$Res, MessageResultModel>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$MessageResultModelCopyWithImpl<$Res, $Val extends MessageResultModel>
    implements $MessageResultModelCopyWith<$Res> {
  _$MessageResultModelCopyWithImpl(this._value, this._then);

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
abstract class _$$MessageResultModelImplCopyWith<$Res>
    implements $MessageResultModelCopyWith<$Res> {
  factory _$$MessageResultModelImplCopyWith(_$MessageResultModelImpl value,
          $Res Function(_$MessageResultModelImpl) then) =
      __$$MessageResultModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$MessageResultModelImplCopyWithImpl<$Res>
    extends _$MessageResultModelCopyWithImpl<$Res, _$MessageResultModelImpl>
    implements _$$MessageResultModelImplCopyWith<$Res> {
  __$$MessageResultModelImplCopyWithImpl(_$MessageResultModelImpl _value,
      $Res Function(_$MessageResultModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$MessageResultModelImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageResultModelImpl implements _MessageResultModel {
  const _$MessageResultModelImpl({required this.message});

  factory _$MessageResultModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageResultModelImplFromJson(json);

  @override
  final String message;

  @override
  String toString() {
    return 'MessageResultModel(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageResultModelImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageResultModelImplCopyWith<_$MessageResultModelImpl> get copyWith =>
      __$$MessageResultModelImplCopyWithImpl<_$MessageResultModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageResultModelImplToJson(
      this,
    );
  }
}

abstract class _MessageResultModel implements MessageResultModel {
  const factory _MessageResultModel({required final String message}) =
      _$MessageResultModelImpl;

  factory _MessageResultModel.fromJson(Map<String, dynamic> json) =
      _$MessageResultModelImpl.fromJson;

  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$MessageResultModelImplCopyWith<_$MessageResultModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
