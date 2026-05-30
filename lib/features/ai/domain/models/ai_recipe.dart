class AIRecipe {
  final String title;
  final String description;
  final int servings;
  final int cookingTimeMinutes;
  final String difficulty;
  final int? calories;
  final int? protein;
  final int? carbs;
  final int? fat;
  final List<AIIngredient> ingredients;
  final List<AIStep> steps;

  const AIRecipe({
    required this.title,
    required this.description,
    required this.servings,
    required this.cookingTimeMinutes,
    required this.difficulty,
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
    required this.ingredients,
    required this.steps,
  });

  factory AIRecipe.fromJson(Map<String, dynamic> json) {
    return AIRecipe(
      title: json['title'] as String? ?? 'Resep Lezat',
      description: json['description'] as String? ?? 'Resep spesial untukmu.',
      servings: (json['servings'] as num?)?.toInt() ?? 2,
      cookingTimeMinutes: (json['cooking_time_minutes'] as num?)?.toInt() ?? 30,
      difficulty: json['difficulty'] as String? ?? 'mudah',
      calories: (json['calories'] as num?)?.toInt(),
      protein: (json['protein'] as num?)?.toInt(),
      carbs: (json['carbs'] as num?)?.toInt(),
      fat: (json['fat'] as num?)?.toInt(),
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) {
                if (e is String) {
                  return AIIngredient(name: e, quantity: 1.0, unit: 'secukupnya');
                }
                return AIIngredient.fromJson(e as Map<String, dynamic>);
              })
              .toList() ??
          [],
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) {
                if (e is String) {
                  return AIStep(step: 1, instruction: e);
                }
                return AIStep.fromJson(e as Map<String, dynamic>);
              })
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'servings': servings,
        'cooking_time_minutes': cookingTimeMinutes,
        'difficulty': difficulty,
        'ingredients': ingredients.map((e) => e.toJson()).toList(),
        'steps': steps.map((e) => e.toJson()).toList(),
      };
}

class AIIngredient {
  final String name;
  final double quantity;
  final String unit;

  const AIIngredient({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  factory AIIngredient.fromJson(Map<String, dynamic> json) {
    return AIIngredient(
      name: json['name'] as String? ?? 'Bahan rahasia',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 1.0,
      unit: json['unit'] as String? ?? 'secukupnya',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'unit': unit,
      };
}

class AIStep {
  final int step;
  final String instruction;

  const AIStep({
    required this.step,
    required this.instruction,
  });

  factory AIStep.fromJson(Map<String, dynamic> json) {
    return AIStep(
      step: (json['step'] as num?)?.toInt() ?? 1,
      instruction: json['instruction'] as String? ?? 'Lakukan langkah ini',
    );
  }

  Map<String, dynamic> toJson() => {
        'step': step,
        'instruction': instruction,
      };
}
