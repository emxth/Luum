import 'package:go_router/go_router.dart';

import '../features/dashboard/presentation/dashboard_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const DashboardScreen();
      },
    ),
  ],
);