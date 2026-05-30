import 'package:json_annotation/json_annotation.dart';

part 'ai_recipe.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AIRecipe {
  final String title;
  final String description;
  final int servings;
  final int cookingTimeMinutes;
  final String difficulty;
  final List<AIIngredient> ingredients;
  final List<AIStep> steps;

  const AIRecipe({
    required this.title,
    required this.description,
    required this.servings,
    required this.cookingTimeMinutes,
    required this.difficulty,
    required this.ingredients,
    required this.steps,
  });

  factory AIRecipe.fromJson(Map<String, dynamic> json) => _$AIRecipeFromJson(json);
  Map<String, dynamic> toJson() => _$AIRecipeToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AIIngredient {
  final String name;
  final double quantity;
  final String unit;

  const AIIngredient({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  factory AIIngredient.fromJson(Map<String, dynamic> json) => _$AIIngredientFromJson(json);
  Map<String, dynamic> toJson() => _$AIIngredientToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AIStep {
  final int step;
  final String instruction;

  const AIStep({
    required this.step,
    required this.instruction,
  });

  factory AIStep.fromJson(Map<String, dynamic> json) => _$AIStepFromJson(json);
  Map<String, dynamic> toJson() => _$AIStepToJson(this);
}
