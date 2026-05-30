import 'package:flutter/material.dart';
import 'package:masakanku/core/theme/app_colors.dart';

Widget buildBottomSheetDropdown({
  required BuildContext context,
  required String value,
  required List<String> items,
  required ValueChanged<String?> onChanged,
  required IconData icon,
  required AppColors colors,
  required TextTheme textTheme,
  String title = 'Pilih',
}) {
  return InkWell(
    onTap: () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return _StringPickerBottomSheet(
            items: items,
            colors: colors,
            textTheme: textTheme,
            title: title,
            onSelected: onChanged,
          );
        },
      );
    },
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
          Row(
            children: [
              Icon(icon, color: colors.outline),
              const SizedBox(width: 12),
              Text(
                value,
                style: textTheme.bodyLarge?.copyWith(color: colors.bodyText),
              ),
            ],
          ),
          Icon(Icons.keyboard_arrow_down_rounded, color: colors.outline),
        ],
      ),
    ),
  );
}

class _StringPickerBottomSheet extends StatefulWidget {
  final List<String> items;
  final AppColors colors;
  final TextTheme textTheme;
  final ValueChanged<String?> onSelected;
  final String title;

  const _StringPickerBottomSheet({
    required this.items,
    required this.colors,
    required this.textTheme,
    required this.onSelected,
    required this.title,
  });

  @override
  State<_StringPickerBottomSheet> createState() => _StringPickerBottomSheetState();
}

class _StringPickerBottomSheetState extends State<_StringPickerBottomSheet> {
  final _searchController = TextEditingController();
  late List<String> _filteredItems;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
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
      _filteredItems = widget.items.where((item) => item.toLowerCase().contains(query)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: widget.colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
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
              widget.title,
              style: widget.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          if (widget.items.length > 5)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari...',
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
            child: _filteredItems.isEmpty
                ? Center(
                    child: Text(
                      'Tidak ditemukan',
                      style: TextStyle(color: widget.colors.outline),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      return InkWell(
                        onTap: () {
                          widget.onSelected(item);
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: widget.colors.outlineVariant.withValues(alpha: 0.2))),
                          ),
                          child: Text(
                            item,
                            style: widget.textTheme.bodyLarge,
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
