import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _primary = Color(0xFF00B4B4);

final appThemeData = ThemeData(
  brightness: Brightness.light,
  primaryColor: _primary,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _primary,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: const Color(0xFFF8F8F8),
  cardColor: Colors.white,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
    ),
    elevation: 0,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
  ),
  dividerColor: Color(0xFFF0F0F0),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {}),
);

final appDarkThemeData = ThemeData(
  brightness: Brightness.dark,
  primaryColor: _primary,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _primary,
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: const Color(0xFF111111),
  cardColor: const Color(0xFF1E1E1E),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1A1A1A),
    surfaceTintColor: Color(0xFF1A1A1A),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
    ),
    elevation: 0,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
  ),
  dividerColor: Color(0xFF2A2A2A),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {}),
);

/// Convenience extension — use ctx.isDark, ctx.cardBg, etc. in any widget
extension ThemeCtx on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get bgColor =>
      isDark ? const Color(0xFF111111) : const Color(0xFFF8F8F8);
  Color get cardBg => isDark ? const Color(0xFF1E1E1E) : Colors.white;
  Color get surfaceBg =>
      isDark ? const Color(0xFF252525) : const Color(0xFFF2F2F2);
  Color get textPrimary =>
      isDark ? Colors.white : const Color(0xFF1A1A1A);
  Color get textSecondary =>
      isDark ? const Color(0xFFAAAAAA) : const Color(0xFF666666);
  Color get dividerColor =>
      isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF0F0F0);
  Color get navBarBg => Colors.white;
}
