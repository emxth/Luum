import 'package:go_router/go_router.dart';

import '../features/transactions/presentation/add_transaction_screen.dart';
import '../features/transactions/presentation/transaction_list_screen.dart';
import '../features/transactions/presentation/transaction_details_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const DashboardScreen();
      },
    ),

    GoRoute(
      path: '/transactions/add/:type',
      builder: (context, state) {
        final type = state.pathParameters['type']!;

        return AddTransactionScreen(transactionType: type);
      },
    ),

    GoRoute(
      path: '/transactions',
      builder: (context, state) {
        return const TransactionListScreen();
      },
    ),

    GoRoute(
      path: '/transactions/details/:id',
      builder: (context, state) {
        return TransactionDetailsScreen(
          transactionId: state.pathParameters['id']!,
        );
      },
    ),

    GoRoute(
      path: '/transactions/edit/:id',
      builder: (context, state) {
        return AddTransactionScreen(
          transactionId: state.pathParameters['id'],
          transactionType: 'expense',
        );
      },
    ),
  ],
);
