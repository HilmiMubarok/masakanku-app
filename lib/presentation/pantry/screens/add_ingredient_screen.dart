import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AddIngredientScreen extends StatefulWidget {
  const AddIngredientScreen({super.key});

  @override
  State<AddIngredientScreen> createState() => _AddIngredientScreenState();
}

class _AddIngredientScreenState extends State<AddIngredientScreen> {
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController();
  String _selectedCategory = 'Sayuran';
  String _selectedUnit = 'gram';
  DateTime? _selectedDate;

  final List<String> _categories = ['Protein', 'Sayuran', 'Bumbu', 'Karbohidrat', 'Lainnya'];
  final List<String> _units = ['gram', 'kg', 'ml', 'liter', 'butir', 'ikat', 'siung'];

  @override
  void dispose() {
    _nameController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 3)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
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
        title: Text('Tambah Bahan', style: textTheme.titleMedium),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name Input
            Text('Nama Bahan', style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: colors.mainPink)),
            const SizedBox(height: 8),
            _buildTextField(controller: _nameController, hint: 'Misal: Telur Ayam', icon: Icons.fastfood_rounded, colors: colors),
            const SizedBox(height: 24),

            // Category Dropdown
            Text('Kategori', style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: colors.mainPink)),
            const SizedBox(height: 8),
            _buildDropdown(
              value: _selectedCategory,
              items: _categories,
              onChanged: (val) => setState(() => _selectedCategory = val!),
              icon: Icons.category_rounded,
              colors: colors,
            ),
            const SizedBox(height: 24),

            // Quantity & Unit
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Jumlah', style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: colors.mainPink)),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _qtyController,
                        hint: '0',
                        icon: Icons.scale_rounded,
                        colors: colors,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Satuan', style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: colors.mainPink)),
                      const SizedBox(height: 8),
                      _buildDropdown(
                        value: _selectedUnit,
                        items: _units,
                        onChanged: (val) => setState(() => _selectedUnit = val!),
                        icon: Icons.straighten_rounded,
                        colors: colors,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Expiration Date
            Text('Tanggal Kadaluarsa (Opsional)', style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: colors.mainPink)),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, color: colors.outline),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _selectedDate == null ? 'Pilih Tanggal' : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        style: textTheme.bodyLarge?.copyWith(color: _selectedDate == null ? colors.outlineVariant : colors.onBackground),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 48),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.mainPink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Simpan ke Kulkas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required AppColors colors,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: colors.outlineVariant),
        prefixIcon: Icon(icon, color: colors.outline),
        filled: true,
        fillColor: colors.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.3))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.3))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: colors.mainPink)),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down_rounded, color: colors.outline),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
