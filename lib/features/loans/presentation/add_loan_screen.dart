import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../data/database/app_database.dart';
import '../../../data/providers/loan_provider.dart';
import '../providers/loan_dashboard_provider.dart';
import '../providers/loans_provider.dart';
import '../providers/pending_payables_provider.dart';
import '../providers/pending_receivables_provider.dart';

class AddLoanScreen extends ConsumerStatefulWidget {
  final String? loanId;

  const AddLoanScreen({super.key, this.loanId});

  @override
  ConsumerState<AddLoanScreen> createState() => _AddLoanScreenState();
}

class _AddLoanScreenState extends ConsumerState<AddLoanScreen> {
  final personController = TextEditingController();

  final amountController = TextEditingController();

  final noteController = TextEditingController();

  String loanType = 'receivable';

  DateTime loanDate = DateTime.now();

  DateTime? dueDate;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    if (widget.loanId != null) {
      loadLoan();
    } else {
      isLoading = false;
    }
  }

  Future<void> loadLoan() async {
    final repository = ref.read(loanRepositoryProvider);

    final loan = await repository.getLoanById(widget.loanId!);

    if (loan != null && mounted) {
      setState(() {
        personController.text = loan.personName;

        amountController.text = loan.amount.toString();

        noteController.text = loan.note ?? '';

        loanType = loan.loanType;

        loanDate = DateTime.parse(loan.loanDate);

        dueDate = loan.dueDate == null ? null : DateTime.parse(loan.dueDate!);

        isLoading = false;
      });
    }
  }

  Future<void> saveLoan() async {
    final repository = ref.read(loanRepositoryProvider);

    final amount = double.tryParse(amountController.text);

    if (personController.text.isEmpty || amount == null || amount <= 0) {
      return;
    }

    final now = DateTime.now().toIso8601String();

    if (widget.loanId != null) {
      final existing = await repository.getLoanById(widget.loanId!);

      if (existing != null) {
        await repository.updateLoan(
          existing.copyWith(
            personName: personController.text,
            amount: amount,
            loanType: loanType,
            note: Value(
              noteController.text.isEmpty ? null : noteController.text,
            ),
            loanDate: loanDate.toIso8601String(),
            dueDate: Value(dueDate?.toIso8601String()),
            updatedAt: now,
          ),
        );
      }
    } else {
      await repository.createLoan(
        LoansCompanion.insert(
          id: const Uuid().v4(),
          personName: personController.text,
          amount: amount,
          loanType: loanType,
          status: 'pending',
          loanDate: loanDate.toIso8601String(),
          dueDate: Value(dueDate?.toIso8601String()),
          note: Value(noteController.text.isEmpty ? null : noteController.text),
          createdAt: now,
          updatedAt: now,
        ),
      );
    }

    ref.invalidate(loansProvider);

    ref.invalidate(loanDashboardProvider);

    ref.invalidate(pendingReceivablesProvider);

    ref.invalidate(pendingPayablesProvider);

    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final editing = widget.loanId != null;

    return Scaffold(
      appBar: AppBar(title: Text(editing ? 'Edit Loan' : 'Add Loan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: personController,
              decoration: const InputDecoration(labelText: 'Person Name'),
            ),

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),

            DropdownButton<String>(
              value: loanType,
              items: const [
                DropdownMenuItem(
                  value: 'receivable',
                  child: Text('Receivable'),
                ),
                DropdownMenuItem(value: 'payable', child: Text('Payable')),
              ],
              onChanged: (value) {
                setState(() {
                  loanType = value!;
                });
              },
            ),

            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: 'Note'),
            ),

            ElevatedButton(
              onPressed: saveLoan,
              child: Text(editing ? 'Update Loan' : 'Save Loan'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    personController.dispose();
    amountController.dispose();
    noteController.dispose();

    super.dispose();
  }
}
