import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _titleController = TextEditingController();
  final _timeController = TextEditingController();
  final _calController = TextEditingController();

  final _ingredientController = TextEditingController();
  final List<String> _ingredients = [];

  final _stepController = TextEditingController();
  final List<String> _steps = [];

  @override
  void dispose() {
    _titleController.dispose();
    _timeController.dispose();
    _calController.dispose();
    _ingredientController.dispose();
    _stepController.dispose();
    super.dispose();
  }

  void _addIngredient() {
    if (_ingredientController.text.trim().isNotEmpty) {
      setState(() {
        _ingredients.add(_ingredientController.text.trim());
        _ingredientController.clear();
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
                Expanded(child: _buildTextField(controller: _calController, hint: 'Kalori (mis: 320)', icon: Icons.local_fire_department_rounded, colors: colors)),
              ],
            ),
            const SizedBox(height: 32),

            // Ingredients
            _buildSectionTitle('Bahan-bahan', textTheme, colors),
            const SizedBox(height: 16),
            ..._ingredients.map((ing) => _buildListItem(ing, () {
              setState(() => _ingredients.remove(ing));
            }, colors)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _ingredientController,
                    hint: 'Ketik bahan...',
                    icon: Icons.kitchen_rounded,
                    colors: colors,
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.filled(
                  onPressed: _addIngredient,
                  style: IconButton.styleFrom(backgroundColor: colors.matchaGreen),
                  icon: const Icon(Icons.add_rounded),
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
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.mainPink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Simpan Resep', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
