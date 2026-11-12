import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const ink = Color(0xFF21152B);
  static const purple = Color(0xFF55247A);
  static const darkPurple = Color(0xFF1B1124);
  static const lightCanvas = Color(0xFFF7F4FA);
  static const darkCanvas = Color(0xFF130F18);
  static const darkSurface = Color(0xFF211A2A);

  static ThemeData get light => _build(
        brightness: Brightness.light,
        primary: purple,
        surface: Colors.white,
        canvas: lightCanvas,
        foreground: ink,
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        primary: const Color(0xFFD0A7F3),
        surface: darkSurface,
        canvas: darkCanvas,
        foreground: const Color(0xFFF2EAF8),
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color primary,
    required Color surface,
    required Color canvas,
    required Color foreground,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: purple,
      brightness: brightness,
      primary: primary,
      surface: surface,
      onSurface: foreground,
    );
    final muted = foreground.withValues(alpha: .68);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: canvas,
      appBarTheme: AppBarTheme(
        backgroundColor: canvas,
        foregroundColor: foreground,
        centerTitle: false,
        elevation: 0,
      ),
      textTheme: ThemeData(brightness: brightness).textTheme.apply(
            bodyColor: foreground,
            displayColor: foreground,
          ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.dark ? darkSurface : canvas,
        hintStyle: TextStyle(color: muted),
        labelStyle: TextStyle(color: muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.zero,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primary.withValues(alpha: .18),
        labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
              color: states.contains(WidgetState.selected) ? primary : muted,
              fontSize: 12,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w700
                  : FontWeight.w500,
            )),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: brightness == Brightness.dark ? primary : ink,
        foregroundColor: brightness == Brightness.dark ? darkPurple : Colors.white,
        shape: const StadiumBorder(),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}
