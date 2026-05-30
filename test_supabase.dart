import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  print('Initializing Supabase...');
  await Supabase.initialize(
    url: 'https://jdmnfluhrdiagqpjwuwq.supabase.co',
    anonKey: 'sb_publishable_TMiGczkZAz_Mo0olitptuQ_i6gu-2xa',
  );

  final supabase = Supabase.instance.client;

  print('Testing Supabase query...');
  try {
    final data = await supabase.from('ingredients').select();
    print('SUCCESS! Retrieved ${data.length} ingredients.');
    if (data.isNotEmpty) {
      print('First ingredient: ${data[0]['name']}');
    }
    
    print('Testing insertion into pantry_items...');
    // test insert with a fake UUID
    final fakeUserId = '00000000-0000-0000-0000-000000000000';
    
    // We need an ingredient ID
    if (data.isNotEmpty) {
      final ingredientId = data[0]['id'];
      await supabase.from('pantry_items').insert({
        'user_id': fakeUserId,
        'ingredient_id': ingredientId,
        'quantity': 10,
        'unit': 'gram',
      });
      print('SUCCESS! Inserted pantry item.');
    } else {
      print('No ingredients to link to.');
    }
  } catch (e) {
    print('ERROR: $e');
  }
}
