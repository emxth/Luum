import 'package:flutter/material.dart';

class DarkTheme {
  static ThemeData theme = ThemeData(
    useMaterial3: true,

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2E7D32),
      brightness: Brightness.dark,
    ),

    appBarTheme: const AppBarTheme(centerTitle: true),

    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}
