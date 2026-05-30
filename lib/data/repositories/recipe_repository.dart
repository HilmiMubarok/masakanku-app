import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/recipe.dart';
import '../../core/auth/device_auth_service.dart';

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  final supabase = Supabase.instance.client;
  final deviceAuth = ref.watch(deviceAuthProvider);
  return RecipeRepository(supabase, deviceAuth.userId);
});

class RecipeRepository {
  final SupabaseClient _supabase;
  final String _userId;

  RecipeRepository(this._supabase, this._userId);

  Future<List<Recipe>> getRecipes() async {
    final data = await _supabase
        .from('recipes')
        .select('''
          *,
          recipe_ingredients (
            *,
            ingredients (*)
          ),
          recipe_steps (*)
        ''')
        .eq('user_id', _userId)
        .order('created_at', ascending: false);
        
    return data.map((json) => Recipe.fromJson(json)).toList();
  }

  // A basic save recipe function for manual recipes (MVP)
  Future<void> saveRecipe(String title, int servings, int cookingTime) async {
    await _supabase.from('recipes').insert({
      'user_id': _userId,
      'title': title,
      'servings': servings,
      'cooking_time': cookingTime,
      'source': 'manual',
    });
  }
}
