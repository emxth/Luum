import 'package:flutter/material.dart';

import 'router.dart';
import 'theme.dart';

class LuumApp extends StatelessWidget {
  const LuumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Luum',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}