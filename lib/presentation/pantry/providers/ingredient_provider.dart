import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/ingredient.dart';
import '../../../data/repositories/ingredient_repository.dart';

final ingredientProvider = AsyncNotifierProvider<IngredientNotifier, List<Ingredient>>(() {
  return IngredientNotifier();
});

class IngredientNotifier extends AsyncNotifier<List<Ingredient>> {
  @override
  Future<List<Ingredient>> build() async {
    return _fetchIngredients();
  }

  Future<List<Ingredient>> _fetchIngredients() async {
    final repository = ref.read(ingredientRepositoryProvider);
    return repository.getIngredients();
  }

  Future<void> addIngredient(String name, String? category) async {
    final repository = ref.read(ingredientRepositoryProvider);
    state = const AsyncValue.loading();
    try {
      await repository.addIngredient(name, category);
      state = AsyncValue.data(await _fetchIngredients());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> updateIngredient(String id, String name, String? category) async {
    final repository = ref.read(ingredientRepositoryProvider);
    state = const AsyncValue.loading();
    try {
      await repository.updateIngredient(id, name, category);
      state = AsyncValue.data(await _fetchIngredients());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> deleteIngredient(String id) async {
    final repository = ref.read(ingredientRepositoryProvider);
    final currentItems = state.value ?? [];
    state = AsyncValue.data(currentItems.where((item) => item.id != id).toList());
    
    try {
      await repository.deleteIngredient(id);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      ref.invalidateSelf();
    }
  }
}
