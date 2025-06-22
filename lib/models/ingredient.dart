import 'package:json_annotation/json_annotation.dart';
import 'measure_unit.dart';
import 'recipe_ingredient.dart';
import 'freezer.dart';

part 'ingredient.g.dart';

@JsonSerializable(explicitToJson: true)
class Ingredient {
  final int id;
  final String name;
  
  @JsonKey(name: 'caloriesForUnit')
  final double caloriesForUnit;
  
  @JsonKey(name: 'measureUnit')
  final MeasureUnitRef measureUnit;
  
  @JsonKey(name: 'recipeIngredients')
  final List<RecipeIngredient>? recipeIngredients;
  
  @JsonKey(name: 'ingredientFreezer')
  final List<Freezer>? freezerItems;

  Ingredient({
    required this.id,
    required this.name,
    required this.caloriesForUnit,
    required this.measureUnit,
    this.recipeIngredients,
    this.freezerItems,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) => _$IngredientFromJson(json);
  Map<String, dynamic> toJson() => _$IngredientToJson(this);
}

@JsonSerializable()
class MeasureUnitRef {
  final int id;

  MeasureUnitRef({required this.id});

  factory MeasureUnitRef.fromJson(Map<String, dynamic> json) => _$MeasureUnitRefFromJson(json);
  Map<String, dynamic> toJson() => _$MeasureUnitRefToJson(this);
}