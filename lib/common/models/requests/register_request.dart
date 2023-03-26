import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest extends Equatable {
  final String email;
  final String username;
  final String name;
  final String password;
  final String profilePicture;

  const RegisterRequest({
    required this.email,
    required this.username,
    required this.name,
    required this.password,
    required this.profilePicture,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);

  @override
  List<Object?> get props => [email, username, name, password, profilePicture];
}
