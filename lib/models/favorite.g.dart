// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Favorite _$FavoriteFromJson(Map<String, dynamic> json) => Favorite(
      id: (json['id'] as num).toInt(),
      recipe: RecipeRef.fromJson(json['recipe'] as Map<String, dynamic>),
      user: UserRef.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FavoriteToJson(Favorite instance) => <String, dynamic>{
      'id': instance.id,
      'recipe': instance.recipe.toJson(),
      'user': instance.user.toJson(),
    };

RecipeRef _$RecipeRefFromJson(Map<String, dynamic> json) => RecipeRef(
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$RecipeRefToJson(RecipeRef instance) => <String, dynamic>{
      'id': instance.id,
    };

UserRef _$UserRefFromJson(Map<String, dynamic> json) => UserRef(
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$UserRefToJson(UserRef instance) => <String, dynamic>{
      'id': instance.id,
    };
