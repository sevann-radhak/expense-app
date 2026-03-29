import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/data/local/category_seed.dart';
import 'package:expense_app/data/local/income_category_seed.dart';

/// Deletes all user data and reapplies the initial category seed (eight
/// categories + **Other** each). For development / QA only.
Future<void> resetLocalDatabaseToInitialState(AppDatabase db) async {
  await db.delete(db.expenses).go();
  await db.delete(db.incomeEntries).go();
  await db.delete(db.recExpenseSeries).go();
  await db.delete(db.installmentPlans).go();
  await db.delete(db.paymentInstruments).go();
  await db.delete(db.subcategories).go();
  await db.delete(db.categories).go();
  await db.delete(db.incomeSubcategories).go();
  await db.delete(db.incomeCategories).go();
  await CategorySeeder.ensureSeedData(db);
  await IncomeCategorySeeder.ensureSeedData(db);
}
