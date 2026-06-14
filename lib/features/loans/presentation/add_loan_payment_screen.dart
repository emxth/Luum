import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../data/database/app_database.dart';
import '../../../data/providers/loan_provider.dart';
import '../providers/loan_dashboard_provider.dart';
import '../providers/loan_summary_provider.dart';
import '../providers/loan_payments_provider.dart';
import '../providers/loans_provider.dart';
import '../providers/pending_payables_provider.dart';
import '../providers/pending_receivables_provider.dart';
import '../providers/recent_loan_activity_provider.dart';

class AddLoanPaymentScreen extends ConsumerStatefulWidget {
  final String loanId;

  const AddLoanPaymentScreen({super.key, required this.loanId});

  @override
  ConsumerState<AddLoanPaymentScreen> createState() =>
      _AddLoanPaymentScreenState();
}

class _AddLoanPaymentScreenState extends ConsumerState<AddLoanPaymentScreen> {
  final amountController = TextEditingController();

  final noteController = TextEditingController();

  Future<void> save() async {
    final repository = ref.read(loanRepositoryProvider);

    final amount = double.tryParse(amountController.text);

    if (amount == null || amount <= 0) {
      return;
    }

    final now = DateTime.now().toIso8601String();

    await repository.addPayment(
      LoanPaymentsCompanion.insert(
        id: const Uuid().v4(),
        loanId: widget.loanId,
        amount: amount,
        paymentDate: now,
        note: Value(noteController.text.isEmpty ? null : noteController.text),
        createdAt: now,
      ),
    );

    await repository.updateLoanStatus(widget.loanId);

    ref.invalidate(loanSummaryProvider(widget.loanId));

    ref.invalidate(loanPaymentsProvider(widget.loanId));

    ref.invalidate(loansProvider);

    ref.invalidate(loanDashboardProvider);

    ref.invalidate(pendingReceivablesProvider);

    ref.invalidate(pendingPayablesProvider);

    ref.invalidate(recentLoanActivityProvider);

    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),

            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: 'Note'),
            ),

            ElevatedButton(onPressed: save, child: const Text('Save Payment')),
          ],
        ),
      ),
    );
  }
}
