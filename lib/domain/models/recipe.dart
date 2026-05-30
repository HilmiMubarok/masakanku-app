import 'ingredient.dart';

class Recipe {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final int servings;
  final int cookingTime;
  final String? source;
  final List<RecipeIngredient> ingredients;
  final List<RecipeStep> steps;

  Recipe({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.servings,
    required this.cookingTime,
    this.source,
    this.ingredients = const [],
    this.steps = const [],
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      servings: json['servings'] as int? ?? 1,
      cookingTime: json['cooking_time'] as int? ?? 0,
      source: json['source'] as String?,
      ingredients: (json['recipe_ingredients'] as List<dynamic>?)
              ?.map((e) => RecipeIngredient.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      steps: (json['recipe_steps'] as List<dynamic>?)
              ?.map((e) => RecipeStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class RecipeIngredient {
  final String id;
  final String recipeId;
  final String ingredientId;
  final Ingredient? ingredient;
  final double quantity;
  final String unit;

  RecipeIngredient({
    required this.id,
    required this.recipeId,
    required this.ingredientId,
    this.ingredient,
    required this.quantity,
    required this.unit,
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      id: json['id'] as String,
      recipeId: json['recipe_id'] as String,
      ingredientId: json['ingredient_id'] as String,
      ingredient: json['ingredients'] != null
          ? Ingredient.fromJson(json['ingredients'] as Map<String, dynamic>)
          : null,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit'] as String? ?? '',
    );
  }
}

class RecipeStep {
  final String id;
  final String recipeId;
  final int stepNumber;
  final String instruction;

  RecipeStep({
    required this.id,
    required this.recipeId,
    required this.stepNumber,
    required this.instruction,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
      id: json['id'] as String,
      recipeId: json['recipe_id'] as String,
      stepNumber: json['step_number'] as int,
      instruction: json['instruction'] as String,
    );
  }
}
