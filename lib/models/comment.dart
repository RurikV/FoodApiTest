import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable(explicitToJson: true)
class Comment {
  final int id;
  final String text;
  final String photo;
  final String datetime;
  
  @JsonKey(name: 'user')
  final UserRef user;
  
  @JsonKey(name: 'recipe')
  final RecipeRef recipe;

  Comment({
    required this.id,
    required this.text,
    required this.photo,
    required this.datetime,
    required this.user,
    required this.recipe,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}

@JsonSerializable()
class UserRef {
  final int id;

  UserRef({required this.id});

  factory UserRef.fromJson(Map<String, dynamic> json) => _$UserRefFromJson(json);
  Map<String, dynamic> toJson() => _$UserRefToJson(this);
}

@JsonSerializable()
class RecipeRef {
  final int id;

  RecipeRef({required this.id});

  factory RecipeRef.fromJson(Map<String, dynamic> json) => _$RecipeRefFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeRefToJson(this);
}