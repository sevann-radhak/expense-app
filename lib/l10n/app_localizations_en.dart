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
  String get navHome => 'Expenses';

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
  String get reportsMonthColumnIncomeUsd => 'Income';

  @override
  String get reportsMonthColumnExpenseUsd => 'Expenses';

  @override
  String get reportsMonthColumnNetUsd => 'Net';

  @override
  String get reportsYearMonthlyCashflowHeading =>
      'Monthly income and expenses (USD)';

  @override
  String get reportsFxFootnote =>
      'USD uses each line’s stored FX snapshot (expenses and income); original-currency amounts in forms are for reference.';

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
  String get reportsByCategoryNoExpensesOrIncome =>
      'No expenses or income in this period for the selected filter.';

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
  String get reportsChartIncomeCategoryTitle => 'Income by category (chart)';

  @override
  String get reportsChartMonthlySemanticLabel =>
      'Bar chart of total USD spent per calendar month for the selected year.';

  @override
  String get reportsChartMonthlyCashflowTitle => 'Income vs expenses (chart)';

  @override
  String get reportsChartLegendIncome => 'Income';

  @override
  String get reportsChartLegendExpenses => 'Expenses';

  @override
  String get reportsChartLegendIncomeSettled => 'Income — paid/received';

  @override
  String get reportsChartLegendIncomePending => 'Income — scheduled';

  @override
  String get reportsChartLegendExpenseSettled => 'Expenses — paid';

  @override
  String get reportsChartLegendExpensePending => 'Expenses — scheduled';

  @override
  String get reportsChartCashflowStackFootnote =>
      'Bars are stacked: lower segment = paid or received (confirmed); upper = still scheduled (not yet confirmed).';

  @override
  String get reportsChartTooltipPaidReceived => 'Paid/received';

  @override
  String get reportsChartTooltipStillScheduled => 'Still scheduled';

  @override
  String get reportsChartCashflowSemanticLabel =>
      'Grouped bar chart of monthly income and expenses in U.S. dollars for the selected year.';

  @override
  String reportsChartPeriodWholeYearLabel(String year) {
    return 'Full year $year';
  }

  @override
  String reportsChartPeriodCashflowSemanticLabel(String period) {
    return 'Bar chart comparing total income and total expenses in U.S. dollars for $period.';
  }

  @override
  String get reportsChartCategorySemanticLabel =>
      'Doughnut chart of USD share by category for the selected period, with a text legend.';

  @override
  String get reportsChartIncomeCategorySemanticLabel =>
      'Doughnut chart of income USD share by income category for the selected period, with a text legend.';

  @override
  String get reportsExpenseInclusionAll => 'All';

  @override
  String get reportsExpenseInclusionRealized => 'Realized';

  @override
  String get reportsExpenseInclusionScheduled => 'Scheduled';

  @override
  String get reportsExpenseInclusionFootnote =>
      'Realized = date on or before today; scheduled = after today (local calendar; time ignored). Applies to both expenses and income. Totals refresh when data changes; they do not auto-update at midnight.';

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
  String get categoriesTabExpenses => 'Expenses';

  @override
  String get categoriesTabIncome => 'Income';

  @override
  String get categoriesIncomeScreenSubtitle =>
      'Income categories and subcategories (separate from expense taxonomy).';

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
  String get taxonomyNameLabel => 'Name';

  @override
  String get taxonomyAddCategoryFab => 'Add category';

  @override
  String get taxonomyAddSubcategoryButton => 'Add subcategory';

  @override
  String get taxonomyEditCategoryTitle => 'Edit category';

  @override
  String get taxonomyEditSubcategoryTitle => 'Edit subcategory';

  @override
  String get taxonomyNewCategoryTitle => 'New category';

  @override
  String get taxonomyNewSubcategoryTitle => 'New subcategory';

  @override
  String get taxonomyInactiveLabel => '(inactive)';

  @override
  String get taxonomyDeactivateCategoryTitle => 'Deactivate category?';

  @override
  String get taxonomyDeactivateCategoryMessage =>
      'It will disappear from pickers when adding expenses. Existing expenses and reports still use this category and its subcategories. All subcategories in this group are deactivated too.';

  @override
  String get taxonomyDeactivateSubcategoryTitle => 'Deactivate subcategory?';

  @override
  String get taxonomyDeactivateSubcategoryMessage =>
      'It will disappear from pickers. Existing expenses and reports still use it.';

  @override
  String get taxonomyDeactivateIncomeCategoryTitle =>
      'Deactivate income category?';

  @override
  String get taxonomyDeactivateIncomeCategoryMessage =>
      'It will disappear from pickers when adding income. Existing income and reports still use this category and its subcategories. All subcategories in this group are deactivated too.';

  @override
  String get taxonomyDeactivateIncomeSubcategoryTitle =>
      'Deactivate income subcategory?';

  @override
  String get taxonomyDeactivateIncomeSubcategoryMessage =>
      'It will disappear from pickers. Existing income and reports still use it.';

  @override
  String get taxonomyReactivateTooltip => 'Restore to pickers';

  @override
  String get taxonomyDeactivateCategoryTooltip => 'Deactivate category';

  @override
  String get taxonomyDeactivateSubcategoryTooltip => 'Deactivate subcategory';

  @override
  String get taxonomyMustBeActiveForNewEntry =>
      'Choose an active category and subcategory for new entries.';

  @override
  String get homeTitle => 'Expenses';

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
  String get expenseUsdComputedPrefix => 'Computed USD: ';

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
  String get expensesThisMonthHeading => 'Expense items';

  @override
  String get monthSummaryTitle => 'Month totals';

  @override
  String get monthSummaryTotalsConfirmedLabel => 'Confirmed';

  @override
  String get monthSummaryTotalsExpectedLabel => 'Still expected';

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
  String get settingsRecurringSeriesTileTitle => 'Recurring series';

  @override
  String get settingsRecurringSeriesTileSubtitle =>
      'Scheduled expenses and income';

  @override
  String get recurringHubAppBarTitle => 'Recurring series';

  @override
  String get recurringSeriesTabExpenses => 'Expenses';

  @override
  String get recurringSeriesTabIncome => 'Income';

  @override
  String get recurringSeriesScreenTitle => 'Recurring expenses';

  @override
  String get recurringSeriesEmpty =>
      'No recurring expense series yet. Add an expense and turn on “Make repeating”.';

  @override
  String get recurringSeriesIncomeEmpty =>
      'No recurring income series yet. Add income and turn on “Make repeating”.';

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
      'Future scheduled rows after today will be removed. Past and today’s lines stay in the book.';

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
  String get recurringSeriesDefaultTitleIncome => 'Recurring income';

  @override
  String get recurringIncomeSeriesEditTitle => 'Edit recurring income';

  @override
  String get incomeFormMakeRecurringLabel => 'Make repeating income';

  @override
  String get incomeFromRecurringBanner =>
      'This line is from a repeating income series. Choose whether amount, categories, FX, and notes apply to this date only or to this date and all later materialized rows (earlier rows and the series default note in Settings stay unchanged for notes). Use the row menu to skip or delete.';

  @override
  String get incomeListTileMenuTooltip => 'More options for this income';

  @override
  String get recurringTileActionUpdate => 'Update…';

  @override
  String get recurringTileActionDelete => 'Delete…';

  @override
  String get recurringDeleteScopeTitle => 'Delete scheduled occurrence';

  @override
  String get recurringDeleteScopeBody =>
      'Choose what to remove from your book.';

  @override
  String get recurringDeleteThisOccurrenceOnly => 'This occurrence only';

  @override
  String get recurringDeleteThisAndFuture => 'This and all later occurrences';

  @override
  String get recurringFormApplyScopeTitle => 'Apply changes to';

  @override
  String get recurringFormApplyThisOccurrenceOnly => 'This date only';

  @override
  String get recurringFormApplyThisAndFuture => 'This date and later rows';

  @override
  String get recurringSeriesMissingForUpdate =>
      'Could not load the recurring series to apply this change.';

  @override
  String get incomeRecurringActionConfirmReceived =>
      'Mark received (on schedule)';

  @override
  String get incomeRecurringActionReceivedEarly => 'Mark received early…';

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
      'This line is from a repeating expense. Choose whether amount, categories, card, FX, and notes apply to this date only or to this date and all later materialized rows (earlier rows and the series default note in Settings stay unchanged for notes). Use the row menu to skip or delete.';

  @override
  String get recurringMenuTooltip => 'More actions for this scheduled expense';

  @override
  String get recurringActionConfirmPaid => 'Mark paid (on schedule)';

  @override
  String get recurringActionPaidEarly => 'Mark paid early…';

  @override
  String get recurringActionSkip => 'Skip occurrence';

  @override
  String get recurringActionRestoreOccurrence => 'Restore occurrence';

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
  String get expenseFormSettlementSectionTitle => 'Payment status';

  @override
  String get expenseFormSettlementPaid => 'Paid';

  @override
  String get expenseFormSettlementUnpaid => 'Not paid yet';

  @override
  String get incomeFormSettlementSectionTitle => 'Receipt status';

  @override
  String get incomeFormSettlementReceived => 'Received';

  @override
  String get incomeFormSettlementNotReceived => 'Not received yet';

  @override
  String get reportsYearCashflowTitle => 'Cash flow (USD)';

  @override
  String get reportsYearIncomeUsdPrefix => 'Income: ';

  @override
  String get reportsYearExpenseUsdPrefix => 'Expenses: ';

  @override
  String get reportsYearNetUsdPrefix => 'Net: ';

  @override
  String get reportsByMonthNetUsdPrefix => 'Net this month (USD): ';

  @override
  String reportsYearIncomeUsdLine(String amount) {
    return 'Income: $amount';
  }

  @override
  String reportsYearExpenseUsdLine(String amount) {
    return 'Expenses: $amount';
  }

  @override
  String reportsYearNetUsdLine(String amount) {
    return 'Net: $amount';
  }

  @override
  String get reportsCashflowFootnote =>
      'Net = income minus expenses in USD (same inclusion filter as above). FX uses each line’s stored rate.';

  @override
  String get reportsByMonthIncomeHeading => 'Income';

  @override
  String reportsByMonthNetLine(String amount) {
    return 'Net this month (USD): $amount';
  }

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
