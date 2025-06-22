import 'package:json_annotation/json_annotation.dart';

part 'freezer.g.dart';

@JsonSerializable(explicitToJson: true)
class Freezer {
  final int id;
  final double count;
  
  @JsonKey(name: 'user')
  final UserRef user;
  
  @JsonKey(name: 'ingredient')
  final IngredientRef ingredient;

  Freezer({
    required this.id,
    required this.count,
    required this.user,
    required this.ingredient,
  });

  factory Freezer.fromJson(Map<String, dynamic> json) => _$FreezerFromJson(json);
  Map<String, dynamic> toJson() => _$FreezerToJson(this);
}

@JsonSerializable()
class UserRef {
  final int id;

  UserRef({required this.id});

  factory UserRef.fromJson(Map<String, dynamic> json) => _$UserRefFromJson(json);
  Map<String, dynamic> toJson() => _$UserRefToJson(this);
}

@JsonSerializable()
class IngredientRef {
  final int id;

  IngredientRef({required this.id});

  factory IngredientRef.fromJson(Map<String, dynamic> json) => _$IngredientRefFromJson(json);
  Map<String, dynamic> toJson() => _$IngredientRefToJson(this);
}