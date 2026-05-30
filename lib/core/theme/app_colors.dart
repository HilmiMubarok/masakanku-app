import 'package:flutter/material.dart';

/// Define custom colors that are not part of the standard Material ColorScheme.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.mainPink,
    required this.secondaryPink,
    required this.creamBackground,
    required this.peachAccent,
    required this.lavenderAccent,
    required this.matchaGreen,
    required this.bodyText,
  });

  final Color mainPink;
  final Color secondaryPink;
  final Color creamBackground;
  final Color peachAccent;
  final Color lavenderAccent;
  final Color matchaGreen;
  final Color bodyText;

  Color get background => creamBackground;
  Color get surface => Colors.white;
  Color get surfaceVariant => const Color(0xFFECE0E0);
  Color get onSurfaceVariant => const Color(0xFF524345);
  Color get onBackground => bodyText;
  Color get outline => const Color(0xFF847375);
  Color get outlineVariant => const Color(0xFFD6C1C4);
  Color get error => const Color(0xFFBA1A1A);

  @override
  AppColors copyWith({
    Color? mainPink,
    Color? secondaryPink,
    Color? creamBackground,
    Color? peachAccent,
    Color? lavenderAccent,
    Color? matchaGreen,
    Color? bodyText,
  }) {
    return AppColors(
      mainPink: mainPink ?? this.mainPink,
      secondaryPink: secondaryPink ?? this.secondaryPink,
      creamBackground: creamBackground ?? this.creamBackground,
      peachAccent: peachAccent ?? this.peachAccent,
      lavenderAccent: lavenderAccent ?? this.lavenderAccent,
      matchaGreen: matchaGreen ?? this.matchaGreen,
      bodyText: bodyText ?? this.bodyText,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      mainPink: Color.lerp(mainPink, other.mainPink, t)!,
      secondaryPink: Color.lerp(secondaryPink, other.secondaryPink, t)!,
      creamBackground: Color.lerp(creamBackground, other.creamBackground, t)!,
      peachAccent: Color.lerp(peachAccent, other.peachAccent, t)!,
      lavenderAccent: Color.lerp(lavenderAccent, other.lavenderAccent, t)!,
      matchaGreen: Color.lerp(matchaGreen, other.matchaGreen, t)!,
      bodyText: Color.lerp(bodyText, other.bodyText, t)!,
    );
  }

  /// Default light colors
  static const light = AppColors(
    mainPink: Color(0xFFF7A8B8),
    secondaryPink: Color(0xFFFFD6E0),
    creamBackground: Color(0xFFFFF8F4),
    peachAccent: Color(0xFFFFC6A8),
    lavenderAccent: Color(0xFFDCCEF9),
    matchaGreen: Color(0xFFCFE8C6),
    bodyText: Color(0xFF4B4B4B),
  );
}
