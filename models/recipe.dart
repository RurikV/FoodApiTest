import 'package:json_annotation/json_annotation.dart';
import 'recipe_ingredient.dart';
import 'recipe_step_link.dart';
import 'favorite.dart';
import 'comment.dart';

part 'recipe.g.dart';

@JsonSerializable(explicitToJson: true)
class Recipe {
  final int id;
  final String name;
  final int duration;
  final String photo;
  
  @JsonKey(name: 'recipeIngredients')
  final List<RecipeIngredient>? ingredients;
  
  @JsonKey(name: 'recipeStepLinks')
  final List<RecipeStepLink>? stepLinks;
  
  @JsonKey(name: 'favoriteRecipes')
  final List<Favorite>? favorites;
  
  @JsonKey(name: 'comments')
  final List<Comment>? comments;

  Recipe({
    required this.id,
    required this.name,
    required this.duration,
    required this.photo,
    this.ingredients,
    this.stepLinks,
    this.favorites,
    this.comments,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeToJson(this);
}