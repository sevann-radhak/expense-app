import 'package:flutter/widgets.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// App-wide icon set: [Phosphor Icons](https://phosphoricons.com/) only.
///
/// Strategy: **light** stroke for normal UI (clean at small sizes), **fill** for
/// selected navigation destinations so active tabs read clearly.
abstract final class AppIcons {
  static const PhosphorIconsStyle _chrome = PhosphorIconsStyle.light;
  static const PhosphorIconsStyle _selected = PhosphorIconsStyle.fill;

  // —— Bottom / rail navigation ——
  static IconData get navExpenses => PhosphorIcons.receipt(_chrome);
  static IconData get navExpensesSelected => PhosphorIcons.receipt(_selected);

  static IconData get navIncome => PhosphorIcons.currencyCircleDollar(_chrome);
  static IconData get navIncomeSelected => PhosphorIcons.currencyCircleDollar(_selected);

  static IconData get navReports => PhosphorIcons.chartBar(_chrome);
  static IconData get navReportsSelected => PhosphorIcons.chartBar(_selected);

  static IconData get navCategories => PhosphorIcons.squaresFour(_chrome);
  static IconData get navCategoriesSelected => PhosphorIcons.squaresFour(_selected);

  static IconData get navSettings => PhosphorIcons.gear(_chrome);
  static IconData get navSettingsSelected => PhosphorIcons.gear(_selected);

  // —— Actions ——
  static IconData get add => PhosphorIcons.plus(_chrome);
  static IconData get edit => PhosphorIcons.pencilSimple(_chrome);
  static IconData get hideDeactivate => PhosphorIcons.eyeSlash(_chrome);
  static IconData get restore => PhosphorIcons.arrowCounterClockwise(_chrome);
  static IconData get delete => PhosphorIcons.trash(_chrome);
  static IconData get calendar => PhosphorIcons.calendarBlank(_chrome);
  static IconData get search => PhosphorIcons.magnifyingGlass(_chrome);
  static IconData get caretLeft => PhosphorIcons.caretLeft(_chrome);
  static IconData get caretRight => PhosphorIcons.caretRight(_chrome);
  static IconData get caretDown => PhosphorIcons.caretDown(_chrome);
  static IconData get download => PhosphorIcons.downloadSimple(_chrome);
  static IconData get creditCard => PhosphorIcons.creditCard(_chrome);
  static IconData get recurring => PhosphorIcons.arrowsClockwise(_chrome);
  static IconData get destructiveReset => PhosphorIcons.warningOctagon(_chrome);
  static IconData get listAdd => PhosphorIcons.listPlus(_chrome);
  static IconData get upload => PhosphorIcons.uploadSimple(_chrome);
  static IconData get moreVert => PhosphorIcons.dotsThreeVertical(_chrome);
}
