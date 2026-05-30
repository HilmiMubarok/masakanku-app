import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import 'package:masakanku/core/widgets/bottom_sheet_dropdown.dart';
import '../../../domain/models/ingredient.dart';
import '../providers/pantry_provider.dart';
import '../providers/ingredient_provider.dart';

class AddIngredientScreen extends ConsumerStatefulWidget {
  const AddIngredientScreen({super.key});

  @override
  ConsumerState<AddIngredientScreen> createState() => _AddIngredientScreenState();
}

class _AddIngredientScreenState extends ConsumerState<AddIngredientScreen> {
  final _qtyController = TextEditingController();
  Ingredient? _selectedIngredient;
  String _selectedUnit = 'gram';
  DateTime? _selectedDate;
  bool _isLoading = false;

  final List<String> _units = ['gram', 'kg', 'ml', 'liter', 'butir', 'ikat', 'siung'];

  @override
  void dispose() {
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

  void _saveIngredient() async {
    if (_selectedIngredient == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih bahan terlebih dahulu')));
      return;
    }
    
    // Default to 1 if empty or invalid
    final qty = double.tryParse(_qtyController.text) ?? 1.0;

    setState(() => _isLoading = true);

    try {
      await ref.read(pantryProvider.notifier).addItem(
        _selectedIngredient!.id,
        qty,
        _selectedUnit,
        _selectedDate,
      );
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        setState(() => _isLoading = false);
      }
    }
  }

  void _showIngredientPicker(List<Ingredient> ingredients, AppColors colors, TextTheme textTheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _IngredientPickerBottomSheet(
          ingredients: ingredients,
          colors: colors,
          textTheme: textTheme,
          onSelected: (ingredient) {
            setState(() {
              _selectedIngredient = ingredient;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final ingredientsAsync = ref.watch(ingredientProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Text('Tambah Bahan', style: textTheme.titleMedium),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ingredient Dropdown (from DB)
                Text('Pilih Bahan', style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: colors.mainPink)),
                const SizedBox(height: 8),
                ingredientsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Gagal memuat bahan: $e', style: TextStyle(color: colors.error)),
                  data: (ingredients) {
                    if (ingredients.isNotEmpty && _selectedIngredient == null) {
                      // Automatically select the first ingredient to prevent null errors
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _selectedIngredient = ingredients.first;
                          });
                        }
                      });
                    }
                    return InkWell(
                      onTap: () => _showIngredientPicker(ingredients, colors, textTheme),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedIngredient?.name ?? 'Pilih dari daftar',
                              style: textTheme.bodyLarge?.copyWith(
                                color: _selectedIngredient == null ? colors.outlineVariant : colors.bodyText,
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_down_rounded, color: colors.outline),
                          ],
                        ),
                      ),
                    );
                  },
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
                    onPressed: _isLoading ? null : _saveIngredient,
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
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.2),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
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
}

class _IngredientPickerBottomSheet extends StatefulWidget {
  final List<Ingredient> ingredients;
  final AppColors colors;
  final TextTheme textTheme;
  final ValueChanged<Ingredient> onSelected;

  const _IngredientPickerBottomSheet({
    required this.ingredients,
    required this.colors,
    required this.textTheme,
    required this.onSelected,
  });

  @override
  State<_IngredientPickerBottomSheet> createState() => _IngredientPickerBottomSheetState();
}

class _IngredientPickerBottomSheetState extends State<_IngredientPickerBottomSheet> {
  final _searchController = TextEditingController();
  late List<Ingredient> _filteredIngredients;

  @override
  void initState() {
    super.initState();
    _filteredIngredients = widget.ingredients;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredIngredients = widget.ingredients.where((ing) => ing.name.toLowerCase().contains(query)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: widget.colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: widget.colors.outlineVariant.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              'Pilih Bahan',
              style: widget.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari nama bahan...',
                hintStyle: TextStyle(color: widget.colors.outlineVariant),
                prefixIcon: Icon(Icons.search_rounded, color: widget.colors.outline),
                filled: true,
                fillColor: widget.colors.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredIngredients.isEmpty
                ? Center(
                    child: Text(
                      'Bahan tidak ditemukan',
                      style: TextStyle(color: widget.colors.outline),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    itemCount: _filteredIngredients.length,
                    itemBuilder: (context, index) {
                      final ing = _filteredIngredients[index];
                      return InkWell(
                        onTap: () {
                          widget.onSelected(ing);
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: widget.colors.outlineVariant.withValues(alpha: 0.2))),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: widget.colors.matchaGreen.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    ing.name.substring(0, 1).toUpperCase(),
                                    style: widget.textTheme.titleSmall?.copyWith(
                                      color: widget.colors.matchaGreen,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  ing.name,
                                  style: widget.textTheme.bodyLarge,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
