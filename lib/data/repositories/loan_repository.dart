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
}
