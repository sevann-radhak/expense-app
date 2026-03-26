// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Expense Tracker';

  @override
  String get navHome => 'Home';

  @override
  String get navSettings => 'Settings';

  @override
  String get homeTitle => 'Home';

  @override
  String get homeEmptyState =>
      'No expenses for this month yet. Lists and filters will appear here.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsPlaceholder =>
      'Language, currency, and card profiles will be configured here.';

  @override
  String get categoriesDebugHeading => 'Categories (database)';

  @override
  String get cannotDeleteReservedSubcategory =>
      'This subcategory cannot be deleted.';
}
