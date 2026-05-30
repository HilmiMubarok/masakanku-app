import 'package:flutter/material.dart';
import '../../../domain/models/recipe.dart';
import '../../../core/theme/app_colors.dart';

class CookingModeScreen extends StatefulWidget {
  const CookingModeScreen({
    super.key,
    required this.title,
    required this.recipe,
  });

  final String title;
  final Recipe recipe;

  @override
  State<CookingModeScreen> createState() => _CookingModeScreenState();
}

class _CookingModeScreenState extends State<CookingModeScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  late final List<String> _steps;

  @override
  void initState() {
    super.initState();
    if (widget.recipe.steps != null && widget.recipe.steps!.isNotEmpty) {
      _steps = widget.recipe.steps!.map((s) => s.instruction).toList();
    } else {
      _steps = ['Tidak ada langkah memasak yang tersedia untuk resep ini.'];
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.title, style: textTheme.titleMedium),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: List.generate(
                  _steps.length,
                  (index) => Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: index == _steps.length - 1 ? 0 : 8),
                      height: 6,
                      decoration: BoxDecoration(
                        color: index <= _currentIndex ? colors.mainPink : colors.outlineVariant.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Langkah ${index + 1}',
                          style: textTheme.titleLarge?.copyWith(
                            color: colors.mainPink,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          _steps[index],
                          textAlign: TextAlign.center,
                          style: textTheme.headlineMedium?.copyWith(
                            height: 1.5,
                            color: colors.onBackground,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Controls
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentIndex > 0)
                    TextButton.icon(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text('Sebelumnya'),
                      style: TextButton.styleFrom(foregroundColor: colors.outline),
                    )
                  else
                    const SizedBox(width: 120), // Placeholder to keep layout balanced

                  if (_currentIndex < _steps.length - 1)
                    ElevatedButton.icon(
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text('Selanjutnya', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.mainPink,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context); // Close cooking mode
                      },
                      icon: const Icon(Icons.check_rounded),
                      label: const Text('Selesai', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.matchaGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
