import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/ai_recipe.dart';
import '../../domain/models/ai_request.dart';
import '../../domain/repositories/i_ai_repository.dart';

class AIRepository implements IAIRepository {
  final SupabaseClient _supabaseClient;

  AIRepository(this._supabaseClient);

  @override
  Future<AIRecipe> generateRecipe(AIRecipeGenerationRequest request) async {
    final response = await _supabaseClient.functions.invoke(
      'ai_chat',
      body: {
        'intent': 'recipe_generation',
        'payload': request.toJson(),
      },
    );

    if (response.status != 200) {
      throw Exception('Failed to generate recipe: ${response.data}');
    }

    // Response data is already parsed as JSON by Supabase client (usually a Map)
    final Map<String, dynamic> data = response.data as Map<String, dynamic>;
    if (data.containsKey('error')) {
      throw Exception('AI Error: ${data['error']}');
    }

    return AIRecipe.fromJson(data);
  }

  @override
  Future<AIRecipe> modifyRecipe(AIRecipeModificationRequest request) async {
    final response = await _supabaseClient.functions.invoke(
      'ai_chat',
      body: {
        'intent': 'recipe_modification',
        'payload': request.toJson(),
      },
    );

    if (response.status != 200) {
      throw Exception('Failed to modify recipe: ${response.data}');
    }

    final Map<String, dynamic> data = response.data as Map<String, dynamic>;
    if (data.containsKey('error')) {
      throw Exception('AI Error: ${data['error']}');
    }

    return AIRecipe.fromJson(data);
  }

  @override
  Future<List<String>> getIngredientSubstitution(AIIngredientSubstitutionRequest request) async {
    final response = await _supabaseClient.functions.invoke(
      'ai_chat',
      body: {
        'intent': 'ingredient_substitution',
        'payload': request.toJson(),
      },
    );

    if (response.status != 200) {
      throw Exception('Failed to get substitution: ${response.data}');
    }

    final Map<String, dynamic> data = response.data as Map<String, dynamic>;
    if (data.containsKey('error')) {
      throw Exception('AI Error: ${data['error']}');
    }

    final List<dynamic> alternatives = data['alternatives'] ?? [];
    return alternatives.map((e) => e.toString()).toList();
  }

  @override
  Future<String> askCookingAssistant(String question) async {
    final response = await _supabaseClient.functions.invoke(
      'ai_chat',
      body: {
        'intent': 'cooking_assistant',
        'payload': {'question': question},
      },
    );

    if (response.status != 200) {
      throw Exception('Failed to get answer: ${response.data}');
    }

    final Map<String, dynamic> data = response.data as Map<String, dynamic>;
    if (data.containsKey('error')) {
      throw Exception('AI Error: ${data['error']}');
    }

    return data['answer'] ?? '';
  }
}
