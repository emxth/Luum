import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/providers/startup_provider.dart';
import '../../goals/providers/active_goals_provider.dart';
import '../../goals/providers/goal_dashboard_provider.dart';
import '../../loans/providers/loan_dashboard_provider.dart';
import '../../settings/providers/budget_summary_provider.dart';
import '../../transactions/providers/recent_transactions_provider.dart';
import '../providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startup = ref.watch(startupProvider);
    final dashboard = ref.watch(dashboardProvider);
    final recent = ref.watch(recentTransactionsProvider);
    final goalSummary = ref.watch(goalDashboardProvider);
    final activeGoals = ref.watch(activeGoalsProvider);
    final loanDashboard = ref.watch(loanDashboardProvider);
    final budget = ref.watch(budgetSummaryProvider); // !Temporary for testing

    return startup.when(
      loading: () {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
      error: (error, stackTrace) {
        return Scaffold(body: Center(child: Text(error.toString())));
      },
      data: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Luum')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                dashboard.when(
                  data: (summary) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Balance: Rs. ${summary.balance}'),

                        Text('Income: Rs. ${summary.totalIncome}'),

                        Text('Expense: Rs. ${summary.totalExpense}'),

                        const Divider(),

                        Text('This Month Income: Rs. ${summary.monthIncome}'),

                        Text('This Month Expense: Rs. ${summary.monthExpense}'),

                        Text('This Month Balance: Rs. ${summary.monthBalance}'),
                      ],
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text(e.toString()),
                ),

                recent.when(
                  data: (items) {
                    return Column(
                      children: [
                        const Text('Recent Transactions'),

                        ...items.map((transaction) {
                          return ListTile(
                            title: Text(transaction.type),
                            subtitle: Text('Rs. ${transaction.amount}'),
                          );
                        }),
                      ],
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text(e.toString()),
                ),

                goalSummary.when(
                  data: (summary) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Goals Summary'),

                        Text('Goals: ${summary.totalGoals}'),

                        Text('Active: ${summary.activeGoals}'),

                        Text('Completed: ${summary.completedGoals}'),

                        Text('Saved: Rs. ${summary.totalSaved}'),
                      ],
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text(e.toString()),
                ),

                activeGoals.when(
                  data: (goals) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Active Goals'),

                        ...goals.take(3).map((goal) {
                          return ListTile(
                            title: Text(goal.name),
                            subtitle: Text('Target: Rs. ${goal.targetAmount}'),
                          );
                        }),
                      ],
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text(e.toString()),
                ),

                loanDashboard.when(
                  data: (data) {
                    return Card(
                      child: Column(
                        children: [
                          const Text('Loans'),

                          Text('Receivable: Rs. ${data.totalReceivable}'),

                          Text('Payable: Rs. ${data.totalPayable}'),

                          Text('Pending Loans: ${data.pendingLoans}'),
                        ],
                      ),
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text(e.toString()),
                ),

                // !Temporary for testing
                budget.when(
                  data: (data) {
                    return Column(
                      children: [
                        Text('Limit: Rs. ${data.monthlyLimit}'),

                        Text('Spent: Rs. ${data.spent}'),

                        Text('Remaining: Rs. ${data.remaining}'),

                        LinearProgressIndicator(value: data.progress),
                      ],
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text(e.toString()),
                ),

                ElevatedButton(
                  onPressed: () {
                    context.push('/transactions/add/expense');
                  },
                  child: const Text('Add Expense'),
                ),

                ElevatedButton(
                  onPressed: () {
                    context.push('/transactions/add/income');
                  },
                  child: const Text('Add Income'),
                ),

                ElevatedButton(
                  onPressed: () {
                    context.push('/transactions');
                  },
                  child: const Text('View Transactions'),
                ),

                ElevatedButton(
                  onPressed: () {
                    context.push('/goals');
                  },
                  child: const Text('Goals'),
                ),

                ElevatedButton(
                  onPressed: () {
                    context.push('/loans');
                  },
                  child: const Text('Loans'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
