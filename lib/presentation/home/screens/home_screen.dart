import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../recipes/widgets/recipe_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

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
                Column(
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
                CircleAvatar(
                  backgroundColor: colors.lavenderAccent,
                  radius: 24,
                  child: Icon(Icons.person_rounded, color: colors.bodyText),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Smart AI Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
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
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colors.matchaGreen.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.auto_awesome, color: colors.matchaGreen.withValues(alpha: 0.8)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '"Stok kamu ada telur, sawi, sama ayam nih. Sini aku bantuin racik 3 ide menu!"',
                          style: textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.mainPink,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Bikinin Resep Dong',
                        style: textTheme.labelLarge?.copyWith(color: Colors.white),
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
            Text(
              'Mungkin kamu suka ini',
              style: textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),

            // Today's Pick Recipe Card
            RecipeCard(
              title: 'Ayam Goreng Mentega',
              time: '30 mnt',
              calories: '320 kcal',
              isGeneratedByAI: true,
              imageColor: colors.secondaryPink,
              icon: Icons.set_meal_rounded,
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
            const SizedBox(height: 32), // extra padding for bottom scrolling
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
  });

  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      width: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
      ),
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
    );
  }
}
