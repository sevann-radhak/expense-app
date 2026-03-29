import 'package:expense_app/domain/domain.dart';

/// Full local book export (categories, subcategories, instruments, expenses).
///
/// [schemaVersion] is bumped when the JSON shape changes.
final class BookBackupSnapshot {
  const BookBackupSnapshot({
    required this.schemaVersion,
    required this.exportedAt,
    required this.categories,
    required this.subcategories,
    required this.paymentInstruments,
    required this.expenses,
  });

  static const int currentSchemaVersion = 1;

  final int schemaVersion;
  final DateTime exportedAt;
  final List<Category> categories;
  final List<Subcategory> subcategories;
  final List<PaymentInstrument> paymentInstruments;
  final List<Expense> expenses;
}
