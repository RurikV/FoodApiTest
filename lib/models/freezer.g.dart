// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'freezer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Freezer _$FreezerFromJson(Map<String, dynamic> json) => Freezer(
      id: (json['id'] as num).toInt(),
      count: (json['count'] as num).toDouble(),
      user: UserRef.fromJson(json['user'] as Map<String, dynamic>),
      ingredient:
          IngredientRef.fromJson(json['ingredient'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FreezerToJson(Freezer instance) => <String, dynamic>{
      'id': instance.id,
      'count': instance.count,
      'user': instance.user.toJson(),
      'ingredient': instance.ingredient.toJson(),
    };

UserRef _$UserRefFromJson(Map<String, dynamic> json) => UserRef(
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$UserRefToJson(UserRef instance) => <String, dynamic>{
      'id': instance.id,
    };

IngredientRef _$IngredientRefFromJson(Map<String, dynamic> json) =>
    IngredientRef(
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$IngredientRefToJson(IngredientRef instance) =>
    <String, dynamic>{
      'id': instance.id,
    };
