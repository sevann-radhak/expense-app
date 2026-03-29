import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Application title (window switcher, toolbars).
  ///
  /// In en, this message translates to:
  /// **'Expense Tracker'**
  String get appTitle;

  /// Bottom navigation / rail label for home.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get navHome;

  /// Bottom navigation / rail label for settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// Bottom navigation / rail label for the categories screen.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get navCategories;

  /// Bottom navigation / rail label for the reports screen.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get navReports;

  /// App bar title on the reports route.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTitle;

  /// Heading for the annual spend summary card on Reports.
  ///
  /// In en, this message translates to:
  /// **'Year totals'**
  String get reportsYearSummaryTitle;

  /// Empty copy inside the year totals card.
  ///
  /// In en, this message translates to:
  /// **'No expenses recorded for this year yet.'**
  String get reportsYearNoExpenses;

  /// No description provided for @reportsYearPickerPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous year'**
  String get reportsYearPickerPrevious;

  /// No description provided for @reportsYearPickerNext.
  ///
  /// In en, this message translates to:
  /// **'Next year'**
  String get reportsYearPickerNext;

  /// Section title above the 12-month USD table.
  ///
  /// In en, this message translates to:
  /// **'Spend by month'**
  String get reportsByMonthHeading;

  /// No description provided for @reportsMonthColumnMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get reportsMonthColumnMonth;

  /// No description provided for @reportsMonthColumnUsdTotal.
  ///
  /// In en, this message translates to:
  /// **'USD (total)'**
  String get reportsMonthColumnUsdTotal;

  /// No description provided for @reportsMonthColumnIncomeUsd.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get reportsMonthColumnIncomeUsd;

  /// No description provided for @reportsMonthColumnExpenseUsd.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get reportsMonthColumnExpenseUsd;

  /// No description provided for @reportsMonthColumnNetUsd.
  ///
  /// In en, this message translates to:
  /// **'Net'**
  String get reportsMonthColumnNetUsd;

  /// Section title above the annual month table and dual bar chart.
  ///
  /// In en, this message translates to:
  /// **'Monthly income and expenses (USD)'**
  String get reportsYearMonthlyCashflowHeading;

  /// Short note under the year summary when expenses exist.
  ///
  /// In en, this message translates to:
  /// **'USD uses each line’s stored FX snapshot (expenses and income); original-currency amounts in forms are for reference.'**
  String get reportsFxFootnote;

  /// Reports tab: year overview.
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get reportsTabAnnual;

  /// Reports tab: list expenses for one month in the selected year.
  ///
  /// In en, this message translates to:
  /// **'By month'**
  String get reportsTabByMonth;

  /// Reports tab: USD totals and percentages by category.
  ///
  /// In en, this message translates to:
  /// **'By category'**
  String get reportsTabByCategory;

  /// Empty state on Reports By month tab.
  ///
  /// In en, this message translates to:
  /// **'No expenses in this month for the selected year.'**
  String get reportsByMonthEmpty;

  /// No description provided for @reportsByCategoryScopeYear.
  ///
  /// In en, this message translates to:
  /// **'Full year'**
  String get reportsByCategoryScopeYear;

  /// No description provided for @reportsByCategoryScopeMonth.
  ///
  /// In en, this message translates to:
  /// **'Single month'**
  String get reportsByCategoryScopeMonth;

  /// Empty category breakdown when there is no spend.
  ///
  /// In en, this message translates to:
  /// **'No expenses in this period.'**
  String get reportsByCategoryEmpty;

  /// Empty state when both expense and income totals are zero on By category.
  ///
  /// In en, this message translates to:
  /// **'No expenses or income in this period for the selected filter.'**
  String get reportsByCategoryNoExpensesOrIncome;

  /// No description provided for @reportsCategoryColumnCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get reportsCategoryColumnCategory;

  /// No description provided for @reportsCategoryColumnUsd.
  ///
  /// In en, this message translates to:
  /// **'USD (total)'**
  String get reportsCategoryColumnUsd;

  /// No description provided for @reportsCategoryColumnShare.
  ///
  /// In en, this message translates to:
  /// **'% of period'**
  String get reportsCategoryColumnShare;

  /// No description provided for @reportsSubcategoryColumnShare.
  ///
  /// In en, this message translates to:
  /// **'% of category'**
  String get reportsSubcategoryColumnShare;

  /// Explains denominators for category vs subcategory %.
  ///
  /// In en, this message translates to:
  /// **'Percentages use total USD in the selected period. Subcategory rows use that category’s USD as the total.'**
  String get reportsPercentFootnote;

  /// Heading above the annual bar chart on Reports.
  ///
  /// In en, this message translates to:
  /// **'Spend by month (chart)'**
  String get reportsChartMonthlyTitle;

  /// Heading above the category doughnut chart on Reports.
  ///
  /// In en, this message translates to:
  /// **'Spend by category (chart)'**
  String get reportsChartCategoryTitle;

  /// Heading above the income category doughnut on Reports By category.
  ///
  /// In en, this message translates to:
  /// **'Income by category (chart)'**
  String get reportsChartIncomeCategoryTitle;

  /// Screen reader summary for the monthly bar chart.
  ///
  /// In en, this message translates to:
  /// **'Bar chart of total USD spent per calendar month for the selected year.'**
  String get reportsChartMonthlySemanticLabel;

  /// No description provided for @reportsChartMonthlyCashflowTitle.
  ///
  /// In en, this message translates to:
  /// **'Income vs expenses (chart)'**
  String get reportsChartMonthlyCashflowTitle;

  /// No description provided for @reportsChartLegendIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get reportsChartLegendIncome;

  /// No description provided for @reportsChartLegendExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get reportsChartLegendExpenses;

  /// No description provided for @reportsChartLegendIncomeSettled.
  ///
  /// In en, this message translates to:
  /// **'Income — paid/received'**
  String get reportsChartLegendIncomeSettled;

  /// No description provided for @reportsChartLegendIncomePending.
  ///
  /// In en, this message translates to:
  /// **'Income — scheduled'**
  String get reportsChartLegendIncomePending;

  /// No description provided for @reportsChartLegendExpenseSettled.
  ///
  /// In en, this message translates to:
  /// **'Expenses — paid'**
  String get reportsChartLegendExpenseSettled;

  /// No description provided for @reportsChartLegendExpensePending.
  ///
  /// In en, this message translates to:
  /// **'Expenses — scheduled'**
  String get reportsChartLegendExpensePending;

  /// Explains stacked cashflow bars on Reports.
  ///
  /// In en, this message translates to:
  /// **'Bars are stacked: lower segment = paid or received (confirmed); upper = still scheduled (not yet confirmed).'**
  String get reportsChartCashflowStackFootnote;

  /// No description provided for @reportsChartTooltipPaidReceived.
  ///
  /// In en, this message translates to:
  /// **'Paid/received'**
  String get reportsChartTooltipPaidReceived;

  /// No description provided for @reportsChartTooltipStillScheduled.
  ///
  /// In en, this message translates to:
  /// **'Still scheduled'**
  String get reportsChartTooltipStillScheduled;

  /// Accessibility label for the annual cashflow bar chart.
  ///
  /// In en, this message translates to:
  /// **'Grouped bar chart of monthly income and expenses in U.S. dollars for the selected year.'**
  String get reportsChartCashflowSemanticLabel;

  /// Subtitle for income vs expenses chart when the scope is the entire calendar year.
  ///
  /// In en, this message translates to:
  /// **'Full year {year}'**
  String reportsChartPeriodWholeYearLabel(String year);

  /// Accessibility label for the single-period income vs expenses bar chart.
  ///
  /// In en, this message translates to:
  /// **'Bar chart comparing total income and total expenses in U.S. dollars for {period}.'**
  String reportsChartPeriodCashflowSemanticLabel(String period);

  /// Screen reader summary for the category chart.
  ///
  /// In en, this message translates to:
  /// **'Doughnut chart of USD share by category for the selected period, with a text legend.'**
  String get reportsChartCategorySemanticLabel;

  /// Accessibility label for the income category doughnut chart.
  ///
  /// In en, this message translates to:
  /// **'Doughnut chart of income USD share by income category for the selected period, with a text legend.'**
  String get reportsChartIncomeCategorySemanticLabel;

  /// Reports filter: include every expense in the period.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get reportsExpenseInclusionAll;

  /// Reports filter: expenses with date on or before local today.
  ///
  /// In en, this message translates to:
  /// **'Realized'**
  String get reportsExpenseInclusionRealized;

  /// Reports filter: expenses with date after local today (projected).
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get reportsExpenseInclusionScheduled;

  /// Explains realized vs scheduled rules under the Reports segmented control.
  ///
  /// In en, this message translates to:
  /// **'Realized = date on or before today; scheduled = after today (local calendar; time ignored). Applies to both expenses and income. Totals refresh when data changes; they do not auto-update at midnight.'**
  String get reportsExpenseInclusionFootnote;

  /// App bar action: download expenses for the active Reports tab as CSV.
  ///
  /// In en, this message translates to:
  /// **'Export current report as CSV'**
  String get reportsExportCsvTooltip;

  /// Shown when export is triggered on a non-web platform.
  ///
  /// In en, this message translates to:
  /// **'CSV export is available on the web app in this version.'**
  String get reportsExportCsvUnavailable;

  /// Brief confirmation after starting a web CSV download.
  ///
  /// In en, this message translates to:
  /// **'CSV download started.'**
  String get reportsExportCsvSuccess;

  /// Prefix before an error detail when CSV export fails.
  ///
  /// In en, this message translates to:
  /// **'Could not export CSV'**
  String get reportsExportCsvFailed;

  /// When export is tapped while expense stream is loading.
  ///
  /// In en, this message translates to:
  /// **'Report data is still loading; try again in a moment.'**
  String get reportsExportCsvLoading;

  /// App bar menu: choose CSV (scoped report) or JSON (full book backup).
  ///
  /// In en, this message translates to:
  /// **'Export data'**
  String get reportsExportMenuTooltip;

  /// Menu item: export visible report slice as CSV.
  ///
  /// In en, this message translates to:
  /// **'Current report as CSV'**
  String get reportsExportFormatCsv;

  /// Menu item: export entire local book as JSON.
  ///
  /// In en, this message translates to:
  /// **'Full book as JSON backup'**
  String get reportsExportFormatJson;

  /// After starting a web JSON full-book download.
  ///
  /// In en, this message translates to:
  /// **'JSON backup download started.'**
  String get reportsExportJsonSuccess;

  /// Prefix when full-book JSON export fails.
  ///
  /// In en, this message translates to:
  /// **'Could not export JSON backup'**
  String get reportsExportJsonFailed;

  /// Non-web: full JSON export unavailable.
  ///
  /// In en, this message translates to:
  /// **'JSON backup export is available on the web app in this version.'**
  String get reportsExportJsonWebOnly;

  /// Heading for JSON import of a full book backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get settingsBackupSectionTitle;

  /// Explains destructive JSON import and points to export location.
  ///
  /// In en, this message translates to:
  /// **'Restore a file created with Reports → Full book as JSON backup. This replaces all expenses, categories, subcategories, and card profiles in this browser.'**
  String get settingsBackupImportDescription;

  /// Opens file picker for backup JSON.
  ///
  /// In en, this message translates to:
  /// **'Import JSON backup…'**
  String get settingsBackupImportButton;

  /// Confirm dialog title for JSON import.
  ///
  /// In en, this message translates to:
  /// **'Replace everything from backup?'**
  String get settingsBackupImportTitle;

  /// Confirm dialog body for JSON import.
  ///
  /// In en, this message translates to:
  /// **'All current data will be deleted and replaced by the backup. This cannot be undone.'**
  String get settingsBackupImportMessage;

  /// Confirm destructive import.
  ///
  /// In en, this message translates to:
  /// **'Replace all data'**
  String get settingsBackupImportConfirm;

  /// Snackbar after successful JSON import.
  ///
  /// In en, this message translates to:
  /// **'Backup imported.'**
  String get settingsBackupImportSuccess;

  /// Snackbar when import succeeded after dropping or fixing inconsistent rows.
  ///
  /// In en, this message translates to:
  /// **'Backup imported. Skipped {expensesSkipped} expense(s) with invalid links; cleared {paymentLinksCleared} invalid card link(s); dropped {subcategoriesDropped} orphan subcategor(ies).'**
  String settingsBackupImportRepaired(
    int expensesSkipped,
    int paymentLinksCleared,
    int subcategoriesDropped,
  );

  /// Prefix when JSON import fails.
  ///
  /// In en, this message translates to:
  /// **'Could not import backup'**
  String get settingsBackupImportFailed;

  /// Non-web: backup import unavailable.
  ///
  /// In en, this message translates to:
  /// **'JSON import is available on the web app in this version.'**
  String get settingsImportJsonWebOnly;

  /// Short intro under the categories screen app bar.
  ///
  /// In en, this message translates to:
  /// **'Taxonomy from your local database (debug / admin).'**
  String get categoriesScreenSubtitle;

  /// No description provided for @categoriesTabExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get categoriesTabExpenses;

  /// No description provided for @categoriesTabIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get categoriesTabIncome;

  /// Intro under the income categories tab.
  ///
  /// In en, this message translates to:
  /// **'Income categories and subcategories (separate from expense taxonomy).'**
  String get categoriesIncomeScreenSubtitle;

  /// Fallback label when a category or subcategory name cannot be resolved (ids are not shown).
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get taxonomyUnknownLabel;

  /// Dialog title when editing a category description.
  ///
  /// In en, this message translates to:
  /// **'Category note'**
  String get categoryEditDescriptionTitle;

  /// Dialog title when editing a subcategory description.
  ///
  /// In en, this message translates to:
  /// **'Subcategory note'**
  String get subcategoryEditDescriptionTitle;

  /// Text field label for optional taxonomy descriptions.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get categoryDescriptionLabel;

  /// Tooltip for edit actions on category and subcategory rows.
  ///
  /// In en, this message translates to:
  /// **'Edit note'**
  String get categoryEditDescriptionTooltip;

  /// App bar title on the monthly expenses route.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get homeTitle;

  /// Empty state on the home screen before expense data exists.
  ///
  /// In en, this message translates to:
  /// **'No expenses for this month yet. Lists and filters will appear here.'**
  String get homeEmptyState;

  /// App bar title on the settings route.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Heading for locale and default currency controls.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get settingsPreferencesSectionTitle;

  /// Label for the app language dropdown.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageLabel;

  /// Use the device locale for formatting and UI language when supported.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsLanguageSystem;

  /// Force English UI and formatting locale.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// Label for default ISO currency when opening the add-expense form.
  ///
  /// In en, this message translates to:
  /// **'Default currency for new expenses'**
  String get settingsDefaultCurrencyLabel;

  /// Dropdown entry meaning the JSON FX table default applies.
  ///
  /// In en, this message translates to:
  /// **'Use table default ({code})'**
  String settingsDefaultCurrencyCatalogDefault(String code);

  /// Heading for future sign-in / sync (placeholder).
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccountSectionTitle;

  /// Short note under Account while auth is out of scope.
  ///
  /// In en, this message translates to:
  /// **'Sign-in and multi-device sync are planned for a later phase.'**
  String get settingsAccountPlaceholder;

  /// Heading for credit card metadata list (no card numbers).
  ///
  /// In en, this message translates to:
  /// **'Card profiles'**
  String get settingsPaymentInstrumentsSectionTitle;

  /// Explains card profile scope and privacy.
  ///
  /// In en, this message translates to:
  /// **'Store labels, bank, billing cycle, and fee notes for your cards. Card numbers are never stored.'**
  String get settingsPaymentInstrumentsDescription;

  /// Button to create a payment instrument row.
  ///
  /// In en, this message translates to:
  /// **'Add card profile'**
  String get settingsPaymentInstrumentAdd;

  /// Dialog title when editing metadata.
  ///
  /// In en, this message translates to:
  /// **'Edit card profile'**
  String get settingsPaymentInstrumentEditTitle;

  /// Dialog title for a new profile.
  ///
  /// In en, this message translates to:
  /// **'New card profile'**
  String get settingsPaymentInstrumentCreateTitle;

  /// Display name for the card profile.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get settingsPaymentInstrumentLabel;

  /// Optional institution name.
  ///
  /// In en, this message translates to:
  /// **'Bank / issuer (optional)'**
  String get settingsPaymentInstrumentBank;

  /// Day of month for statement or cycle close.
  ///
  /// In en, this message translates to:
  /// **'Billing cycle day (1–31, optional)'**
  String get settingsPaymentInstrumentBillingDay;

  /// Numeric annual fee in your default currency.
  ///
  /// In en, this message translates to:
  /// **'Annual fee (optional)'**
  String get settingsPaymentInstrumentAnnualFee;

  /// Numeric monthly fee.
  ///
  /// In en, this message translates to:
  /// **'Monthly fee (optional)'**
  String get settingsPaymentInstrumentMonthlyFee;

  /// Free text for percentage fees or surcharges.
  ///
  /// In en, this message translates to:
  /// **'Fee notes (optional)'**
  String get settingsPaymentInstrumentFeeDescription;

  /// Confirm save in card profile dialog.
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get settingsPaymentInstrumentSave;

  /// Confirm delete dialog title.
  ///
  /// In en, this message translates to:
  /// **'Delete this card profile?'**
  String get settingsPaymentInstrumentDeleteTitle;

  /// Explains delete scope before paymentInstrumentId on expenses exists.
  ///
  /// In en, this message translates to:
  /// **'Expenses are not deleted; any link to this profile will need to be cleared separately later.'**
  String get settingsPaymentInstrumentDeleteMessage;

  /// Validation when label empty.
  ///
  /// In en, this message translates to:
  /// **'Enter a label.'**
  String get settingsPaymentInstrumentLabelRequired;

  /// Validation for billing cycle day field.
  ///
  /// In en, this message translates to:
  /// **'Use a day from 1 to 31, or leave empty.'**
  String get settingsPaymentInstrumentBillingDayInvalid;

  /// Empty list hint under card profiles.
  ///
  /// In en, this message translates to:
  /// **'No card profiles yet.'**
  String get settingsPaymentInstrumentNoneYet;

  /// Subtitle fragment for billing day.
  ///
  /// In en, this message translates to:
  /// **'Cycle day {day}'**
  String settingsPaymentInstrumentCycleDaySummary(int day);

  /// Shown when the user tries to delete the system Other row.
  ///
  /// In en, this message translates to:
  /// **'This subcategory cannot be deleted.'**
  String get cannotDeleteReservedSubcategory;

  /// No description provided for @addExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get addExpenseTitle;

  /// No description provided for @editExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit expense'**
  String get editExpenseTitle;

  /// No description provided for @saveExpenseAction.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveExpenseAction;

  /// No description provided for @deleteExpenseAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteExpenseAction;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get confirmDelete;

  /// No description provided for @deleteExpenseConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete expense?'**
  String get deleteExpenseConfirmTitle;

  /// No description provided for @deleteExpenseConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get deleteExpenseConfirmMessage;

  /// No description provided for @expenseDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get expenseDateLabel;

  /// No description provided for @expenseCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get expenseCategoryLabel;

  /// No description provided for @expenseSubcategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Subcategory'**
  String get expenseSubcategoryLabel;

  /// No description provided for @expenseAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get expenseAmountLabel;

  /// Optional free-text note on an expense.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get expenseNotesLabel;

  /// No description provided for @expenseCurrencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get expenseCurrencyLabel;

  /// No description provided for @expenseCurrencyCustom.
  ///
  /// In en, this message translates to:
  /// **'{code} (not in default table)'**
  String expenseCurrencyCustom(String code);

  /// No description provided for @expenseFxPresetHint.
  ///
  /// In en, this message translates to:
  /// **'Built-in rate ({asOf}). Change the field below if yours differs.'**
  String expenseFxPresetHint(String asOf);

  /// No description provided for @expenseFxFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Local units per 1 USD'**
  String get expenseFxFieldLabel;

  /// Shows recomputed USD from amount and FX.
  ///
  /// In en, this message translates to:
  /// **'Computed USD: {amount}'**
  String expenseUsdComputedLabel(String amount);

  /// No description provided for @expensePaidWithCardLabel.
  ///
  /// In en, this message translates to:
  /// **'Paid with credit card'**
  String get expensePaidWithCardLabel;

  /// Dropdown to link expense to a stored card metadata profile.
  ///
  /// In en, this message translates to:
  /// **'Card profile (optional)'**
  String get expenseCardProfileLabel;

  /// No card profile selected for a card-paid expense.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get expenseCardProfileNone;

  /// No description provided for @expenseCategoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose a category.'**
  String get expenseCategoryRequired;

  /// No description provided for @expenseSubcategoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose a subcategory.'**
  String get expenseSubcategoryRequired;

  /// No description provided for @expenseNoSubcategories.
  ///
  /// In en, this message translates to:
  /// **'No subcategories for this category.'**
  String get expenseNoSubcategories;

  /// No description provided for @expenseAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount.'**
  String get expenseAmountRequired;

  /// No description provided for @expenseAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid number.'**
  String get expenseAmountInvalid;

  /// No description provided for @expenseCurrencyRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a currency code.'**
  String get expenseCurrencyRequired;

  /// No description provided for @expenseFxRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter an FX rate.'**
  String get expenseFxRequired;

  /// No description provided for @expenseFxInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a positive number (units per 1 USD).'**
  String get expenseFxInvalid;

  /// No description provided for @invalidSubcategoryPairing.
  ///
  /// In en, this message translates to:
  /// **'That subcategory does not belong to the selected category.'**
  String get invalidSubcategoryPairing;

  /// No description provided for @addExpenseTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get addExpenseTooltip;

  /// No description provided for @expenseListCardBadge.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get expenseListCardBadge;

  /// No description provided for @expensesThisMonthHeading.
  ///
  /// In en, this message translates to:
  /// **'Expense items'**
  String get expensesThisMonthHeading;

  /// Heading for per-currency spend summary on the home screen.
  ///
  /// In en, this message translates to:
  /// **'Month totals'**
  String get monthSummaryTitle;

  /// Subheading for amounts already paid or received in the month summary card.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get monthSummaryTotalsConfirmedLabel;

  /// Subheading for scheduled amounts not yet paid or received in the month summary card.
  ///
  /// In en, this message translates to:
  /// **'Still expected'**
  String get monthSummaryTotalsExpectedLabel;

  /// No description provided for @monthSummaryUsdTotal.
  ///
  /// In en, this message translates to:
  /// **'USD total: {amount}'**
  String monthSummaryUsdTotal(String amount);

  /// Short empty copy inside the month totals card.
  ///
  /// In en, this message translates to:
  /// **'No expenses this month yet.'**
  String get monthSummaryNoExpenses;

  /// No description provided for @monthPickerPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get monthPickerPrevious;

  /// No description provided for @monthPickerNext.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get monthPickerNext;

  /// No description provided for @settingsResetDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset all local data?'**
  String get settingsResetDataTitle;

  /// No description provided for @settingsResetDataMessage.
  ///
  /// In en, this message translates to:
  /// **'This deletes every expense and resets categories to the built-in list (including Other). This cannot be undone.'**
  String get settingsResetDataMessage;

  /// No description provided for @settingsResetDataButton.
  ///
  /// In en, this message translates to:
  /// **'Reset database (dev)'**
  String get settingsResetDataButton;

  /// No description provided for @settingsResetDataConfirm.
  ///
  /// In en, this message translates to:
  /// **'Reset everything'**
  String get settingsResetDataConfirm;

  /// No description provided for @settingsResetDataSuccess.
  ///
  /// In en, this message translates to:
  /// **'Local database reset to initial seed.'**
  String get settingsResetDataSuccess;

  /// Heading above the optional demo expense loader in Settings.
  ///
  /// In en, this message translates to:
  /// **'Demo data'**
  String get settingsPopulateExampleDataSectionTitle;

  /// Explains demo populate behavior in Settings.
  ///
  /// In en, this message translates to:
  /// **'Adds about one year of sample expenses (mixed currencies) for testing reports. Removes any previous demo rows (ids starting with exp_demo). Your categories are not changed.'**
  String get settingsPopulateExampleDataDescription;

  /// Settings button to insert demo expenses.
  ///
  /// In en, this message translates to:
  /// **'Populate example data'**
  String get settingsPopulateExampleDataButton;

  /// Confirm dialog title for demo data.
  ///
  /// In en, this message translates to:
  /// **'Add example expenses?'**
  String get settingsPopulateExampleDataTitle;

  /// Confirm dialog body for demo data.
  ///
  /// In en, this message translates to:
  /// **'This inserts demo transactions for reports QA. Existing demo rows are replaced; other expenses are kept.'**
  String get settingsPopulateExampleDataMessage;

  /// Confirm action for demo populate.
  ///
  /// In en, this message translates to:
  /// **'Populate'**
  String get settingsPopulateExampleDataConfirm;

  /// Snackbar after demo populate succeeds.
  ///
  /// In en, this message translates to:
  /// **'Example data loaded.'**
  String get settingsPopulateExampleDataSuccess;

  /// Settings list tile title linking to recurring series management.
  ///
  /// In en, this message translates to:
  /// **'Recurring series'**
  String get settingsRecurringSeriesTileTitle;

  /// No description provided for @settingsRecurringSeriesTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scheduled expenses and income'**
  String get settingsRecurringSeriesTileSubtitle;

  /// No description provided for @recurringHubAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Recurring series'**
  String get recurringHubAppBarTitle;

  /// No description provided for @recurringSeriesTabExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get recurringSeriesTabExpenses;

  /// No description provided for @recurringSeriesTabIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get recurringSeriesTabIncome;

  /// No description provided for @recurringSeriesScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Recurring expenses'**
  String get recurringSeriesScreenTitle;

  /// No description provided for @recurringSeriesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No recurring expense series yet. Add an expense and turn on “Make repeating”.'**
  String get recurringSeriesEmpty;

  /// No description provided for @recurringSeriesIncomeEmpty.
  ///
  /// In en, this message translates to:
  /// **'No recurring income series yet. Add income and turn on “Make repeating”.'**
  String get recurringSeriesIncomeEmpty;

  /// No description provided for @recurringSeriesActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get recurringSeriesActive;

  /// No description provided for @recurringSeriesInactive.
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get recurringSeriesInactive;

  /// No description provided for @recurringSeriesHorizonMonths.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{# month ahead} other{# months ahead}}'**
  String recurringSeriesHorizonMonths(int count);

  /// No description provided for @recurringSeriesEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get recurringSeriesEdit;

  /// No description provided for @recurringSeriesStop.
  ///
  /// In en, this message translates to:
  /// **'Stop series'**
  String get recurringSeriesStop;

  /// No description provided for @recurringSeriesStopTitle.
  ///
  /// In en, this message translates to:
  /// **'Stop this series?'**
  String get recurringSeriesStopTitle;

  /// No description provided for @recurringSeriesStopBody.
  ///
  /// In en, this message translates to:
  /// **'Future scheduled rows after today will be removed. Past and today’s lines stay in the book.'**
  String get recurringSeriesStopBody;

  /// No description provided for @recurringSeriesStoppedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Series stopped.'**
  String get recurringSeriesStoppedSnackbar;

  /// No description provided for @recurringSeriesEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit recurring series'**
  String get recurringSeriesEditTitle;

  /// No description provided for @recurringSeriesAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get recurringSeriesAmountLabel;

  /// No description provided for @recurringSeriesHorizonLabel.
  ///
  /// In en, this message translates to:
  /// **'Horizon (months)'**
  String get recurringSeriesHorizonLabel;

  /// No description provided for @recurringSeriesDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get recurringSeriesDescriptionLabel;

  /// No description provided for @recurringSeriesSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get recurringSeriesSave;

  /// No description provided for @recurringSeriesReadOnlyRule.
  ///
  /// In en, this message translates to:
  /// **'Repeat pattern'**
  String get recurringSeriesReadOnlyRule;

  /// No description provided for @recurringSeriesDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Recurring expense'**
  String get recurringSeriesDefaultTitle;

  /// No description provided for @recurringSeriesDefaultTitleIncome.
  ///
  /// In en, this message translates to:
  /// **'Recurring income'**
  String get recurringSeriesDefaultTitleIncome;

  /// No description provided for @recurringIncomeSeriesEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit recurring income'**
  String get recurringIncomeSeriesEditTitle;

  /// No description provided for @incomeFormMakeRecurringLabel.
  ///
  /// In en, this message translates to:
  /// **'Make repeating income'**
  String get incomeFormMakeRecurringLabel;

  /// No description provided for @incomeFromRecurringBanner.
  ///
  /// In en, this message translates to:
  /// **'This line is from a repeating income series. Choose whether amount, categories, FX, and notes apply to this date only or to this date and all later materialized rows (earlier rows and the series default note in Settings stay unchanged for notes). Use the row menu to skip or delete.'**
  String get incomeFromRecurringBanner;

  /// Tooltip on the income row overflow (three-dot) menu.
  ///
  /// In en, this message translates to:
  /// **'More options for this income'**
  String get incomeListTileMenuTooltip;

  /// No description provided for @recurringTileActionUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update…'**
  String get recurringTileActionUpdate;

  /// No description provided for @recurringTileActionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete…'**
  String get recurringTileActionDelete;

  /// No description provided for @recurringDeleteScopeTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete scheduled occurrence'**
  String get recurringDeleteScopeTitle;

  /// No description provided for @recurringDeleteScopeBody.
  ///
  /// In en, this message translates to:
  /// **'Choose what to remove from your book.'**
  String get recurringDeleteScopeBody;

  /// No description provided for @recurringDeleteThisOccurrenceOnly.
  ///
  /// In en, this message translates to:
  /// **'This occurrence only'**
  String get recurringDeleteThisOccurrenceOnly;

  /// No description provided for @recurringDeleteThisAndFuture.
  ///
  /// In en, this message translates to:
  /// **'This and all later occurrences'**
  String get recurringDeleteThisAndFuture;

  /// No description provided for @recurringFormApplyScopeTitle.
  ///
  /// In en, this message translates to:
  /// **'Apply changes to'**
  String get recurringFormApplyScopeTitle;

  /// No description provided for @recurringFormApplyThisOccurrenceOnly.
  ///
  /// In en, this message translates to:
  /// **'This date only'**
  String get recurringFormApplyThisOccurrenceOnly;

  /// No description provided for @recurringFormApplyThisAndFuture.
  ///
  /// In en, this message translates to:
  /// **'This date and later rows'**
  String get recurringFormApplyThisAndFuture;

  /// No description provided for @recurringSeriesMissingForUpdate.
  ///
  /// In en, this message translates to:
  /// **'Could not load the recurring series to apply this change.'**
  String get recurringSeriesMissingForUpdate;

  /// No description provided for @incomeRecurringActionConfirmReceived.
  ///
  /// In en, this message translates to:
  /// **'Mark received (on schedule)'**
  String get incomeRecurringActionConfirmReceived;

  /// No description provided for @incomeRecurringActionReceivedEarly.
  ///
  /// In en, this message translates to:
  /// **'Mark received early…'**
  String get incomeRecurringActionReceivedEarly;

  /// No description provided for @expenseFormMakeRecurringLabel.
  ///
  /// In en, this message translates to:
  /// **'Make repeating expense'**
  String get expenseFormMakeRecurringLabel;

  /// No description provided for @expenseFormRecurrenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get expenseFormRecurrenceLabel;

  /// No description provided for @expenseFormRecurrenceMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly (same calendar day)'**
  String get expenseFormRecurrenceMonthly;

  /// No description provided for @expenseFormRecurrenceWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly (same weekday)'**
  String get expenseFormRecurrenceWeekly;

  /// No description provided for @expenseFormHorizonMonthsLabel.
  ///
  /// In en, this message translates to:
  /// **'Generate months ahead'**
  String get expenseFormHorizonMonthsLabel;

  /// No description provided for @expenseFormHorizonMonthsInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a horizon between 1 and 120 months.'**
  String get expenseFormHorizonMonthsInvalid;

  /// No description provided for @expenseFromRecurringBanner.
  ///
  /// In en, this message translates to:
  /// **'This line is from a repeating expense. Choose whether amount, categories, card, FX, and notes apply to this date only or to this date and all later materialized rows (earlier rows and the series default note in Settings stay unchanged for notes). Use the row menu to skip or delete.'**
  String get expenseFromRecurringBanner;

  /// No description provided for @recurringMenuTooltip.
  ///
  /// In en, this message translates to:
  /// **'More actions for this scheduled expense'**
  String get recurringMenuTooltip;

  /// No description provided for @recurringActionConfirmPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark paid (on schedule)'**
  String get recurringActionConfirmPaid;

  /// No description provided for @recurringActionPaidEarly.
  ///
  /// In en, this message translates to:
  /// **'Mark paid early…'**
  String get recurringActionPaidEarly;

  /// No description provided for @recurringActionSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip occurrence'**
  String get recurringActionSkip;

  /// Row menu: bring a skipped recurring occurrence back to expected.
  ///
  /// In en, this message translates to:
  /// **'Restore occurrence'**
  String get recurringActionRestoreOccurrence;

  /// No description provided for @recurringActionWaive.
  ///
  /// In en, this message translates to:
  /// **'Waive'**
  String get recurringActionWaive;

  /// No description provided for @paymentExpectationExpectedShort.
  ///
  /// In en, this message translates to:
  /// **'Expected'**
  String get paymentExpectationExpectedShort;

  /// No description provided for @paymentExpectationConfirmedShort.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paymentExpectationConfirmedShort;

  /// No description provided for @paymentExpectationSkippedShort.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get paymentExpectationSkippedShort;

  /// No description provided for @paymentExpectationWaivedShort.
  ///
  /// In en, this message translates to:
  /// **'Waived'**
  String get paymentExpectationWaivedShort;

  /// No description provided for @recurrenceRuleDaily.
  ///
  /// In en, this message translates to:
  /// **'Every {interval} days'**
  String recurrenceRuleDaily(int interval);

  /// No description provided for @recurrenceRuleMonthlyDay.
  ///
  /// In en, this message translates to:
  /// **'Monthly on day {day}'**
  String recurrenceRuleMonthlyDay(int day);

  /// No description provided for @recurrenceRuleWeeklySimple.
  ///
  /// In en, this message translates to:
  /// **'Weekly on {weekday}'**
  String recurrenceRuleWeeklySimple(String weekday);

  /// No description provided for @recurrenceRuleWeeklyGeneric.
  ///
  /// In en, this message translates to:
  /// **'Every {weeks} weeks on selected weekdays'**
  String recurrenceRuleWeeklyGeneric(int weeks);

  /// No description provided for @recurrenceRuleYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly on {month}/{day}'**
  String recurrenceRuleYearly(int month, int day);

  /// No description provided for @recurrenceRuleOrdinal.
  ///
  /// In en, this message translates to:
  /// **'{ordinal} {weekday} each month'**
  String recurrenceRuleOrdinal(String ordinal, String weekday);

  /// No description provided for @recurrenceOrdinalFirst.
  ///
  /// In en, this message translates to:
  /// **'First'**
  String get recurrenceOrdinalFirst;

  /// No description provided for @recurrenceOrdinalSecond.
  ///
  /// In en, this message translates to:
  /// **'Second'**
  String get recurrenceOrdinalSecond;

  /// No description provided for @recurrenceOrdinalThird.
  ///
  /// In en, this message translates to:
  /// **'Third'**
  String get recurrenceOrdinalThird;

  /// No description provided for @recurrenceOrdinalFourth.
  ///
  /// In en, this message translates to:
  /// **'Fourth'**
  String get recurrenceOrdinalFourth;

  /// No description provided for @recurrenceOrdinalLast.
  ///
  /// In en, this message translates to:
  /// **'Last'**
  String get recurrenceOrdinalLast;

  /// No description provided for @recurringPaidEarlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Date paid'**
  String get recurringPaidEarlyTitle;

  /// No description provided for @recurringPaidEarlySave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get recurringPaidEarlySave;

  /// No description provided for @navIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get navIncome;

  /// No description provided for @incomeScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get incomeScreenTitle;

  /// No description provided for @incomeThisMonthHeading.
  ///
  /// In en, this message translates to:
  /// **'Income this month'**
  String get incomeThisMonthHeading;

  /// No description provided for @incomeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No income this month'**
  String get incomeEmptyTitle;

  /// No description provided for @incomeEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Tap + to record a deposit or inflow.'**
  String get incomeEmptyBody;

  /// No description provided for @incomeAddTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add income'**
  String get incomeAddTooltip;

  /// No description provided for @incomeFormAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add income'**
  String get incomeFormAddTitle;

  /// No description provided for @incomeFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit income'**
  String get incomeFormEditTitle;

  /// No description provided for @settingsPaymentInstrumentInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get settingsPaymentInstrumentInactive;

  /// No description provided for @settingsPaymentInstrumentDefaultBadge.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get settingsPaymentInstrumentDefaultBadge;

  /// No description provided for @settingsPaymentInstrumentSetDefault.
  ///
  /// In en, this message translates to:
  /// **'Set as default'**
  String get settingsPaymentInstrumentSetDefault;

  /// No description provided for @settingsPaymentInstrumentActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get settingsPaymentInstrumentActiveLabel;

  /// No description provided for @settingsPaymentInstrumentStatementClosingDay.
  ///
  /// In en, this message translates to:
  /// **'Statement closing day (1–31)'**
  String get settingsPaymentInstrumentStatementClosingDay;

  /// No description provided for @settingsPaymentInstrumentPaymentDueDay.
  ///
  /// In en, this message translates to:
  /// **'Payment due day (1–31)'**
  String get settingsPaymentInstrumentPaymentDueDay;

  /// No description provided for @settingsPaymentInstrumentNominalApr.
  ///
  /// In en, this message translates to:
  /// **'Nominal APR %'**
  String get settingsPaymentInstrumentNominalApr;

  /// No description provided for @settingsPaymentInstrumentCreditLimit.
  ///
  /// In en, this message translates to:
  /// **'Credit limit'**
  String get settingsPaymentInstrumentCreditLimit;

  /// No description provided for @settingsPaymentInstrumentDisplaySuffix.
  ///
  /// In en, this message translates to:
  /// **'Display suffix (e.g. last four)'**
  String get settingsPaymentInstrumentDisplaySuffix;

  /// No description provided for @expenseFormSplitInstallmentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Split into installment plan'**
  String get expenseFormSplitInstallmentsLabel;

  /// No description provided for @expenseFormInstallmentCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Number of payments'**
  String get expenseFormInstallmentCountLabel;

  /// No description provided for @expenseFormInstallmentCountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a number between 2 and 60.'**
  String get expenseFormInstallmentCountInvalid;

  /// No description provided for @expenseFormInstallmentNeedsCard.
  ///
  /// In en, this message translates to:
  /// **'Choose a card profile to use installments.'**
  String get expenseFormInstallmentNeedsCard;

  /// No description provided for @expenseFormInstallmentConflictRecurring.
  ///
  /// In en, this message translates to:
  /// **'Turn off repeating expense to use installments.'**
  String get expenseFormInstallmentConflictRecurring;

  /// No description provided for @expenseFormSettlementSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment status'**
  String get expenseFormSettlementSectionTitle;

  /// No description provided for @expenseFormSettlementPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get expenseFormSettlementPaid;

  /// No description provided for @expenseFormSettlementUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Not paid yet'**
  String get expenseFormSettlementUnpaid;

  /// No description provided for @incomeFormSettlementSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Receipt status'**
  String get incomeFormSettlementSectionTitle;

  /// No description provided for @incomeFormSettlementReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get incomeFormSettlementReceived;

  /// No description provided for @incomeFormSettlementNotReceived.
  ///
  /// In en, this message translates to:
  /// **'Not received yet'**
  String get incomeFormSettlementNotReceived;

  /// Heading for annual income vs expense summary.
  ///
  /// In en, this message translates to:
  /// **'Cash flow (USD)'**
  String get reportsYearCashflowTitle;

  /// Annual income total in USD.
  ///
  /// In en, this message translates to:
  /// **'Income: {amount}'**
  String reportsYearIncomeUsdLine(String amount);

  /// No description provided for @reportsYearExpenseUsdLine.
  ///
  /// In en, this message translates to:
  /// **'Expenses: {amount}'**
  String reportsYearExpenseUsdLine(String amount);

  /// No description provided for @reportsYearNetUsdLine.
  ///
  /// In en, this message translates to:
  /// **'Net: {amount}'**
  String reportsYearNetUsdLine(String amount);

  /// Explains annual net and FX.
  ///
  /// In en, this message translates to:
  /// **'Net = income minus expenses in USD (same inclusion filter as above). FX uses each line’s stored rate.'**
  String get reportsCashflowFootnote;

  /// No description provided for @reportsByMonthIncomeHeading.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get reportsByMonthIncomeHeading;

  /// No description provided for @reportsByMonthNetLine.
  ///
  /// In en, this message translates to:
  /// **'Net this month (USD): {amount}'**
  String reportsByMonthNetLine(String amount);

  /// No description provided for @reportsIncomeThisMonthLine.
  ///
  /// In en, this message translates to:
  /// **'Income this month (USD): {amount}'**
  String reportsIncomeThisMonthLine(String amount);

  /// No description provided for @expenseListCardLabel.
  ///
  /// In en, this message translates to:
  /// **'Card: {label}'**
  String expenseListCardLabel(String label);

  /// No description provided for @taxonomySearchCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'Search categories'**
  String get taxonomySearchCategoryHint;

  /// No description provided for @taxonomySearchSubcategoryHint.
  ///
  /// In en, this message translates to:
  /// **'Search subcategories'**
  String get taxonomySearchSubcategoryHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
