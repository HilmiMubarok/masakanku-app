import 'package:json_annotation/json_annotation.dart';

part 'ai_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AIRecipeGenerationRequest {
  final List<String> ingredients;
  final int servings;
  final int cookingTime;
  final String difficulty;

  const AIRecipeGenerationRequest({
    required this.ingredients,
    required this.servings,
    required this.cookingTime,
    required this.difficulty,
  });

  Map<String, dynamic> toJson() => _$AIRecipeGenerationRequestToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AIRecipeModificationRequest {
  final String recipeId;
  final String instruction;

  const AIRecipeModificationRequest({
    required this.recipeId,
    required this.instruction,
  });

  Map<String, dynamic> toJson() => _$AIRecipeModificationRequestToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AIIngredientSubstitutionRequest {
  final String ingredient;

  const AIIngredientSubstitutionRequest({
    required this.ingredient,
  });

  Map<String, dynamic> toJson() => _$AIIngredientSubstitutionRequestToJson(this);
}
