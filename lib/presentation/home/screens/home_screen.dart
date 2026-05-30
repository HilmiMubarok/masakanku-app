import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../recipes/widgets/recipe_card.dart';
import '../../../domain/models/recipe.dart';
import '../../pantry/providers/pantry_provider.dart';
import '../../recipes/providers/recipe_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    final pantryState = ref.watch(pantryProvider);
    final recipeState = ref.watch(recipesProvider);

    String pantryText = 'Lagi ngecek kulkas...';
    pantryState.when(
      data: (items) {
        if (items.isEmpty) {
          pantryText = 'Kulkas kamu kosong nih! Yuk isi dulu biar bisa masak enak.';
        } else {
          final names = items.take(3).map((e) => e.ingredient?.name ?? 'Bahan').join(', ');
          final more = items.length > 3 ? ' dkk' : '';
          pantryText = 'Stok kamu ada $names$more nih. Sini aku bantuin racik 3 ide menu!';
        }
      },
      loading: () => pantryText = 'Lagi ngecek kulkas...',
      error: (_, __) => pantryText = 'Gagal mengecek isi kulkas.',
    );

    List<Recipe> recentRecipes = [];
    recipeState.whenData((recipes) {
      recentRecipes = List.from(recipes);
      recentRecipes = recentRecipes.reversed.take(5).toList();
    });

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Haloo, Hilmi',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colors.bodyText.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Hari ini mau masak apa nih?',
                        style: textTheme.headlineLarge,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                CircleAvatar(
                  backgroundColor: colors.lavenderAccent,
                  backgroundImage: const NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80'),
                  radius: 24,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Smart AI Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colors.mainPink.withValues(alpha: 0.1),
                    colors.peachAccent.withValues(alpha: 0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: colors.mainPink.withValues(alpha: 0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: colors.matchaGreen.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(Icons.auto_awesome_rounded, color: colors.matchaGreen, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '"$pantryText"',
                          style: textTheme.bodyLarge?.copyWith(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                            color: colors.bodyText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Silakan buka tab Kulkas dan tekan tombol Magic AI untuk membuat resep!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.mainPink,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: colors.mainPink.withValues(alpha: 0.4),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.auto_awesome_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Bikinin Resep Dong',
                            style: textTheme.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Quick Suggestions Title
            Text(
              'Bisa Dicoba Nih',
              style: textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),

            // Quick Suggestions List
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                children: [
                  _QuickSuggestionCard(
                    color: colors.peachAccent,
                    icon: Icons.egg_alt_rounded,
                    title: 'Masak sat-set',
                    subtitle: 'Cuma 15 menitan',
                  ),
                  const SizedBox(width: 16),
                  _QuickSuggestionCard(
                    color: colors.matchaGreen,
                    icon: Icons.spa_rounded,
                    title: 'Healthy vibes',
                    subtitle: 'Biar tetep slay',
                  ),
                  const SizedBox(width: 16),
                  _QuickSuggestionCard(
                    color: colors.lavenderAccent,
                    icon: Icons.ramen_dining_rounded,
                    title: 'Comfort food',
                    subtitle: 'Anget-anget enak',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Today's Pick Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Resep Terbarumu',
                  style: textTheme.headlineMedium,
                ),
                if (recentRecipes.isNotEmpty)
                  Icon(Icons.arrow_forward_rounded, color: colors.outlineVariant),
              ],
            ),
            const SizedBox(height: 16),

            // Recipe Carousel
            recipeState.when(
              data: (_) {
                if (recentRecipes.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.3)),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.menu_book_rounded, size: 48, color: colors.outlineVariant),
                          const SizedBox(height: 16),
                          Text(
                            'Belum ada resep tersimpan.\nCoba minta AI bikinin resep yuk!',
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium?.copyWith(color: colors.outline),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SizedBox(
                  height: 240,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    itemCount: recentRecipes.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final recipe = recentRecipes[index];
                      // Adjust width so we can see part of the next card
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: RecipeCard(
                          recipe: recipe,
                          title: recipe.title,
                          time: '${recipe.cookingTime} mnt',
                          calories: recipe.calories != null ? '${recipe.calories} kcal' : '-',
                          isGeneratedByAI: recipe.source == 'ai',
                          imageColor: index % 2 == 0 ? colors.secondaryPink : colors.lavenderAccent,
                          icon: Icons.set_meal_rounded,
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Gagal memuat resep: $err')),
            ),
            const SizedBox(height: 32),

            // Daily Kitchen Tips
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.lavenderAccent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.lavenderAccent.withValues(alpha: 0.5)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb_outline_rounded, color: colors.lavenderAccent, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tips Dapur Hari Ini',
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.onBackground,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Biar mata nggak pedih pas potong bawang, coba simpan bawang di kulkas dulu selama 15 menit.',
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _QuickSuggestionCard extends StatelessWidget {
  const _QuickSuggestionCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      width: 120,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ?? () {},
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 28,
                  color: colors.bodyText.withValues(alpha: 0.8),
                ),
                const Spacer(),
                Text(
                  title,
                  style: textTheme.labelLarge?.copyWith(
                    color: colors.bodyText,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.bodyText.withValues(alpha: 0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
