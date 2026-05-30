import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../screens/recipe_detail_screen.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required this.title,
    required this.time,
    required this.calories,
    required this.isGeneratedByAI,
    required this.imageColor,
    required this.icon,
  });

  final String title;
  final String time;
  final String calories;
  final bool isGeneratedByAI;
  final Color imageColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecipeDetailScreen(
              title: title,
              time: time,
              calories: calories,
              imageColor: imageColor,
              icon: icon,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: colors.mainPink.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Placeholder
            Container(
              height: 140,
              width: double.infinity,
              color: imageColor.withValues(alpha: 0.3),
              child: Stack(
                children: [
                  Center(
                    child: Icon(icon, size: 64, color: imageColor.withValues(alpha: 0.8)),
                  ),
                  if (isGeneratedByAI)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.auto_awesome_rounded, size: 14, color: colors.mainPink),
                            const SizedBox(width: 4),
                            Text(
                              'Resep AI',
                              style: textTheme.labelSmall?.copyWith(color: colors.mainPink, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.schedule_rounded, size: 16, color: colors.outline),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: textTheme.labelSmall?.copyWith(color: colors.outline),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.local_fire_department_rounded, size: 16, color: colors.outline),
                      const SizedBox(width: 4),
                      Text(
                        calories,
                        style: textTheme.labelSmall?.copyWith(color: colors.outline),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
