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
  String get navCategories => 'Categories';

  @override
  String get navReports => 'Reports';

  @override
  String get reportsTitle => 'Reports';

  @override
  String get reportsYearSummaryTitle => 'Year totals';

  @override
  String get reportsYearNoExpenses => 'No expenses recorded for this year yet.';

  @override
  String get reportsYearPickerPrevious => 'Previous year';

  @override
  String get reportsYearPickerNext => 'Next year';

  @override
  String get reportsByMonthHeading => 'Spend by month';

  @override
  String get reportsMonthColumnMonth => 'Month';

  @override
  String get reportsMonthColumnUsdTotal => 'USD (total)';

  @override
  String get reportsFxFootnote =>
      'USD uses each expense’s stored FX snapshot; original-currency chips are for reference.';

  @override
  String get reportsTabAnnual => 'Annual';

  @override
  String get reportsTabByMonth => 'By month';

  @override
  String get reportsTabByCategory => 'By category';

  @override
  String get reportsByMonthEmpty =>
      'No expenses in this month for the selected year.';

  @override
  String get reportsByCategoryScopeYear => 'Full year';

  @override
  String get reportsByCategoryScopeMonth => 'Single month';

  @override
  String get reportsByCategoryEmpty => 'No expenses in this period.';

  @override
  String get reportsCategoryColumnCategory => 'Category';

  @override
  String get reportsCategoryColumnUsd => 'USD (total)';

  @override
  String get reportsCategoryColumnShare => '% of period';

  @override
  String get reportsSubcategoryColumnShare => '% of category';

  @override
  String get reportsPercentFootnote =>
      'Percentages use total USD in the selected period. Subcategory rows use that category’s USD as the total.';

  @override
  String get reportsChartMonthlyTitle => 'Spend by month (chart)';

  @override
  String get reportsChartCategoryTitle => 'Spend by category (chart)';

  @override
  String get reportsChartMonthlySemanticLabel =>
      'Bar chart of total USD spent per calendar month for the selected year.';

  @override
  String get reportsChartCategorySemanticLabel =>
      'Doughnut chart of USD share by category for the selected period, with a text legend.';

  @override
  String get reportsExpenseInclusionAll => 'All';

  @override
  String get reportsExpenseInclusionRealized => 'Realized';

  @override
  String get reportsExpenseInclusionScheduled => 'Scheduled';

  @override
  String get reportsExpenseInclusionFootnote =>
      'Realized = occurred on or before today; scheduled = after today, using your device’s local calendar date (time ignored). Totals refresh when data changes; they do not auto-update at midnight.';

  @override
  String get reportsExportCsvTooltip => 'Export current report as CSV';

  @override
  String get reportsExportCsvUnavailable =>
      'CSV export is available on the web app in this version.';

  @override
  String get reportsExportCsvSuccess => 'CSV download started.';

  @override
  String get reportsExportCsvFailed => 'Could not export CSV';

  @override
  String get reportsExportCsvLoading =>
      'Report data is still loading; try again in a moment.';

  @override
  String get reportsExportMenuTooltip => 'Export data';

  @override
  String get reportsExportFormatCsv => 'Current report as CSV';

  @override
  String get reportsExportFormatJson => 'Full book as JSON backup';

  @override
  String get reportsExportJsonSuccess => 'JSON backup download started.';

  @override
  String get reportsExportJsonFailed => 'Could not export JSON backup';

  @override
  String get reportsExportJsonWebOnly =>
      'JSON backup export is available on the web app in this version.';

  @override
  String get settingsBackupSectionTitle => 'Backup';

  @override
  String get settingsBackupImportDescription =>
      'Restore a file created with Reports → Full book as JSON backup. This replaces all expenses, categories, subcategories, and card profiles in this browser.';

  @override
  String get settingsBackupImportButton => 'Import JSON backup…';

  @override
  String get settingsBackupImportTitle => 'Replace everything from backup?';

  @override
  String get settingsBackupImportMessage =>
      'All current data will be deleted and replaced by the backup. This cannot be undone.';

  @override
  String get settingsBackupImportConfirm => 'Replace all data';

  @override
  String get settingsBackupImportSuccess => 'Backup imported.';

  @override
  String settingsBackupImportRepaired(
    int expensesSkipped,
    int paymentLinksCleared,
    int subcategoriesDropped,
  ) {
    return 'Backup imported. Skipped $expensesSkipped expense(s) with invalid links; cleared $paymentLinksCleared invalid card link(s); dropped $subcategoriesDropped orphan subcategor(ies).';
  }

  @override
  String get settingsBackupImportFailed => 'Could not import backup';

  @override
  String get settingsImportJsonWebOnly =>
      'JSON import is available on the web app in this version.';

  @override
  String get categoriesScreenSubtitle =>
      'Taxonomy from your local database (debug / admin).';

  @override
  String get taxonomyUnknownLabel => 'Unknown';

  @override
  String get categoryEditDescriptionTitle => 'Category note';

  @override
  String get subcategoryEditDescriptionTitle => 'Subcategory note';

  @override
  String get categoryDescriptionLabel => 'Description (optional)';

  @override
  String get categoryEditDescriptionTooltip => 'Edit note';

  @override
  String get homeTitle => 'Home';

  @override
  String get homeEmptyState =>
      'No expenses for this month yet. Lists and filters will appear here.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsPreferencesSectionTitle => 'Preferences';

  @override
  String get settingsLanguageLabel => 'Language';

  @override
  String get settingsLanguageSystem => 'System default';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsDefaultCurrencyLabel =>
      'Default currency for new expenses';

  @override
  String settingsDefaultCurrencyCatalogDefault(String code) {
    return 'Use table default ($code)';
  }

  @override
  String get settingsAccountSectionTitle => 'Account';

  @override
  String get settingsAccountPlaceholder =>
      'Sign-in and multi-device sync are planned for a later phase.';

  @override
  String get settingsPaymentInstrumentsSectionTitle => 'Card profiles';

  @override
  String get settingsPaymentInstrumentsDescription =>
      'Store labels, bank, billing cycle, and fee notes for your cards. Card numbers are never stored.';

  @override
  String get settingsPaymentInstrumentAdd => 'Add card profile';

  @override
  String get settingsPaymentInstrumentEditTitle => 'Edit card profile';

  @override
  String get settingsPaymentInstrumentCreateTitle => 'New card profile';

  @override
  String get settingsPaymentInstrumentLabel => 'Label';

  @override
  String get settingsPaymentInstrumentBank => 'Bank / issuer (optional)';

  @override
  String get settingsPaymentInstrumentBillingDay =>
      'Billing cycle day (1–31, optional)';

  @override
  String get settingsPaymentInstrumentAnnualFee => 'Annual fee (optional)';

  @override
  String get settingsPaymentInstrumentMonthlyFee => 'Monthly fee (optional)';

  @override
  String get settingsPaymentInstrumentFeeDescription => 'Fee notes (optional)';

  @override
  String get settingsPaymentInstrumentSave => 'Save profile';

  @override
  String get settingsPaymentInstrumentDeleteTitle =>
      'Delete this card profile?';

  @override
  String get settingsPaymentInstrumentDeleteMessage =>
      'Expenses are not deleted; any link to this profile will need to be cleared separately later.';

  @override
  String get settingsPaymentInstrumentLabelRequired => 'Enter a label.';

  @override
  String get settingsPaymentInstrumentBillingDayInvalid =>
      'Use a day from 1 to 31, or leave empty.';

  @override
  String get settingsPaymentInstrumentNoneYet => 'No card profiles yet.';

  @override
  String settingsPaymentInstrumentCycleDaySummary(int day) {
    return 'Cycle day $day';
  }

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
  String get expenseNotesLabel => 'Notes (optional)';

  @override
  String get expenseCurrencyLabel => 'Currency';

  @override
  String expenseCurrencyCustom(String code) {
    return '$code (not in default table)';
  }

  @override
  String expenseFxPresetHint(String asOf) {
    return 'Built-in rate ($asOf). Change the field below if yours differs.';
  }

  @override
  String get expenseFxFieldLabel => 'Local units per 1 USD';

  @override
  String expenseUsdComputedLabel(String amount) {
    return 'Computed USD: $amount';
  }

  @override
  String get expensePaidWithCardLabel => 'Paid with credit card';

  @override
  String get expenseCardProfileLabel => 'Card profile (optional)';

  @override
  String get expenseCardProfileNone => 'None';

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
  String get expenseListCardBadge => 'Card';

  @override
  String get expensesThisMonthHeading => 'Transactions';

  @override
  String get monthSummaryTitle => 'Month totals';

  @override
  String monthSummaryUsdTotal(String amount) {
    return 'USD total: $amount';
  }

  @override
  String get monthSummaryNoExpenses => 'No expenses this month yet.';

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

  @override
  String get settingsPopulateExampleDataSectionTitle => 'Demo data';

  @override
  String get settingsPopulateExampleDataDescription =>
      'Adds about one year of sample expenses (mixed currencies) for testing reports. Removes any previous demo rows (ids starting with exp_demo). Your categories are not changed.';

  @override
  String get settingsPopulateExampleDataButton => 'Populate example data';

  @override
  String get settingsPopulateExampleDataTitle => 'Add example expenses?';

  @override
  String get settingsPopulateExampleDataMessage =>
      'This inserts demo transactions for reports QA. Existing demo rows are replaced; other expenses are kept.';

  @override
  String get settingsPopulateExampleDataConfirm => 'Populate';

  @override
  String get settingsPopulateExampleDataSuccess => 'Example data loaded.';

  @override
  String get settingsRecurringSeriesTileTitle => 'Recurring expenses';

  @override
  String get settingsRecurringSeriesTileSubtitle =>
      'Manage scheduled series and horizon';

  @override
  String get recurringSeriesScreenTitle => 'Recurring expenses';

  @override
  String get recurringSeriesEmpty =>
      'No recurring series yet. Add an expense and turn on “Make repeating”.';

  @override
  String get recurringSeriesActive => 'Active';

  @override
  String get recurringSeriesInactive => 'Stopped';

  @override
  String recurringSeriesHorizonMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# months ahead',
      one: '# month ahead',
    );
    return '$_temp0';
  }

  @override
  String get recurringSeriesEdit => 'Edit';

  @override
  String get recurringSeriesStop => 'Stop series';

  @override
  String get recurringSeriesStopTitle => 'Stop this series?';

  @override
  String get recurringSeriesStopBody =>
      'Future scheduled expenses after today will be removed. Past and today’s rows stay in the book.';

  @override
  String get recurringSeriesStoppedSnackbar => 'Series stopped.';

  @override
  String get recurringSeriesEditTitle => 'Edit recurring series';

  @override
  String get recurringSeriesAmountLabel => 'Amount';

  @override
  String get recurringSeriesHorizonLabel => 'Horizon (months)';

  @override
  String get recurringSeriesDescriptionLabel => 'Note';

  @override
  String get recurringSeriesSave => 'Save';

  @override
  String get recurringSeriesReadOnlyRule => 'Repeat pattern';

  @override
  String get recurringSeriesDefaultTitle => 'Recurring expense';

  @override
  String get expenseFormMakeRecurringLabel => 'Make repeating expense';

  @override
  String get expenseFormRecurrenceLabel => 'Repeat';

  @override
  String get expenseFormRecurrenceMonthly => 'Monthly (same calendar day)';

  @override
  String get expenseFormRecurrenceWeekly => 'Weekly (same weekday)';

  @override
  String get expenseFormHorizonMonthsLabel => 'Generate months ahead';

  @override
  String get expenseFormHorizonMonthsInvalid =>
      'Enter a horizon between 1 and 120 months.';

  @override
  String get expenseFromRecurringBanner =>
      'This line comes from a recurring series. Edits here apply only to this row. Change the series in Settings → Recurring expenses.';

  @override
  String get recurringMenuTooltip => 'Scheduled expense actions';

  @override
  String get recurringActionConfirmPaid => 'Mark paid (on schedule)';

  @override
  String get recurringActionPaidEarly => 'Mark paid early…';

  @override
  String get recurringActionSkip => 'Skip occurrence';

  @override
  String get recurringActionWaive => 'Waive';

  @override
  String get paymentExpectationExpectedShort => 'Expected';

  @override
  String get paymentExpectationConfirmedShort => 'Paid';

  @override
  String get paymentExpectationSkippedShort => 'Skipped';

  @override
  String get paymentExpectationWaivedShort => 'Waived';

  @override
  String recurrenceRuleDaily(int interval) {
    return 'Every $interval days';
  }

  @override
  String recurrenceRuleMonthlyDay(int day) {
    return 'Monthly on day $day';
  }

  @override
  String recurrenceRuleWeeklySimple(String weekday) {
    return 'Weekly on $weekday';
  }

  @override
  String recurrenceRuleWeeklyGeneric(int weeks) {
    return 'Every $weeks weeks on selected weekdays';
  }

  @override
  String recurrenceRuleYearly(int month, int day) {
    return 'Yearly on $month/$day';
  }

  @override
  String recurrenceRuleOrdinal(String ordinal, String weekday) {
    return '$ordinal $weekday each month';
  }

  @override
  String get recurrenceOrdinalFirst => 'First';

  @override
  String get recurrenceOrdinalSecond => 'Second';

  @override
  String get recurrenceOrdinalThird => 'Third';

  @override
  String get recurrenceOrdinalFourth => 'Fourth';

  @override
  String get recurrenceOrdinalLast => 'Last';

  @override
  String get recurringPaidEarlyTitle => 'Date paid';

  @override
  String get recurringPaidEarlySave => 'Save';

  @override
  String get navIncome => 'Income';

  @override
  String get incomeScreenTitle => 'Income';

  @override
  String get incomeThisMonthHeading => 'Income this month';

  @override
  String get incomeEmptyTitle => 'No income this month';

  @override
  String get incomeEmptyBody => 'Tap + to record a deposit or inflow.';

  @override
  String get incomeAddTooltip => 'Add income';

  @override
  String get incomeFormAddTitle => 'Add income';

  @override
  String get incomeFormEditTitle => 'Edit income';

  @override
  String get settingsPaymentInstrumentInactive => 'Inactive';

  @override
  String get settingsPaymentInstrumentDefaultBadge => 'Default';

  @override
  String get settingsPaymentInstrumentSetDefault => 'Set as default';

  @override
  String get settingsPaymentInstrumentActiveLabel => 'Active';

  @override
  String get settingsPaymentInstrumentStatementClosingDay =>
      'Statement closing day (1–31)';

  @override
  String get settingsPaymentInstrumentPaymentDueDay => 'Payment due day (1–31)';

  @override
  String get settingsPaymentInstrumentNominalApr => 'Nominal APR %';

  @override
  String get settingsPaymentInstrumentCreditLimit => 'Credit limit';

  @override
  String get settingsPaymentInstrumentDisplaySuffix =>
      'Display suffix (e.g. last four)';

  @override
  String get expenseFormSplitInstallmentsLabel => 'Split into installment plan';

  @override
  String get expenseFormInstallmentCountLabel => 'Number of payments';

  @override
  String get expenseFormInstallmentCountInvalid =>
      'Enter a number between 2 and 60.';

  @override
  String get expenseFormInstallmentNeedsCard =>
      'Choose a card profile to use installments.';

  @override
  String get expenseFormInstallmentConflictRecurring =>
      'Turn off repeating expense to use installments.';

  @override
  String reportsIncomeThisMonthLine(String amount) {
    return 'Income this month (USD): $amount';
  }

  @override
  String expenseListCardLabel(String label) {
    return 'Card: $label';
  }

  @override
  String get taxonomySearchCategoryHint => 'Search categories';

  @override
  String get taxonomySearchSubcategoryHint => 'Search subcategories';
}
