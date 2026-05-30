import '../models/ai_recipe.dart';
import '../models/ai_request.dart';

abstract class IAIRepository {
  /// Generate a recipe based on ingredients, servings, time, and difficulty.
  Future<AIRecipe> generateRecipe(AIRecipeGenerationRequest request);

  /// Modify an existing recipe based on an instruction.
  Future<AIRecipe> modifyRecipe(AIRecipeModificationRequest request);

  /// Get ingredient substitutions.
  Future<List<String>> getIngredientSubstitution(AIIngredientSubstitutionRequest request);

  /// Ask a cooking question.
  Future<String> askCookingAssistant(String question);
}
