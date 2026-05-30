import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/recipe_card.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> with SingleTickerProviderStateMixin {
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

    final dummyRecipes = [
      {
        'title': 'Tumis Ayam Sawi Hijau',
        'time': '15 mnt',
        'calories': '320 kcal',
        'ai': true,
        'color': colors.matchaGreen,
        'icon': Icons.eco_rounded,
      },
      {
        'title': 'Nasi Goreng Sisa Kulkas',
        'time': '10 mnt',
        'calories': '450 kcal',
        'ai': true,
        'color': colors.peachAccent,
        'icon': Icons.rice_bowl_rounded,
      },
      {
        'title': 'Sup Telur Comfort',
        'time': '20 mnt',
        'calories': '210 kcal',
        'ai': false,
        'color': colors.lavenderAccent,
        'icon': Icons.soup_kitchen_rounded,
      },
    ];

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
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: dummyRecipes.length,
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              final recipe = dummyRecipes[index];
              return RecipeCard(
                title: recipe['title'] as String,
                time: recipe['time'] as String,
                calories: recipe['calories'] as String,
                isGeneratedByAI: recipe['ai'] as bool,
                imageColor: recipe['color'] as Color,
                icon: recipe['icon'] as IconData,
              );
            },
          ),
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
      ),
    );
  }
}
