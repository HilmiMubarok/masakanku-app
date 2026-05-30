import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/ingredient_card.dart';
import 'add_ingredient_screen.dart';

class PantryScreen extends StatefulWidget {
  const PantryScreen({super.key});

  @override
  State<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends State<PantryScreen> {
  int _selectedCategoryIndex = 0;

  final List<String> _categories = ['Semua', 'Protein', 'Sayuran', 'Bumbu', 'Lainnya'];

  // Dummy data
  late final List<Map<String, dynamic>> _dummyIngredients;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final colors = Theme.of(context).extension<AppColors>()!;
    _dummyIngredients = [
      {'name': 'Telur Ayam', 'qty': '10 butir', 'icon': Icons.egg_alt_rounded, 'color': colors.peachAccent, 'cat': 'Protein'},
      {'name': 'Daging Sapi', 'qty': '500 gram', 'icon': Icons.set_meal_rounded, 'color': colors.peachAccent, 'cat': 'Protein'},
      {'name': 'Sawi Hijau', 'qty': '2 ikat', 'icon': Icons.eco_rounded, 'color': colors.matchaGreen, 'cat': 'Sayuran'},
      {'name': 'Wortel', 'qty': '3 buah', 'icon': Icons.eco_rounded, 'color': colors.matchaGreen, 'cat': 'Sayuran'},
      {'name': 'Bawang Merah', 'qty': '100 gram', 'icon': Icons.scatter_plot_rounded, 'color': colors.lavenderAccent, 'cat': 'Bumbu'},
      {'name': 'Susu UHT', 'qty': '1 liter', 'icon': Icons.local_drink_rounded, 'color': colors.secondaryPink, 'cat': 'Lainnya'},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppColors>()!;

    final filteredIngredients = _selectedCategoryIndex == 0
        ? _dummyIngredients
        : _dummyIngredients.where((item) => item['cat'] == _categories[_selectedCategoryIndex]).toList();

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
            SliverPadding(
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
                    final item = filteredIngredients[index];
                    return IngredientCard(
                      name: item['name'] as String,
                      quantity: item['qty'] as String,
                      icon: item['icon'] as IconData,
                      backgroundColor: item['color'] as Color,
                    );
                  },
                  childCount: filteredIngredients.length,
                ),
              ),
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
