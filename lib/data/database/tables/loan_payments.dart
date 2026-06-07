import 'package:drift/drift.dart';

import 'loans.dart';

class LoanPayments extends Table {
  TextColumn get id => text()();

  TextColumn get loanId =>
      text().references(Loans, #id)();

  RealColumn get amount => real()();

  TextColumn get paymentDate => text()();

  TextColumn get note => text().nullable()();

  TextColumn get createdAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}