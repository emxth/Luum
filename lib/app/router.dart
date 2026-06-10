import 'package:go_router/go_router.dart';

import '../features/goals/presentation/add_goal_contribution_screen.dart';
import '../features/goals/presentation/add_goal_screen.dart';
import '../features/goals/presentation/goal_details_screen.dart';
import '../features/goals/presentation/goals_screen.dart';
import '../features/loans/presentation/add_loan_screen.dart';
import '../features/loans/presentation/loan_details_screen.dart';
import '../features/loans/presentation/loans_screen.dart';
import '../features/transactions/presentation/add_transaction_screen.dart';
import '../features/transactions/presentation/transaction_list_screen.dart';
import '../features/transactions/presentation/transaction_details_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';

final router = GoRouter(
  routes: [
    // Dashboard route
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const DashboardScreen();
      },
    ),

    // Transactions routes
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

    // Goals routes
    GoRoute(path: '/goals', builder: (_, _) => const GoalsScreen()),

    GoRoute(path: '/goals/add', builder: (_, _) => const AddGoalScreen()),

    GoRoute(
      path: '/goals/edit/:id',
      builder: (context, state) {
        return AddGoalScreen(goalId: state.pathParameters['id']);
      },
    ),

    GoRoute(
      path: '/goals/details/:id',
      builder: (context, state) {
        return GoalDetailsScreen(goalId: state.pathParameters['id']!);
      },
    ),

    GoRoute(
      path: '/goals/:id/contribute',
      builder: (context, state) {
        return AddGoalContributionScreen(goalId: state.pathParameters['id']!);
      },
    ),

    // Loan routes
    GoRoute(
      path: '/loans',
      builder: (context, state) {
        return const LoansScreen();
      },
    ),

    GoRoute(
      path: '/loans/add',
      builder: (context, state) {
        return const AddLoanScreen();
      },
    ),

    GoRoute(
      path: '/loans/edit/:id',
      builder: (context, state) {
        return AddLoanScreen(loanId: state.pathParameters['id']);
      },
    ),

    GoRoute(
      path: '/loans/details/:id',
      builder: (context, state) {
        return LoanDetailsScreen(loanId: state.pathParameters['id']!);
      },
    ),
  ],
);
