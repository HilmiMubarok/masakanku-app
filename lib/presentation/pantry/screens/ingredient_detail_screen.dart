import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class IngredientDetailScreen extends StatelessWidget {
  const IngredientDetailScreen({
    super.key,
    required this.name,
    required this.amount,
    required this.color,
    required this.icon,
    this.daysLeft,
  });

  final String name;
  final String amount;
  final Color color;
  final IconData icon;
  final int? daysLeft;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    final isExpiringSoon = daysLeft != null && daysLeft! <= 3;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.edit_rounded, color: colors.outline),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.delete_outline_rounded, color: colors.error),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.3),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: Center(
                child: Icon(icon, size: 64, color: color),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              name,
              style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Kategori: Sayuran', // Dummy category
                style: textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant),
              ),
            ),
            const SizedBox(height: 48),

            // Details Cards
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    context,
                    title: 'Sisa Stok',
                    value: amount,
                    icon: Icons.scale_rounded,
                    colors: colors,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoCard(
                    context,
                    title: 'Kadaluarsa',
                    value: daysLeft != null ? '$daysLeft hari lagi' : '-',
                    icon: Icons.calendar_today_rounded,
                    colors: colors,
                    isWarning: isExpiringSoon,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required AppColors colors,
    bool isWarning = false,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isWarning ? colors.error.withValues(alpha: 0.1) : colors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isWarning ? colors.error.withValues(alpha: 0.3) : colors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: isWarning ? colors.error : colors.outline),
          const SizedBox(height: 16),
          Text(title, style: textTheme.labelMedium?.copyWith(color: colors.outline)),
          const SizedBox(height: 4),
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isWarning ? colors.error : colors.onBackground,
            ),
          ),
        ],
      ),
    );
  }
}
