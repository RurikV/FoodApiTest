// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: (json['id'] as num).toInt(),
      text: json['text'] as String,
      photo: json['photo'] as String,
      datetime: json['datetime'] as String,
      user: UserRef.fromJson(json['user'] as Map<String, dynamic>),
      recipe: RecipeRef.fromJson(json['recipe'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'photo': instance.photo,
      'datetime': instance.datetime,
      'user': instance.user.toJson(),
      'recipe': instance.recipe.toJson(),
    };

UserRef _$UserRefFromJson(Map<String, dynamic> json) => UserRef(
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$UserRefToJson(UserRef instance) => <String, dynamic>{
      'id': instance.id,
    };

RecipeRef _$RecipeRefFromJson(Map<String, dynamic> json) => RecipeRef(
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$RecipeRefToJson(RecipeRef instance) => <String, dynamic>{
      'id': instance.id,
    };
