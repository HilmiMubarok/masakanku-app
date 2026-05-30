import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/recipe.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/recipe_provider.dart';
import 'cooking_mode_screen.dart';

class RecipeDetailScreen extends ConsumerWidget {
  const RecipeDetailScreen({
    super.key,
    required this.recipe,
    required this.title,
    required this.time,
    required this.calories,
    required this.imageColor,
    required this.icon,
    this.imageUrl,
  });

  final Recipe recipe;
  final String title;
  final String time;
  final String calories;
  final Color imageColor;
  final IconData icon;
  final String? imageUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: imageColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              if (recipe.id != 'dummy')
                IconButton(
                  icon: const Icon(Icons.delete_rounded, color: Colors.white),
                  onPressed: () => _showDeleteConfirmation(context, ref),
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: imageColor.withValues(alpha: 0.3)),
                  if (imageUrl != null)
                    Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(icon, size: 100, color: imageColor.withValues(alpha: 0.8)),
                      ),
                    )
                  else
                    Center(
                      child: Icon(icon, size: 100, color: imageColor.withValues(alpha: 0.8)),
                    ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 80,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            colors.background,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildInfoChip(context, Icons.schedule_rounded, time, colors),
                      const SizedBox(width: 12),
                      _buildInfoChip(context, Icons.local_fire_department_rounded, calories, colors),
                      const SizedBox(width: 12),
                      _buildInfoChip(context, Icons.restaurant_rounded, '2 Porsi', colors),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Bahan-bahan',
                    style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  if (recipe.ingredients != null && recipe.ingredients!.isNotEmpty)
                    ...recipe.ingredients!.map((ing) => _buildIngredientItem(
                          context, 
                          ing.ingredient?.name ?? 'Bahan Tidak Diketahui', 
                          '${ing.quantity ?? ''} ${ing.unit ?? ''}'.trim(), 
                          colors
                        ))
                  else
                    const Text('Tidak ada bahan-bahan.'),
                  
                  if (recipe.calories != null) ...[
                    const SizedBox(height: 32),
                    Text(
                      'Kandungan Nutrisi (per porsi)',
                      style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildNutritionBox(context, 'Kalori', recipe.calories.toString(), 'kcal', colors),
                      ],
                    ),
                  ],
                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
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
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CookingModeScreen(
                    title: title,
                    recipe: recipe,
                  )),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.mainPink,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Mulai Masak', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label, AppColors colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colors.outline),
          const SizedBox(width: 6),
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(Icons.fiber_manual_record, size: 8, color: colors.mainPink),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Text(
            amount,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.outline),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Hapus Resep?'),
          content: Text('Apakah kamu yakin ingin menghapus resep "$title"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                ref.read(recipesProvider.notifier).deleteRecipe(recipe.id);
                Navigator.pop(context); // Close detail screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Resep berhasil dihapus')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
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
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: colors.outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
