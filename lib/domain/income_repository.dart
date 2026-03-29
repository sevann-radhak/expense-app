import 'package:expense_app/domain/income_entry.dart';

abstract class IncomeRepository {
  Stream<List<IncomeEntry>> watchForMonth(int year, int month);

  Stream<List<IncomeEntry>> watchForYear(int year);

  Future<void> create(IncomeEntry entry);

  Future<void> update(IncomeEntry entry);

  Future<void> delete(String id);
}
