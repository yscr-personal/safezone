import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
part 'location_received_payload.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LocationReceivedPayload extends Equatable {
  final String userId;
  final double latitude;
  final double longitude;

  const LocationReceivedPayload({
    required this.userId,
    required this.latitude,
    required this.longitude,
  });

  factory LocationReceivedPayload.fromJson(Map<String, dynamic> json) =>
      _$LocationReceivedPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$LocationReceivedPayloadToJson(this);

  @override
  List<Object?> get props => [userId, latitude, longitude];
}
