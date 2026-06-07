import 'package:flutter/material.dart';

class LuumApp extends StatelessWidget {
  const LuumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luum',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Welcome to Luum'),
        ),
      ),
    );
  }
}