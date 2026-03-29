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
  /// **'Home'**
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

  /// Short note under the year summary when expenses exist.
  ///
  /// In en, this message translates to:
  /// **'USD uses each expense’s stored FX snapshot; original-currency chips are for reference.'**
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

  /// Screen reader summary for the monthly bar chart.
  ///
  /// In en, this message translates to:
  /// **'Bar chart of total USD spent per calendar month for the selected year.'**
  String get reportsChartMonthlySemanticLabel;

  /// Screen reader summary for the category chart.
  ///
  /// In en, this message translates to:
  /// **'Doughnut chart of USD share by category for the selected period, with a text legend.'**
  String get reportsChartCategorySemanticLabel;

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
  /// **'Realized = occurred on or before today; scheduled = after today, using your device’s local calendar date (time ignored). Totals refresh when data changes; they do not auto-update at midnight.'**
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

  /// App bar title on the home route.
  ///
  /// In en, this message translates to:
  /// **'Home'**
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
  /// **'Transactions'**
  String get expensesThisMonthHeading;

  /// Heading for per-currency spend summary on the home screen.
  ///
  /// In en, this message translates to:
  /// **'Month totals'**
  String get monthSummaryTitle;

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
