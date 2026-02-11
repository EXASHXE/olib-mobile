// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  @JsonKey(fromJson: _toString)
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'kindle_email')
  String? get kindleEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'remix_userkey')
  String get remixUserkey => throw _privateConstructorUsedError;
  @JsonKey(name: 'downloads_limit', fromJson: _toInt)
  int? get downloadsLimit => throw _privateConstructorUsedError;
  @JsonKey(name: 'downloads_today', fromJson: _toInt)
  int? get downloadsToday => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toInt)
  int? get confirmed => throw _privateConstructorUsedError;
  @JsonKey(name: 'isPremium', fromJson: _toInt)
  int? get isPremium => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _toString) String id,
      String name,
      String email,
      @JsonKey(name: 'kindle_email') String? kindleEmail,
      @JsonKey(name: 'remix_userkey') String remixUserkey,
      @JsonKey(name: 'downloads_limit', fromJson: _toInt) int? downloadsLimit,
      @JsonKey(name: 'downloads_today', fromJson: _toInt) int? downloadsToday,
      @JsonKey(fromJson: _toInt) int? confirmed,
      @JsonKey(name: 'isPremium', fromJson: _toInt) int? isPremium});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? kindleEmail = freezed,
    Object? remixUserkey = null,
    Object? downloadsLimit = freezed,
    Object? downloadsToday = freezed,
    Object? confirmed = freezed,
    Object? isPremium = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      kindleEmail: freezed == kindleEmail
          ? _value.kindleEmail
          : kindleEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      remixUserkey: null == remixUserkey
          ? _value.remixUserkey
          : remixUserkey // ignore: cast_nullable_to_non_nullable
              as String,
      downloadsLimit: freezed == downloadsLimit
          ? _value.downloadsLimit
          : downloadsLimit // ignore: cast_nullable_to_non_nullable
              as int?,
      downloadsToday: freezed == downloadsToday
          ? _value.downloadsToday
          : downloadsToday // ignore: cast_nullable_to_non_nullable
              as int?,
      confirmed: freezed == confirmed
          ? _value.confirmed
          : confirmed // ignore: cast_nullable_to_non_nullable
              as int?,
      isPremium: freezed == isPremium
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _toString) String id,
      String name,
      String email,
      @JsonKey(name: 'kindle_email') String? kindleEmail,
      @JsonKey(name: 'remix_userkey') String remixUserkey,
      @JsonKey(name: 'downloads_limit', fromJson: _toInt) int? downloadsLimit,
      @JsonKey(name: 'downloads_today', fromJson: _toInt) int? downloadsToday,
      @JsonKey(fromJson: _toInt) int? confirmed,
      @JsonKey(name: 'isPremium', fromJson: _toInt) int? isPremium});
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? kindleEmail = freezed,
    Object? remixUserkey = null,
    Object? downloadsLimit = freezed,
    Object? downloadsToday = freezed,
    Object? confirmed = freezed,
    Object? isPremium = freezed,
  }) {
    return _then(_$UserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      kindleEmail: freezed == kindleEmail
          ? _value.kindleEmail
          : kindleEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      remixUserkey: null == remixUserkey
          ? _value.remixUserkey
          : remixUserkey // ignore: cast_nullable_to_non_nullable
              as String,
      downloadsLimit: freezed == downloadsLimit
          ? _value.downloadsLimit
          : downloadsLimit // ignore: cast_nullable_to_non_nullable
              as int?,
      downloadsToday: freezed == downloadsToday
          ? _value.downloadsToday
          : downloadsToday // ignore: cast_nullable_to_non_nullable
              as int?,
      confirmed: freezed == confirmed
          ? _value.confirmed
          : confirmed // ignore: cast_nullable_to_non_nullable
              as int?,
      isPremium: freezed == isPremium
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl extends _User {
  const _$UserImpl(
      {@JsonKey(fromJson: _toString) required this.id,
      required this.name,
      required this.email,
      @JsonKey(name: 'kindle_email') this.kindleEmail,
      @JsonKey(name: 'remix_userkey') required this.remixUserkey,
      @JsonKey(name: 'downloads_limit', fromJson: _toInt) this.downloadsLimit,
      @JsonKey(name: 'downloads_today', fromJson: _toInt) this.downloadsToday,
      @JsonKey(fromJson: _toInt) this.confirmed,
      @JsonKey(name: 'isPremium', fromJson: _toInt) this.isPremium})
      : super._();

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  @JsonKey(fromJson: _toString)
  final String id;
  @override
  final String name;
  @override
  final String email;
  @override
  @JsonKey(name: 'kindle_email')
  final String? kindleEmail;
  @override
  @JsonKey(name: 'remix_userkey')
  final String remixUserkey;
  @override
  @JsonKey(name: 'downloads_limit', fromJson: _toInt)
  final int? downloadsLimit;
  @override
  @JsonKey(name: 'downloads_today', fromJson: _toInt)
  final int? downloadsToday;
  @override
  @JsonKey(fromJson: _toInt)
  final int? confirmed;
  @override
  @JsonKey(name: 'isPremium', fromJson: _toInt)
  final int? isPremium;

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, kindleEmail: $kindleEmail, remixUserkey: $remixUserkey, downloadsLimit: $downloadsLimit, downloadsToday: $downloadsToday, confirmed: $confirmed, isPremium: $isPremium)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.kindleEmail, kindleEmail) ||
                other.kindleEmail == kindleEmail) &&
            (identical(other.remixUserkey, remixUserkey) ||
                other.remixUserkey == remixUserkey) &&
            (identical(other.downloadsLimit, downloadsLimit) ||
                other.downloadsLimit == downloadsLimit) &&
            (identical(other.downloadsToday, downloadsToday) ||
                other.downloadsToday == downloadsToday) &&
            (identical(other.confirmed, confirmed) ||
                other.confirmed == confirmed) &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, email, kindleEmail,
      remixUserkey, downloadsLimit, downloadsToday, confirmed, isPremium);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User extends User {
  const factory _User(
          {@JsonKey(fromJson: _toString) required final String id,
          required final String name,
          required final String email,
          @JsonKey(name: 'kindle_email') final String? kindleEmail,
          @JsonKey(name: 'remix_userkey') required final String remixUserkey,
          @JsonKey(name: 'downloads_limit', fromJson: _toInt)
          final int? downloadsLimit,
          @JsonKey(name: 'downloads_today', fromJson: _toInt)
          final int? downloadsToday,
          @JsonKey(fromJson: _toInt) final int? confirmed,
          @JsonKey(name: 'isPremium', fromJson: _toInt) final int? isPremium}) =
      _$UserImpl;
  const _User._() : super._();

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  @JsonKey(fromJson: _toString)
  String get id;
  @override
  String get name;
  @override
  String get email;
  @override
  @JsonKey(name: 'kindle_email')
  String? get kindleEmail;
  @override
  @JsonKey(name: 'remix_userkey')
  String get remixUserkey;
  @override
  @JsonKey(name: 'downloads_limit', fromJson: _toInt)
  int? get downloadsLimit;
  @override
  @JsonKey(name: 'downloads_today', fromJson: _toInt)
  int? get downloadsToday;
  @override
  @JsonKey(fromJson: _toInt)
  int? get confirmed;
  @override
  @JsonKey(name: 'isPremium', fromJson: _toInt)
  int? get isPremium;
  @override
  @JsonKey(ignore: true)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
