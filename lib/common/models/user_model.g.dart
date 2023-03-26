// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      email: json['email'] as String?,
      username: json['username'] as String?,
      name: json['name'] as String?,
      lastLatitude: (json['last_latitude'] as num?)?.toDouble(),
      lastLongitude: (json['last_longitude'] as num?)?.toDouble(),
      lastSeen: json['last_seen'] == null
          ? null
          : DateTime.parse(json['last_seen'] as String),
      profilePicture: json['profile_picture'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'name': instance.name,
      'last_latitude': instance.lastLatitude,
      'last_longitude': instance.lastLongitude,
      'last_seen': instance.lastSeen?.toIso8601String(),
      'profile_picture': instance.profilePicture,
    };
