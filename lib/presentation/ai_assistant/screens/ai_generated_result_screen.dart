import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../recipes/screens/cooking_mode_screen.dart';
import '../../../domain/models/recipe.dart';
import '../../../domain/models/ingredient.dart';
import '../../../features/ai/domain/models/ai_recipe.dart';
import '../../recipes/providers/recipe_provider.dart';

class AIGeneratedResultScreen extends ConsumerStatefulWidget {
  final AIRecipe aiRecipe;
  const AIGeneratedResultScreen({super.key, required this.aiRecipe});

  @override
  ConsumerState<AIGeneratedResultScreen> createState() => _AIGeneratedResultScreenState();
}

class _AIGeneratedResultScreenState extends ConsumerState<AIGeneratedResultScreen> {
  bool _isSaving = false;
  bool _isSaved = false;

  void _saveRecipe() async {
    if (_isSaved) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final aiRecipe = widget.aiRecipe;
      final List<Map<String, dynamic>> ingredientsMap = aiRecipe.ingredients.map((e) => {
        'name': e.name,
        'quantity': e.quantity,
        'unit': e.unit,
      }).toList();
      final stepsList = aiRecipe.steps.map((e) => e.instruction).toList();

      await ref.read(recipesProvider.notifier).addRecipe(
        aiRecipe.title,
        aiRecipe.servings,
        aiRecipe.cookingTimeMinutes,
        aiRecipe.calories,
        aiRecipe.protein,
        aiRecipe.carbs,
        aiRecipe.fat,
        ingredientsMap,
        stepsList,
        source: 'ai',
      );

      setState(() {
        _isSaving = false;
        _isSaved = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resep berhasil disimpan!')),
        );
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan resep: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final aiRecipe = widget.aiRecipe;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: colors.onBackground),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome_rounded, color: colors.mainPink, size: 20),
            const SizedBox(width: 8),
            Text('Resep AI Selesai!', style: textTheme.titleMedium?.copyWith(color: colors.mainPink, fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success Header
            Center(
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: colors.peachAccent.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&w=800&q=80'),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: colors.peachAccent, width: 4),
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            Text(
              aiRecipe.title,
              style: textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            Text(
              aiRecipe.description,
              style: textTheme.bodyLarge?.copyWith(color: colors.outline),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildInfoChip(context, Icons.schedule_rounded, '${aiRecipe.cookingTimeMinutes} mnt', colors),
                const SizedBox(width: 12),
                _buildInfoChip(context, Icons.speed_rounded, aiRecipe.difficulty.toUpperCase(), colors),
              ],
            ),
            const SizedBox(height: 32),
            
            // Ingredients Used Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.matchaGreen.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: colors.matchaGreen.withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.kitchen_rounded, color: colors.matchaGreen),
                      const SizedBox(width: 8),
                      Text('Bahan Kulkas yang Terpakai', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...aiRecipe.ingredients.map((ing) => _buildIngredientItem(context, ing.name, '${ing.quantity} ${ing.unit}', colors)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            if (aiRecipe.calories != null || aiRecipe.protein != null || aiRecipe.carbs != null || aiRecipe.fat != null) ...[
              Text(
                'Kandungan Nutrisi (per porsi)',
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (aiRecipe.calories != null) _buildNutritionBox(context, 'Kalori', aiRecipe.calories.toString(), 'kcal', colors),
                  if (aiRecipe.protein != null) _buildNutritionBox(context, 'Protein', aiRecipe.protein.toString(), 'g', colors),
                  if (aiRecipe.carbs != null) _buildNutritionBox(context, 'Karbo', aiRecipe.carbs.toString(), 'g', colors),
                  if (aiRecipe.fat != null) _buildNutritionBox(context, 'Lemak', aiRecipe.fat.toString(), 'g', colors),
                ],
              ),
              const SizedBox(height: 32),
            ],

            Text(
              'Cara Memasak',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...aiRecipe.steps.map((step) => _buildStepItem(context, step.step.toString(), step.instruction, colors)),
            
            const SizedBox(height: 100), // Space for bottom buttons
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colors.background,
          boxShadow: [
            BoxShadow(
              color: colors.mainPink.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isSaving ? null : _saveRecipe,
                  icon: _isSaving 
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : Icon(_isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded),
                  label: Text(_isSaved ? 'Tersimpan' : 'Simpan'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    foregroundColor: colors.mainPink,
                    side: BorderSide(color: colors.mainPink),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    // Create a temporary Recipe model to pass to CookingModeScreen
                    final tempRecipe = Recipe(
                      id: 'ai-generated-${DateTime.now().millisecondsSinceEpoch}',
                      userId: 'user', 
                      title: aiRecipe.title,
                      description: aiRecipe.description,
                      cookingTime: aiRecipe.cookingTimeMinutes,
                      source: 'ai',
                      calories: aiRecipe.calories,
                      protein: aiRecipe.protein,
                      carbs: aiRecipe.carbs,
                      fat: aiRecipe.fat,
                      servings: aiRecipe.servings,
                      ingredients: aiRecipe.ingredients.map((ing) => RecipeIngredient(
                        id: 'ai-ing-${DateTime.now().millisecondsSinceEpoch}-${ing.name}',
                        recipeId: 'ai-generated',
                        ingredientId: 'ai-ingredient-${ing.name}',
                        ingredient: Ingredient(
                          id: 'ai-ingredient-${ing.name}', 
                          name: ing.name,
                          category: 'Lainnya',
                          icon: 'eco_rounded',
                          color: '#CFE8C6',
                        ),
                        quantity: ing.quantity,
                        unit: ing.unit,
                      )).toList(),
                      steps: aiRecipe.steps.map((step) => RecipeStep(
                        id: 'ai-step-${DateTime.now().millisecondsSinceEpoch}-${step.step}',
                        recipeId: 'ai-generated',
                        stepNumber: step.step,
                        instruction: step.instruction,
                      )).toList(),
                    );
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CookingModeScreen(
                        title: aiRecipe.title,
                        recipe: tempRecipe,
                      )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: colors.mainPink,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Mulai Masak', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label, AppColors colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: colors.outline),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientItem(BuildContext context, String name, String amount, AppColors colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded, size: 16, color: colors.matchaGreen),
          const SizedBox(width: 8),
          Expanded(child: Text(name, style: Theme.of(context).textTheme.bodyMedium)),
          Text(amount, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.outline)),
        ],
      ),
    );
  }

  Widget _buildStepItem(BuildContext context, String number, String text, AppColors colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: colors.mainPink.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: colors.mainPink, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionBox(BuildContext context, String label, String value, String unit, AppColors colors) {
    return Container(
      width: 76,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: colors.outline),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: colors.onBackground),
              ),
              const SizedBox(width: 2),
              Text(
                unit,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
