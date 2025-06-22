import 'package:json_annotation/json_annotation.dart';

part 'favorite.g.dart';

@JsonSerializable(explicitToJson: true)
class Favorite {
  final int id;
  
  @JsonKey(name: 'recipe')
  final RecipeRef recipe;
  
  @JsonKey(name: 'user')
  final UserRef user;

  Favorite({
    required this.id,
    required this.recipe,
    required this.user,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) => _$FavoriteFromJson(json);
  Map<String, dynamic> toJson() => _$FavoriteToJson(this);
}

@JsonSerializable()
class RecipeRef {
  final int id;

  RecipeRef({required this.id});

  factory RecipeRef.fromJson(Map<String, dynamic> json) => _$RecipeRefFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeRefToJson(this);
}

@JsonSerializable()
class UserRef {
  final int id;

  UserRef({required this.id});

  factory UserRef.fromJson(Map<String, dynamic> json) => _$UserRefFromJson(json);
  Map<String, dynamic> toJson() => _$UserRefToJson(this);
}