// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ingredient _$IngredientFromJson(Map<String, dynamic> json) => Ingredient(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      caloriesForUnit: (json['caloriesForUnit'] as num).toDouble(),
      measureUnit:
          MeasureUnitRef.fromJson(json['measureUnit'] as Map<String, dynamic>),
      recipeIngredients: (json['recipeIngredients'] as List<dynamic>?)
          ?.map((e) => RecipeIngredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      freezerItems: (json['ingredientFreezer'] as List<dynamic>?)
          ?.map((e) => Freezer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$IngredientToJson(Ingredient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'caloriesForUnit': instance.caloriesForUnit,
      'measureUnit': instance.measureUnit.toJson(),
      'recipeIngredients':
          instance.recipeIngredients?.map((e) => e.toJson()).toList(),
      'ingredientFreezer':
          instance.freezerItems?.map((e) => e.toJson()).toList(),
    };

MeasureUnitRef _$MeasureUnitRefFromJson(Map<String, dynamic> json) =>
    MeasureUnitRef(
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$MeasureUnitRefToJson(MeasureUnitRef instance) =>
    <String, dynamic>{
      'id': instance.id,
    };
