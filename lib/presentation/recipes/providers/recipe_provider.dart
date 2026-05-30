import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/recipe.dart';
import '../../../data/repositories/recipe_repository.dart';

final recipesProvider = AsyncNotifierProvider<RecipesNotifier, List<Recipe>>(() {
  return RecipesNotifier();
});

class RecipesNotifier extends AsyncNotifier<List<Recipe>> {
  @override
  Future<List<Recipe>> build() async {
    return _fetchRecipes();
  }

  Future<List<Recipe>> _fetchRecipes() async {
    final repository = ref.read(recipeRepositoryProvider);
    return repository.getRecipes();
  }

  Future<void> addRecipe(
    String title,
    int servings,
    int cookingTime,
    int? calories,
    List<Map<String, dynamic>> ingredients,
    List<String> steps,
  ) async {
    final repository = ref.read(recipeRepositoryProvider);
    state = const AsyncValue.loading();
    try {
      await repository.saveRecipe(title, servings, cookingTime, calories, ingredients, steps);
      state = AsyncValue.data(await _fetchRecipes());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> deleteRecipe(String recipeId) async {
    final repository = ref.read(recipeRepositoryProvider);
    state = const AsyncValue.loading();
    try {
      await repository.deleteRecipe(recipeId);
      state = AsyncValue.data(await _fetchRecipes());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
