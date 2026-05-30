import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/pantry_item.dart';
import '../../domain/models/ingredient.dart';
import '../../core/auth/device_auth_service.dart';

final pantryRepositoryProvider = Provider<PantryRepository>((ref) {
  final supabase = Supabase.instance.client;
  final deviceAuth = ref.watch(deviceAuthProvider);
  return PantryRepository(supabase, deviceAuth.userId);
});

class PantryRepository {
  final SupabaseClient _supabase;
  final String _userId;

  PantryRepository(this._supabase, this._userId);

  Future<List<PantryItem>> getPantryItems() async {
    final data = await _supabase
        .from('pantry_items')
        .select('*, ingredients(*)')
        .eq('user_id', _userId)
        .order('created_at', ascending: false);
    
    return data.map((json) => PantryItem.fromJson(json)).toList();
  }

  Future<List<Ingredient>> getAllIngredients() async {
    final data = await _supabase
        .from('ingredients')
        .select('*')
        .order('name');
    return data.map((json) => Ingredient.fromJson(json)).toList();
  }

  Future<void> addPantryItem(String ingredientId, double quantity, String unit, DateTime? expiredAt) async {
    final response = await _supabase.from('pantry_items').insert({
      'user_id': _userId,
      'ingredient_id': ingredientId,
      'quantity': quantity,
      'unit': unit,
      'expired_at': expiredAt?.toIso8601String(),
    }).select();
    
    if (response.isEmpty) {
      throw Exception('Data gagal tersimpan di Supabase (response kosong)');
    }
  }

  Future<void> deletePantryItem(String id) async {
    await _supabase
        .from('pantry_items')
        .delete()
        .eq('id', id)
        .eq('user_id', _userId); // Ensure user owns it
  }
}
