import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../screens/ingredient_detail_screen.dart';

class IngredientCard extends StatelessWidget {
  const IngredientCard({
    super.key,
    required this.name,
    required this.quantity,
    required this.icon,
    required this.backgroundColor,
  });

  final String name;
  final String quantity;
  final IconData icon;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppColors>()!;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IngredientDetailScreen(
              name: name,
              amount: quantity,
              color: backgroundColor,
              icon: icon,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: backgroundColor.withValues(alpha: 0.8), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: colors.bodyText.withValues(alpha: 0.8), size: 24),
            ),
            const Spacer(),
            Text(
              name,
              style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              quantity,
              style: textTheme.labelSmall?.copyWith(
                color: colors.bodyText.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
