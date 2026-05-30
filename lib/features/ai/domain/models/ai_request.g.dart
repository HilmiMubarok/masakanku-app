// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AIRecipeGenerationRequest _$AIRecipeGenerationRequestFromJson(
  Map<String, dynamic> json,
) => AIRecipeGenerationRequest(
  ingredients: (json['ingredients'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  servings: (json['servings'] as num).toInt(),
  cookingTime: (json['cooking_time'] as num).toInt(),
  difficulty: json['difficulty'] as String,
);

Map<String, dynamic> _$AIRecipeGenerationRequestToJson(
  AIRecipeGenerationRequest instance,
) => <String, dynamic>{
  'ingredients': instance.ingredients,
  'servings': instance.servings,
  'cooking_time': instance.cookingTime,
  'difficulty': instance.difficulty,
};

AIRecipeModificationRequest _$AIRecipeModificationRequestFromJson(
  Map<String, dynamic> json,
) => AIRecipeModificationRequest(
  recipeId: json['recipe_id'] as String,
  instruction: json['instruction'] as String,
);

Map<String, dynamic> _$AIRecipeModificationRequestToJson(
  AIRecipeModificationRequest instance,
) => <String, dynamic>{
  'recipe_id': instance.recipeId,
  'instruction': instance.instruction,
};

AIIngredientSubstitutionRequest _$AIIngredientSubstitutionRequestFromJson(
  Map<String, dynamic> json,
) => AIIngredientSubstitutionRequest(ingredient: json['ingredient'] as String);

Map<String, dynamic> _$AIIngredientSubstitutionRequestToJson(
  AIIngredientSubstitutionRequest instance,
) => <String, dynamic>{'ingredient': instance.ingredient};
