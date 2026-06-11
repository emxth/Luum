import 'package:drift/drift.dart';

import '../database/app_database.dart';

class LoanRepository {
  final AppDatabase database;

  LoanRepository(this.database);

  Future<void> createLoan(LoansCompanion loan) {
    return database.into(database.loans).insert(loan);
  }

  Future<List<Loan>> getAllLoans() {
    return (database.select(
      database.loans,
    )..orderBy([(t) => OrderingTerm.desc(t.loanDate)])).get();
  }

  Future<Loan?> getLoanById(String id) {
    return (database.select(
      database.loans,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> updateLoan(Loan loan) {
    return database.update(database.loans).replace(loan);
  }

  Future<void> deleteLoan(String id) async {
    await (database.delete(database.loans)..where((t) => t.id.equals(id))).go();
  }

  Future<void> addPayment(LoanPaymentsCompanion payment) async {
    await database.into(database.loanPayments).insert(payment);
  }

  Future<List<LoanPayment>> getPayments(String loanId) {
    return (database.select(database.loanPayments)
          ..where((t) => t.loanId.equals(loanId))
          ..orderBy([(t) => OrderingTerm.desc(t.paymentDate)]))
        .get();
  }

  Future<double> getTotalPaid(String loanId) async {
    final payments = await getPayments(loanId);

    return payments.fold<double>(0.0, (sum, item) => sum + item.amount);
  }

  Future<double> getRemainingBalance(String loanId) async {
    final loan = await getLoanById(loanId);

    if (loan == null) {
      return 0;
    }

    final paid = await getTotalPaid(loanId);

    return loan.amount - paid;
  }

  Future<void> updateLoanStatus(String loanId) async {
    final loan = await getLoanById(loanId);

    if (loan == null) {
      return;
    }

    final paid = await getTotalPaid(loanId);

    String status;

    if (paid <= 0) {
      status = 'pending';
    } else if (paid < loan.amount) {
      status = 'partial';
    } else {
      status = 'completed';
    }

    await (database.update(
      database.loans,
    )..where((t) => t.id.equals(loanId))).write(
      LoansCompanion(
        status: Value(status),
        updatedAt: Value(DateTime.now().toIso8601String()),
      ),
    );
  }

  Future<double> getTotalReceivable() async {
    final loans = await getAllLoans();

    double total = 0;

    for (final loan in loans) {
      if (loan.loanType != 'receivable') {
        continue;
      }

      final remaining = await getRemainingBalance(loan.id);

      total += remaining;
    }

    return total;
  }

  Future<double> getTotalPayable() async {
    final loans = await getAllLoans();

    double total = 0;

    for (final loan in loans) {
      if (loan.loanType != 'payable') {
        continue;
      }

      final remaining = await getRemainingBalance(loan.id);

      total += remaining;
    }

    return total;
  }

  Future<int> getPendingLoanCount() async {
    final loans = await getAllLoans();

    return loans.where((loan) => loan.status != 'completed').length;
  }

  Future<int> getCompletedLoanCount() async {
    final loans = await getAllLoans();

    return loans.where((loan) => loan.status == 'completed').length;
  }

  Future<List<LoanPayment>> getRecentPayments() {
    return (database.select(database.loanPayments)
          ..orderBy([(t) => OrderingTerm.desc(t.paymentDate)])
          ..limit(10))
        .get();
  }
}
