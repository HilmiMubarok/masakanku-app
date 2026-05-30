import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/ingredient_provider.dart';
import 'ingredient_form_screen.dart';

class IngredientListScreen extends ConsumerWidget {
  const IngredientListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final ingredientsAsync = ref.watch(ingredientProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Master Bahan'),
        backgroundColor: colors.background,
      ),
      body: ingredientsAsync.when(
        data: (ingredients) {
          if (ingredients.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.kitchen_rounded, size: 80, color: colors.outlineVariant),
                  const SizedBox(height: 16),
                  Text('Belum ada master bahan', style: textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Silakan tambah bahan baru', style: textTheme.bodyMedium?.copyWith(color: colors.outline)),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            itemCount: ingredients.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = ingredients[index];
              return Dismissible(
                key: Key(item.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete_rounded, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Hapus Bahan?"),
                        content: Text("Yakin ingin menghapus ${item.name}?"),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text("Batal")),
                          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text("Hapus")),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (direction) {
                  ref.read(ingredientProvider.notifier).deleteIngredient(item.id);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item.name} dihapus')));
                },
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => IngredientFormScreen(ingredient: item)),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: colors.matchaGreen.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              item.name.substring(0, 1).toUpperCase(),
                              style: textTheme.titleLarge?.copyWith(color: colors.matchaGreen, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                              if (item.category != null && item.category!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  item.category!,
                                  style: textTheme.bodySmall?.copyWith(color: colors.outline),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded, color: colors.outline),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Terjadi kesalahan: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const IngredientFormScreen()),
          );
        },
        backgroundColor: colors.matchaGreen,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }
}
