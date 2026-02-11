// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: _toString(json['id']),
      name: json['name'] as String,
      email: json['email'] as String,
      kindleEmail: json['kindle_email'] as String?,
      remixUserkey: json['remix_userkey'] as String,
      downloadsLimit: _toInt(json['downloads_limit']),
      downloadsToday: _toInt(json['downloads_today']),
      confirmed: _toInt(json['confirmed']),
      isPremium: _toInt(json['isPremium']),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'kindle_email': instance.kindleEmail,
      'remix_userkey': instance.remixUserkey,
      'downloads_limit': instance.downloadsLimit,
      'downloads_today': instance.downloadsToday,
      'confirmed': instance.confirmed,
      'isPremium': instance.isPremium,
    };
