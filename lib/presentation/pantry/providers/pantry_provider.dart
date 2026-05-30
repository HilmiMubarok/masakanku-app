import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/pantry_item.dart';
import '../../../data/repositories/pantry_repository.dart';
import '../../../domain/models/ingredient.dart';

final pantryProvider = AsyncNotifierProvider<PantryNotifier, List<PantryItem>>(() {
  return PantryNotifier();
});

class PantryNotifier extends AsyncNotifier<List<PantryItem>> {
  @override
  Future<List<PantryItem>> build() async {
    return _fetchItems();
  }

  Future<List<PantryItem>> _fetchItems() async {
    final repository = ref.read(pantryRepositoryProvider);
    return repository.getPantryItems();
  }

  Future<void> addItem(String ingredientId, double quantity, String unit, DateTime? expiredAt) async {
    final repository = ref.read(pantryRepositoryProvider);
    state = const AsyncValue.loading();
    try {
      await repository.addPantryItem(ingredientId, quantity, unit, expiredAt);
      state = AsyncValue.data(await _fetchItems());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> deleteItem(String id) async {
    final repository = ref.read(pantryRepositoryProvider);
    // Optimistic update
    final currentItems = state.value ?? [];
    state = AsyncValue.data(currentItems.where((item) => item.id != id).toList());
    
    try {
      await repository.deletePantryItem(id);
    } catch (e, st) {
      // Revert on failure
      state = AsyncValue.error(e, st);
      ref.invalidateSelf();
    }
  }
}


