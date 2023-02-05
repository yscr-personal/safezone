// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_received_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationReceivedPayload _$LocationReceivedPayloadFromJson(
        Map<String, dynamic> json) =>
    LocationReceivedPayload(
      userId: json['user_id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$LocationReceivedPayloadToJson(
        LocationReceivedPayload instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
