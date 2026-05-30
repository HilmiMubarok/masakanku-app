import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/ingredient_card.dart';
import 'add_ingredient_screen.dart';
import '../providers/pantry_provider.dart';

class PantryScreen extends ConsumerStatefulWidget {
  const PantryScreen({super.key});

  @override
  ConsumerState<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends ConsumerState<PantryScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = ['Semua', 'Protein', 'Sayuran', 'Bumbu', 'Karbohidrat', 'Lainnya'];

  // Utility to parse hex color to Flutter Color
  Color _parseColor(String? hex, Color fallback) {
    if (hex == null || hex.isEmpty) return fallback;
    final hexCode = hex.replaceAll('#', '');
    if (hexCode.length == 6) {
      return Color(int.parse('FF$hexCode', radix: 16));
    }
    return fallback;
  }

  // Utility to map string to IconData (MVP simplified)
  IconData _parseIcon(String? iconName) {
    switch (iconName) {
      case 'egg_alt_rounded': return Icons.egg_alt_rounded;
      case 'set_meal_rounded': return Icons.set_meal_rounded;
      case 'eco_rounded': return Icons.eco_rounded;
      case 'local_fire_department_rounded': return Icons.local_fire_department_rounded;
      case 'rice_bowl_rounded': return Icons.rice_bowl_rounded;
      case 'grain_rounded': return Icons.grain_rounded;
      default: return Icons.fastfood_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppColors>()!;
    final pantryAsync = ref.watch(pantryProvider);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: colors.background,
              pinned: true,
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                title: Text(
                  'Isi Kulkas',
                  style: textTheme.headlineMedium?.copyWith(
                    color: colors.onBackground,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 48,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final isSelected = _selectedCategoryIndex == index;
                    return ChoiceChip(
                      label: Text(_categories[index]),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });
                      },
                      selectedColor: colors.mainPink,
                      backgroundColor: colors.surface,
                      labelStyle: textTheme.labelMedium?.copyWith(
                        color: isSelected ? Colors.white : colors.bodyText,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? colors.mainPink : colors.outlineVariant,
                        ),
                      ),
                      showCheckmark: false,
                    );
                  },
                ),
              ),
            ),
            pantryAsync.when(
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) {
                // Check if it's because table doesn't exist yet
                if (err is PostgrestException && err.code == '42P01') {
                  return SliverFillRemaining(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          'Tabel belum dibuat di Supabase!\nJalankan SQL Migration terlebih dahulu.',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyLarge?.copyWith(color: colors.error),
                        ),
                      ),
                    ),
                  );
                }
                return SliverFillRemaining(
                  child: Center(child: Text('Terjadi Kesalahan: $err')),
                );
              },
              data: (items) {
                // Filter items
                final filteredItems = _selectedCategoryIndex == 0
                    ? items
                    : items.where((i) => i.ingredient?.category == _categories[_selectedCategoryIndex]).toList();

                if (filteredItems.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'Kulkas masih kosong!',
                        style: textTheme.bodyLarge?.copyWith(color: colors.outlineVariant),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = filteredItems[index];
                        final ingredient = item.ingredient;
                        return IngredientCard(
                          name: ingredient?.name ?? 'Unknown',
                          quantity: '${item.quantity} ${item.unit}',
                          icon: _parseIcon(ingredient?.icon),
                          backgroundColor: _parseColor(ingredient?.color, colors.surfaceVariant),
                        );
                      },
                      childCount: filteredItems.length,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddIngredientScreen()),
          );
        },
        backgroundColor: colors.mainPink,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
