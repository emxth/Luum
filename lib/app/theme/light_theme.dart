import 'package:flutter/material.dart';

class LightTheme {
  static ThemeData theme = ThemeData(
    useMaterial3: true,

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2E7D32),
      brightness: Brightness.light,
    ),

    appBarTheme: const AppBarTheme(centerTitle: true),

    cardTheme: const CardThemeData(elevation: 1),

    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}
