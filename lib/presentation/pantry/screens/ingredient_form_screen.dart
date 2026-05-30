import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/ingredient.dart';
import '../providers/ingredient_provider.dart';

class IngredientFormScreen extends ConsumerStatefulWidget {
  final Ingredient? ingredient;

  const IngredientFormScreen({super.key, this.ingredient});

  @override
  ConsumerState<IngredientFormScreen> createState() => _IngredientFormScreenState();
}

class _IngredientFormScreenState extends ConsumerState<IngredientFormScreen> {
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.ingredient != null) {
      _nameController.text = widget.ingredient!.name;
      _categoryController.text = widget.ingredient!.category ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _save() async {
    final name = _nameController.text.trim();
    final category = _categoryController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama bahan tidak boleh kosong')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.ingredient == null) {
        await ref.read(ingredientProvider.notifier).addIngredient(name, category.isNotEmpty ? category : null);
      } else {
        await ref.read(ingredientProvider.notifier).updateIngredient(widget.ingredient!.id, name, category.isNotEmpty ? category : null);
      }
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(widget.ingredient == null ? 'Bahan berhasil ditambahkan' : 'Bahan berhasil diperbarui'),
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required AppColors colors,
    bool isRequired = false,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: colors.mainPink)),
            if (isRequired) Text(' *', style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.error)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
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
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isEditing = widget.ingredient != null;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Bahan' : 'Tambah Bahan Baru'),
        backgroundColor: colors.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              controller: _nameController,
              label: 'Nama Bahan',
              hint: 'Contoh: Wortel',
              icon: Icons.kitchen_rounded,
              colors: colors,
              isRequired: true,
            ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: _categoryController,
              label: 'Kategori (Opsional)',
              hint: 'Contoh: Sayuran',
              icon: Icons.category_rounded,
              colors: colors,
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: _isLoading ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.matchaGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: _isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(isEditing ? 'Simpan Perubahan' : 'Simpan Bahan', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
