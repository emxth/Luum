import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavigation({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;

      case 1:
        context.go('/transactions');
        break;

      case 2:
        _showCreateMenu(context);
        break;

      case 3:
        context.go('/goals');
        break;

      case 4:
        context.go('/settings');
        break;
    }
  }

  void _showCreateMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                title: const Text('Add Expense'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/transactions/add/expense');
                },
              ),

              ListTile(
                title: const Text('Add Income'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/transactions/add/income');
                },
              ),

              ListTile(
                title: const Text('Add Goal'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/goals/add');
                },
              ),

              ListTile(
                title: const Text('Add Loan'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/loans/add');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        _onTap(context, index);
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),

        NavigationDestination(
          icon: Icon(Icons.receipt_long),
          label: 'Transactions',
        ),

        NavigationDestination(icon: Icon(Icons.add_circle), label: 'New'),

        NavigationDestination(icon: Icon(Icons.flag), label: 'Goals'),

        NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}
