import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String? name;
  final String? email;
  final String? profilePicture;

  const UserModel({
    required this.id,
    this.name,
    this.email,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [id, name, email, profilePicture];
}
