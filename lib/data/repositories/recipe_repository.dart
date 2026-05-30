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
          recipe_steps (*),
          recipe_nutrition (*)
        ''')
        .eq('user_id', _userId)
        .order('created_at', ascending: false);
        
    return data.map((json) => Recipe.fromJson(json)).toList();
  }

  Future<void> saveRecipe(
    String title,
    int servings,
    int cookingTime,
    int? calories,
    int? protein,
    int? carbs,
    int? fat,
    List<Map<String, dynamic>> ingredients,
    List<String> steps, {
    String source = 'manual',
  }) async {
    // 1. Insert resep
    final recipeRes = await _supabase.from('recipes').insert({
      'user_id': _userId,
      'title': title,
      'servings': servings,
      'cooking_time': cookingTime,
      'source': source,
    }).select();

    if (recipeRes.isEmpty) {
      throw Exception('Gagal menyimpan resep utama');
    }

    final recipeId = recipeRes.first['id'];

    // 2. Insert nutrisi jika ada data nutrisi
    if (calories != null || protein != null || carbs != null || fat != null) {
      await _supabase.from('recipe_nutrition').insert({
        'recipe_id': recipeId,
        if (calories != null) 'calories': calories,
        if (protein != null) 'protein': protein,
        if (carbs != null) 'carbohydrate': carbs,
        if (fat != null) 'fat': fat,
      });
    }

    // 3. Insert bahan (ingredients & recipe_ingredients)
    for (final ing in ingredients) {
      final ingName = ing['name'] as String;
      final quantity = ing['quantity'] as double;
      final unit = ing['unit'] as String;

      // Cek apakah ingredient dengan nama ini sudah ada (case-insensitive)
      final existingIng = await _supabase
          .from('ingredients')
          .select('id')
          .ilike('name', ingName)
          .limit(1);

      String ingredientId;
      if (existingIng.isNotEmpty) {
        ingredientId = existingIng.first['id'];
      } else {
        // Insert bahan baru
        final newIng = await _supabase.from('ingredients').insert({
          'name': ingName,
          'category': 'Lainnya',
          'icon': 'eco_rounded',
          'color': '#CFE8C6',
        }).select();
        ingredientId = newIng.first['id'];
      }

      // Hubungkan ke resep
      await _supabase.from('recipe_ingredients').insert({
        'recipe_id': recipeId,
        'ingredient_id': ingredientId,
        'quantity': quantity,
        'unit': unit,
      });
    }

    // 4. Insert steps
    final stepsToInsert = steps.asMap().entries.map((entry) {
      return {
        'recipe_id': recipeId,
        'step_number': entry.key + 1,
        'instruction': entry.value,
      };
    }).toList();

    if (stepsToInsert.isNotEmpty) {
      await _supabase.from('recipe_steps').insert(stepsToInsert);
    }
  }

  Future<void> deleteRecipe(String recipeId) async {
    await _supabase.from('recipes').delete().eq('id', recipeId).eq('user_id', _userId);
  }
}
