// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AdminUserModel _$AdminUserModelFromJson(Map<String, dynamic> json) {
  return _AdminUserModel.fromJson(json);
}

/// @nodoc
mixin _$AdminUserModel {
  int get userId => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  bool get isEmailConfirmed => throw _privateConstructorUsedError;
  DateTime? get emailConfirmedAt => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  DateTime? get dateOfBirth => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AdminUserModelCopyWith<AdminUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminUserModelCopyWith<$Res> {
  factory $AdminUserModelCopyWith(
          AdminUserModel value, $Res Function(AdminUserModel) then) =
      _$AdminUserModelCopyWithImpl<$Res, AdminUserModel>;
  @useResult
  $Res call(
      {int userId,
      String fullName,
      String? email,
      String? phone,
      String role,
      String status,
      bool isEmailConfirmed,
      DateTime? emailConfirmedAt,
      String? avatarUrl,
      String? gender,
      DateTime? dateOfBirth,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$AdminUserModelCopyWithImpl<$Res, $Val extends AdminUserModel>
    implements $AdminUserModelCopyWith<$Res> {
  _$AdminUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? fullName = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? role = null,
    Object? status = null,
    Object? isEmailConfirmed = null,
    Object? emailConfirmedAt = freezed,
    Object? avatarUrl = freezed,
    Object? gender = freezed,
    Object? dateOfBirth = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isEmailConfirmed: null == isEmailConfirmed
          ? _value.isEmailConfirmed
          : isEmailConfirmed // ignore: cast_nullable_to_non_nullable
              as bool,
      emailConfirmedAt: freezed == emailConfirmedAt
          ? _value.emailConfirmedAt
          : emailConfirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdminUserModelImplCopyWith<$Res>
    implements $AdminUserModelCopyWith<$Res> {
  factory _$$AdminUserModelImplCopyWith(_$AdminUserModelImpl value,
          $Res Function(_$AdminUserModelImpl) then) =
      __$$AdminUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int userId,
      String fullName,
      String? email,
      String? phone,
      String role,
      String status,
      bool isEmailConfirmed,
      DateTime? emailConfirmedAt,
      String? avatarUrl,
      String? gender,
      DateTime? dateOfBirth,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$AdminUserModelImplCopyWithImpl<$Res>
    extends _$AdminUserModelCopyWithImpl<$Res, _$AdminUserModelImpl>
    implements _$$AdminUserModelImplCopyWith<$Res> {
  __$$AdminUserModelImplCopyWithImpl(
      _$AdminUserModelImpl _value, $Res Function(_$AdminUserModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? fullName = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? role = null,
    Object? status = null,
    Object? isEmailConfirmed = null,
    Object? emailConfirmedAt = freezed,
    Object? avatarUrl = freezed,
    Object? gender = freezed,
    Object? dateOfBirth = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$AdminUserModelImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isEmailConfirmed: null == isEmailConfirmed
          ? _value.isEmailConfirmed
          : isEmailConfirmed // ignore: cast_nullable_to_non_nullable
              as bool,
      emailConfirmedAt: freezed == emailConfirmedAt
          ? _value.emailConfirmedAt
          : emailConfirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdminUserModelImpl implements _AdminUserModel {
  const _$AdminUserModelImpl(
      {required this.userId,
      required this.fullName,
      this.email,
      this.phone,
      required this.role,
      required this.status,
      this.isEmailConfirmed = false,
      this.emailConfirmedAt,
      this.avatarUrl,
      this.gender,
      this.dateOfBirth,
      this.createdAt,
      this.updatedAt});

  factory _$AdminUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdminUserModelImplFromJson(json);

  @override
  final int userId;
  @override
  final String fullName;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String role;
  @override
  final String status;
  @override
  @JsonKey()
  final bool isEmailConfirmed;
  @override
  final DateTime? emailConfirmedAt;
  @override
  final String? avatarUrl;
  @override
  final String? gender;
  @override
  final DateTime? dateOfBirth;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'AdminUserModel(userId: $userId, fullName: $fullName, email: $email, phone: $phone, role: $role, status: $status, isEmailConfirmed: $isEmailConfirmed, emailConfirmedAt: $emailConfirmedAt, avatarUrl: $avatarUrl, gender: $gender, dateOfBirth: $dateOfBirth, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminUserModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isEmailConfirmed, isEmailConfirmed) ||
                other.isEmailConfirmed == isEmailConfirmed) &&
            (identical(other.emailConfirmedAt, emailConfirmedAt) ||
                other.emailConfirmedAt == emailConfirmedAt) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      fullName,
      email,
      phone,
      role,
      status,
      isEmailConfirmed,
      emailConfirmedAt,
      avatarUrl,
      gender,
      dateOfBirth,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminUserModelImplCopyWith<_$AdminUserModelImpl> get copyWith =>
      __$$AdminUserModelImplCopyWithImpl<_$AdminUserModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdminUserModelImplToJson(
      this,
    );
  }
}

abstract class _AdminUserModel implements AdminUserModel {
  const factory _AdminUserModel(
      {required final int userId,
      required final String fullName,
      final String? email,
      final String? phone,
      required final String role,
      required final String status,
      final bool isEmailConfirmed,
      final DateTime? emailConfirmedAt,
      final String? avatarUrl,
      final String? gender,
      final DateTime? dateOfBirth,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$AdminUserModelImpl;

  factory _AdminUserModel.fromJson(Map<String, dynamic> json) =
      _$AdminUserModelImpl.fromJson;

  @override
  int get userId;
  @override
  String get fullName;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  String get role;
  @override
  String get status;
  @override
  bool get isEmailConfirmed;
  @override
  DateTime? get emailConfirmedAt;
  @override
  String? get avatarUrl;
  @override
  String? get gender;
  @override
  DateTime? get dateOfBirth;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$AdminUserModelImplCopyWith<_$AdminUserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
