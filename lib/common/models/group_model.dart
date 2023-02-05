import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:unb/common/models/user_model.dart';
part 'group_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class GroupModel extends Equatable {
  final String id;
  final String? name;
  final List<UserModel>? members;

  const GroupModel({required this.id, this.name, this.members});

  factory GroupModel.empty() => const GroupModel(id: '');

  factory GroupModel.copyWith(
    final GroupModel group, {
    final String? name,
    final List<UserModel>? members,
  }) =>
      GroupModel(
        id: group.id,
        name: name ?? group.name,
        members: members ?? group.members,
      );

  factory GroupModel.fromJson(Map<String, dynamic> json) =>
      _$GroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroupModelToJson(this);

  @override
  List<Object?> get props => [id, name, members];
}
