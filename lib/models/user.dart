import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const User._();

  const factory User({
    @JsonKey(fromJson: _toString) required String id,
    required String name,
    required String email,
    @JsonKey(name: 'kindle_email') String? kindleEmail,
    @JsonKey(name: 'remix_userkey') required String remixUserkey,
    @JsonKey(name: 'downloads_limit', fromJson: _toInt) int? downloadsLimit,
    @JsonKey(name: 'downloads_today', fromJson: _toInt) int? downloadsToday,
    @JsonKey(fromJson: _toInt) int? confirmed,
    @JsonKey(name: 'isPremium', fromJson: _toInt) int? isPremium,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  // Computed property for downloads left
  int get downloadsLeft => (downloadsLimit ?? 10) - (downloadsToday ?? 0);
}

// Helpers
String _toString(dynamic value) => value?.toString() ?? '';
int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}
