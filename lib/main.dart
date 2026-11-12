import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_page.dart';
import 'theme/app_theme.dart';

void main() => runApp(const FuelApp());

class FuelApp extends StatefulWidget {
  const FuelApp({super.key});

  @override
  State<FuelApp> createState() => _FuelAppState();
}

class _FuelAppState extends State<FuelApp> {
  static const _themeKey = 'dark_mode';
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final preferences = await SharedPreferences.getInstance();
    if (mounted) setState(() => _isDark = preferences.getBool(_themeKey) ?? false);
  }

  Future<void> _toggleTheme() async {
    setState(() => _isDark = !_isDark);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_themeKey, _isDark);
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'e-Fuelz',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
        home: HomePage(isDark: _isDark, onToggleTheme: _toggleTheme),
      );
}
