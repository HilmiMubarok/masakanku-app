import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/bottom_sheet_dropdown.dart';
import '../providers/recipe_provider.dart';

class AddRecipeScreen extends ConsumerStatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  ConsumerState<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends ConsumerState<AddRecipeScreen> {
  bool _isLoading = false;
  final _titleController = TextEditingController();
  final _timeController = TextEditingController();
  final _calController = TextEditingController();

  final _ingredientNameController = TextEditingController();
  final _ingredientQtyController = TextEditingController();
  String _selectedIngredientUnit = 'gram';
  final List<String> _units = ['gram', 'kg', 'ml', 'liter', 'butir', 'ikat', 'siung', 'sdm', 'sdt', 'secukupnya', 'lembar', 'batang', 'buah', 'pcs'];
  final List<Map<String, dynamic>> _ingredients = [];

  final _stepController = TextEditingController();
  final List<String> _steps = [];

  @override
  void dispose() {
    _titleController.dispose();
    _timeController.dispose();
    _calController.dispose();
    _ingredientNameController.dispose();
    _ingredientQtyController.dispose();
    _stepController.dispose();
    super.dispose();
  }

  void _addIngredient() {
    final name = _ingredientNameController.text.trim();
    if (name.isNotEmpty) {
      final qtyStr = _ingredientQtyController.text.trim();
      final qty = double.tryParse(qtyStr.replaceAll(RegExp(r',|\s'), '.')) ?? 1.0;
      final unit = _selectedIngredientUnit;

      setState(() {
        _ingredients.add({
          'name': name,
          'quantity': qty,
          'unit': unit,
        });
        _ingredientNameController.clear();
        _ingredientQtyController.clear();
        _selectedIngredientUnit = 'gram';
      });
    }
  }

  void _addStep() {
    if (_stepController.text.trim().isNotEmpty) {
      setState(() {
        _steps.add(_stepController.text.trim());
        _stepController.clear();
      });
    }
  }

  Future<void> _saveRecipe() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Judul resep tidak boleh kosong')));
      return;
    }

    final time = int.tryParse(_timeController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final calories = int.tryParse(_calController.text.replaceAll(RegExp(r'[^0-9]'), ''));

    setState(() => _isLoading = true);
    
    try {
      await ref.read(recipesProvider.notifier).addRecipe(
        title,
        1, // Default servings
        time,
        calories,
        _ingredients,
        _steps,
      );
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menyimpan resep: $e')));
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Text('Buat Resep Baru', style: textTheme.titleMedium),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Placeholder
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.peachAccent.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: colors.peachAccent, width: 2, style: BorderStyle.solid),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_rounded, size: 40, color: colors.peachAccent),
                  const SizedBox(height: 8),
                  Text('Tambah Foto Makanan', style: textTheme.labelLarge?.copyWith(color: colors.peachAccent)),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Basic Info
            _buildSectionTitle('Info Dasar', textTheme, colors),
            const SizedBox(height: 16),
            _buildTextField(controller: _titleController, hint: 'Nama Masakan', icon: Icons.restaurant_menu_rounded, colors: colors),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildTextField(controller: _timeController, hint: 'Waktu (mis: 15 mnt)', icon: Icons.schedule_rounded, colors: colors)),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField(controller: _calController, hint: 'Kalori (opsional)', icon: Icons.local_fire_department_rounded, colors: colors)),
              ],
            ),
            const SizedBox(height: 32),

            // Ingredients
            _buildSectionTitle('Bahan-bahan', textTheme, colors),
            const SizedBox(height: 16),
            ..._ingredients.map((ing) => _buildListItem(
              '${ing['name']} (${ing['quantity']} ${ing['unit']})'.trim(), 
              () {
                setState(() => _ingredients.remove(ing));
              }, 
              colors
            )),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildTextField(
                  controller: _ingredientNameController,
                  hint: 'Nama Bahan (mis: Bawang Merah)',
                  icon: Icons.kitchen_rounded,
                  colors: colors,
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: _buildTextField(
                        controller: _ingredientQtyController,
                        hint: 'Jml (mis: 3)',
                        icon: Icons.numbers_rounded,
                        colors: colors,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: _buildDropdown(
                        value: _selectedIngredientUnit,
                        items: _units,
                        onChanged: (val) => setState(() => _selectedIngredientUnit = val!),
                        icon: Icons.scale_rounded,
                        colors: colors,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _addIngredient,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.matchaGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Tambah Bahan'),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Steps
            _buildSectionTitle('Cara Memasak', textTheme, colors),
            const SizedBox(height: 16),
            ..._steps.asMap().entries.map((entry) => _buildListItem('${entry.key + 1}. ${entry.value}', () {
              setState(() => _steps.removeAt(entry.key));
            }, colors)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _stepController,
                    hint: 'Ketik langkah...',
                    icon: Icons.list_rounded,
                    colors: colors,
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.filled(
                  onPressed: _addStep,
                  style: IconButton.styleFrom(backgroundColor: colors.matchaGreen),
                  icon: const Icon(Icons.add_rounded),
                ),
              ],
            ),
            
            const SizedBox(height: 48),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveRecipe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.mainPink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isLoading 
                    ? const SizedBox(
                        height: 20, 
                        width: 20, 
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      )
                    : const Text('Simpan Resep', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, TextTheme textTheme, AppColors colors) {
    return Text(
      title,
      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colors.mainPink),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required AppColors colors,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: colors.outlineVariant),
        prefixIcon: Icon(icon, color: colors.outline),
        filled: true,
        fillColor: colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.mainPink),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
    required AppColors colors,
  }) {
    return buildBottomSheetDropdown(
      context: context,
      value: value,
      items: items,
      onChanged: onChanged,
      icon: icon,
      colors: colors,
      textTheme: Theme.of(context).textTheme,
      title: 'Pilih Satuan',
    );
  }

  Widget _buildListItem(String text, VoidCallback onDelete, AppColors colors) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(child: Text(text)),
          GestureDetector(
            onTap: onDelete,
            child: Icon(Icons.close_rounded, size: 20, color: colors.outline),
          ),
        ],
      ),
    );
  }
}
