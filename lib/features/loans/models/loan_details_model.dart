import '../../../data/database/app_database.dart';

class LoanDetailsModel {
  final Loan loan;

  final double paid;

  final double remaining;

  final double progress;

  LoanDetailsModel({
    required this.loan,
    required this.paid,
    required this.remaining,
    required this.progress,
  });
}
