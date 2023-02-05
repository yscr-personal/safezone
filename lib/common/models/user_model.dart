import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel extends Equatable {
  final String id;
  final String? email;
  final String? username;
  final String? name;
  final double? lastLatitude;
  final double? lastLongitude;
  final DateTime? lastSeen;

  const UserModel({
    required this.id,
    this.email,
    this.username,
    this.name,
    this.lastLatitude,
    this.lastLongitude,
    this.lastSeen,
  });

  factory UserModel.empty() => const UserModel(id: '');

  factory UserModel.copyWith(
    final UserModel other, {
    final String? email,
    final String? username,
    final String? name,
    final double? lastLatitude,
    final double? lastLongitude,
    final DateTime? lastSeen,
  }) =>
      UserModel(
        id: other.id,
        email: email ?? other.email,
        username: username ?? other.username,
        name: name ?? other.name,
        lastLatitude: lastLatitude ?? other.lastLatitude,
        lastLongitude: lastLongitude ?? other.lastLongitude,
        lastSeen: lastSeen ?? other.lastSeen,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props =>
      [id, name, username, lastLatitude, lastLongitude, lastSeen];
}
