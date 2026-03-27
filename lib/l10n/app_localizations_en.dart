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

  @override
  String get addExpenseTitle => 'Add expense';

  @override
  String get editExpenseTitle => 'Edit expense';

  @override
  String get saveExpenseAction => 'Save';

  @override
  String get deleteExpenseAction => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirmDelete => 'Delete';

  @override
  String get deleteExpenseConfirmTitle => 'Delete expense?';

  @override
  String get deleteExpenseConfirmMessage => 'This cannot be undone.';

  @override
  String get expenseDateLabel => 'Date';

  @override
  String get expenseCategoryLabel => 'Category';

  @override
  String get expenseSubcategoryLabel => 'Subcategory';

  @override
  String get expenseAmountLabel => 'Amount';

  @override
  String get expenseCurrencyLabel => 'Currency';

  @override
  String expenseCurrencyCustom(String code) {
    return '$code (not in default table)';
  }

  @override
  String expenseFxTableAsOf(String asOf) {
    return 'Default rates as of: $asOf';
  }

  @override
  String get expenseFxHelper =>
      'How many units of this currency equal 1 USD (e.g. 1 USD = 1050 ARS). You can override the default.';

  @override
  String get expenseFxToUsdLabel => 'Units of this currency per 1 USD';

  @override
  String expenseUsdComputedLabel(String amount) {
    return 'Computed USD: $amount';
  }

  @override
  String get expensePaidWithCardLabel => 'Paid with credit card';

  @override
  String get expenseCategoryRequired => 'Choose a category.';

  @override
  String get expenseSubcategoryRequired => 'Choose a subcategory.';

  @override
  String get expenseNoSubcategories => 'No subcategories for this category.';

  @override
  String get expenseAmountRequired => 'Enter an amount.';

  @override
  String get expenseAmountInvalid => 'Invalid number.';

  @override
  String get expenseCurrencyRequired => 'Enter a currency code.';

  @override
  String get expenseFxRequired => 'Enter an FX rate.';

  @override
  String get expenseFxInvalid => 'Enter a positive number (units per 1 USD).';

  @override
  String get invalidSubcategoryPairing =>
      'That subcategory does not belong to the selected category.';

  @override
  String get addExpenseTooltip => 'Add expense';

  @override
  String expenseListUsd(String amount) {
    return 'USD $amount';
  }

  @override
  String expenseListOriginal(String amount, String currency) {
    return '$amount $currency';
  }

  @override
  String get expenseListCardBadge => 'Card';

  @override
  String get expensesThisMonthHeading => 'This month';

  @override
  String get monthPickerPrevious => 'Previous month';

  @override
  String get monthPickerNext => 'Next month';

  @override
  String get settingsResetDataTitle => 'Reset all local data?';

  @override
  String get settingsResetDataMessage =>
      'This deletes every expense and resets categories to the built-in list (including Other). This cannot be undone.';

  @override
  String get settingsResetDataButton => 'Reset database (dev)';

  @override
  String get settingsResetDataConfirm => 'Reset everything';

  @override
  String get settingsResetDataSuccess =>
      'Local database reset to initial seed.';
}
