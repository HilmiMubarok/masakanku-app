import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/ai_recipe.dart';
import '../../domain/models/ai_request.dart';
import '../../domain/repositories/i_ai_repository.dart';

class AIRepository implements IAIRepository {
  final SupabaseClient _supabaseClient;

  AIRepository(this._supabaseClient);

  Map<String, dynamic> _parseResponseData(dynamic data) {
    if (data is String) {
      try {
        data = jsonDecode(data);
      } catch (e) {
        // Handle cases where the AI might wrap the response in markdown like ```json ... ```
        final match = RegExp(r'```json\n([\s\S]*?)\n```').firstMatch(data as String);
        if (match != null) {
          data = jsonDecode(match.group(1)!);
        } else {
          throw Exception('Failed to decode AI response string: $data');
        }
      }
    }
    
    if (data is! Map<String, dynamic>) {
      throw Exception('Expected a Map but got ${data.runtimeType} from AI');
    }
    
    if (data.containsKey('error')) {
      throw Exception('AI Error: ${data['error']}');
    }
    
    return data;
  }

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

    final data = _parseResponseData(response.data);
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

    final data = _parseResponseData(response.data);
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

    final data = _parseResponseData(response.data);
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

    final data = _parseResponseData(response.data);
    return data['answer'] ?? '';
  }
}
