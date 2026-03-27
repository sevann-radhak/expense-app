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

  /// Placeholder body on the settings screen.
  ///
  /// In en, this message translates to:
  /// **'Language, currency, and card profiles will be configured here.'**
  String get settingsPlaceholder;

  /// Section title for the Phase 1.1 debug list of categories from Drift.
  ///
  /// In en, this message translates to:
  /// **'Categories (database)'**
  String get categoriesDebugHeading;

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

  /// No description provided for @expenseCurrencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Currency code'**
  String get expenseCurrencyLabel;

  /// No description provided for @expenseFxToUsdLabel.
  ///
  /// In en, this message translates to:
  /// **'FX to USD (multiply amount by this)'**
  String get expenseFxToUsdLabel;

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
  /// **'FX rate must be a positive number.'**
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

  /// No description provided for @expenseListUsd.
  ///
  /// In en, this message translates to:
  /// **'USD {amount}'**
  String expenseListUsd(String amount);

  /// No description provided for @expenseListOriginal.
  ///
  /// In en, this message translates to:
  /// **'{amount} {currency}'**
  String expenseListOriginal(String amount, String currency);

  /// No description provided for @expenseListCardBadge.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get expenseListCardBadge;

  /// No description provided for @expensesThisMonthHeading.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get expensesThisMonthHeading;

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
