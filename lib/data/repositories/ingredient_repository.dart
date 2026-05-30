import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/ingredient.dart';

final ingredientRepositoryProvider = Provider<IngredientRepository>((ref) {
  final supabase = Supabase.instance.client;
  return IngredientRepository(supabase);
});

class IngredientRepository {
  final SupabaseClient _supabase;

  IngredientRepository(this._supabase);

  Future<List<Ingredient>> getIngredients() async {
    final data = await _supabase
        .from('ingredients')
        .select('*')
        .order('name');
    return data.map((json) => Ingredient.fromJson(json)).toList();
  }

  Future<void> addIngredient(String name, String? category) async {
    await _supabase.from('ingredients').insert({
      'name': name,
      'category': category,
    });
  }

  Future<void> updateIngredient(String id, String name, String? category) async {
    await _supabase.from('ingredients').update({
      'name': name,
      'category': category,
    }).eq('id', id);
  }

  Future<void> deleteIngredient(String id) async {
    await _supabase.from('ingredients').delete().eq('id', id);
  }
}
