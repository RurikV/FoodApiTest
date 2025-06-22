// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeIngredient _$RecipeIngredientFromJson(Map<String, dynamic> json) =>
    RecipeIngredient(
      id: json['id'] == null ? null : (json['id'] as num).toInt(),
      count: (json['count'] as num).toInt(),
      ingredient:
          IngredientRef.fromJson(json['ingredient'] as Map<String, dynamic>),
      recipe: RecipeRef.fromJson(json['recipe'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RecipeIngredientToJson(RecipeIngredient instance) {
    final json = <String, dynamic>{
      'count': instance.count,
      'ingredient': instance.ingredient.toJson(),
      'recipe': instance.recipe.toJson(),
    };

    if (instance.id != null) {
      json['id'] = instance.id;
    }

    return json;
  }

IngredientRef _$IngredientRefFromJson(Map<String, dynamic> json) =>
    IngredientRef(
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$IngredientRefToJson(IngredientRef instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

RecipeRef _$RecipeRefFromJson(Map<String, dynamic> json) => RecipeRef(
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$RecipeRefToJson(RecipeRef instance) => <String, dynamic>{
      'id': instance.id,
    };
