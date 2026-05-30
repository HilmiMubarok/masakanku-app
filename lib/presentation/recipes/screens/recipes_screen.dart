import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/recipe_card.dart';
import 'add_recipe_screen.dart';
import '../providers/recipe_provider.dart';

class RecipesScreen extends ConsumerStatefulWidget {
  const RecipesScreen({super.key});

  @override
  ConsumerState<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends ConsumerState<RecipesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final recipesAsync = ref.watch(recipesProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Text('Buku Resep', style: textTheme.headlineMedium),
        bottom: TabBar(
          controller: _tabController,
          labelColor: colors.mainPink,
          unselectedLabelColor: colors.outline,
          indicatorColor: colors.mainPink,
          labelStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
          unselectedLabelStyle: textTheme.labelLarge,
          tabs: const [
            Tab(text: 'Tersimpan'),
            Tab(text: 'Terakhir Dibuat'),
          ],
        ),
      ),
      body: recipesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          if (err is PostgrestException && err.code == '42P01') {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Tabel resep belum ada di Supabase!\nJalankan SQL Migration.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(color: colors.error),
                ),
              ),
            );
          }
          return Center(child: Text('Terjadi Kesalahan: $err'));
        },
        data: (recipes) {
          if (recipes.isEmpty) {
            return TabBarView(
              controller: _tabController,
              children: [
                Center(
                  child: Text('Belum ada resep tersimpan', style: textTheme.bodyLarge?.copyWith(color: colors.outline)),
                ),
                Center(
                  child: Text('Belum ada riwayat masakan', style: textTheme.bodyLarge?.copyWith(color: colors.outline)),
                ),
              ],
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              ListView.separated(
                padding: const EdgeInsets.all(24),
                itemCount: recipes.length,
                separatorBuilder: (context, index) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return RecipeCard(
                    title: recipe.title,
                    time: '${recipe.cookingTime} mnt',
                    calories: '-', // No nutrition tracking in MVP yet
                    isGeneratedByAI: recipe.source == 'ai',
                    imageColor: colors.lavenderAccent,
                    icon: Icons.set_meal_rounded,
                  );
                },
              ),
              // Dummy empty history for MVP
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history_rounded, size: 64, color: colors.outlineVariant),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada riwayat masakan',
                      style: textTheme.bodyLarge?.copyWith(color: colors.outline),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRecipeScreen()),
          );
        },
        backgroundColor: colors.mainPink,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }
}
