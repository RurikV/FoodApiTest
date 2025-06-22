import 'package:json_annotation/json_annotation.dart';
import 'recipe_step_link.dart';

part 'recipe_step.g.dart';

@JsonSerializable(explicitToJson: true)
class RecipeStep {
  final int id;
  final String name;
  final int duration;
  
  @JsonKey(name: 'recipeStepLinks')
  final List<RecipeStepLink>? stepLinks;

  RecipeStep({
    required this.id,
    required this.name,
    required this.duration,
    this.stepLinks,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) => _$RecipeStepFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeStepToJson(this);
}