import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/ai_recipe.dart';
import '../domain/models/ai_request.dart';
import 'ai_provider.dart';

final aiRecipeGeneratorProvider = AsyncNotifierProvider<AIRecipeGeneratorNotifier, AIRecipe?>(() {
  return AIRecipeGeneratorNotifier();
});

class AIRecipeGeneratorNotifier extends AsyncNotifier<AIRecipe?> {
  @override
  Future<AIRecipe?> build() async {
    return null; // Initial state is null (no recipe generated yet)
  }

  Future<AIRecipe> generateRecipe(List<String> ingredients) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(aiRepositoryProvider);
      final request = AIRecipeGenerationRequest(
        ingredients: ingredients,
        servings: 2, // Default serving size for MVP
        cookingTime: 30, // Default max cooking time
        difficulty: 'easy',
      );
      
      final recipe = await repository.generateRecipe(request);
      state = AsyncValue.data(recipe);
      return recipe;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
