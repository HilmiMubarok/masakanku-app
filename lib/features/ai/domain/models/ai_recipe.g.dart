// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AIRecipe _$AIRecipeFromJson(Map<String, dynamic> json) => AIRecipe(
  title: json['title'] as String,
  description: json['description'] as String,
  servings: (json['servings'] as num).toInt(),
  cookingTimeMinutes: (json['cooking_time_minutes'] as num).toInt(),
  difficulty: json['difficulty'] as String,
  ingredients: (json['ingredients'] as List<dynamic>)
      .map((e) => AIIngredient.fromJson(e as Map<String, dynamic>))
      .toList(),
  steps: (json['steps'] as List<dynamic>)
      .map((e) => AIStep.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AIRecipeToJson(AIRecipe instance) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'servings': instance.servings,
  'cooking_time_minutes': instance.cookingTimeMinutes,
  'difficulty': instance.difficulty,
  'ingredients': instance.ingredients,
  'steps': instance.steps,
};

AIIngredient _$AIIngredientFromJson(Map<String, dynamic> json) => AIIngredient(
  name: json['name'] as String,
  quantity: (json['quantity'] as num).toDouble(),
  unit: json['unit'] as String,
);

Map<String, dynamic> _$AIIngredientToJson(AIIngredient instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'unit': instance.unit,
    };

AIStep _$AIStepFromJson(Map<String, dynamic> json) => AIStep(
  step: (json['step'] as num).toInt(),
  instruction: json['instruction'] as String,
);

Map<String, dynamic> _$AIStepToJson(AIStep instance) => <String, dynamic>{
  'step': instance.step,
  'instruction': instance.instruction,
};
