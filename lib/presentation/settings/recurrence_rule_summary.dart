import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';

String recurrenceRuleSummary(BuildContext context, RecurrenceRule rule) {
  final l10n = AppLocalizations.of(context)!;
  final locale = Localizations.localeOf(context).toString();
  return switch (rule) {
    RecurrenceDaily(:final intervalDays) => l10n.recurrenceRuleDaily(intervalDays),
    RecurrenceMonthlyByCalendarDay(:final calendarDay) =>
      l10n.recurrenceRuleMonthlyDay(calendarDay),
    RecurrenceWeekly(:final intervalWeeks, :final weekdays) =>
      intervalWeeks == 1 && weekdays.length == 1
          ? l10n.recurrenceRuleWeeklySimple(
              _weekdayName(weekdays.single, locale),
            )
          : l10n.recurrenceRuleWeeklyGeneric(intervalWeeks),
    RecurrenceYearly(:final month, :final day) =>
      l10n.recurrenceRuleYearly(month, day),
    RecurrenceMonthlyByWeekOrdinal(:final weekday, :final ordinal) =>
      l10n.recurrenceRuleOrdinal(
        _weekOrdinalLabel(context, ordinal),
        _weekdayName(weekday, locale),
      ),
  };
}

String _weekdayName(int weekday, String localeName) {
  return DateFormat.EEEE(localeName).format(DateTime(2020, 1, 5 + weekday));
}

String _weekOrdinalLabel(BuildContext context, WeekOrdinal o) {
  final l10n = AppLocalizations.of(context)!;
  return switch (o) {
    WeekOrdinal.first => l10n.recurrenceOrdinalFirst,
    WeekOrdinal.second => l10n.recurrenceOrdinalSecond,
    WeekOrdinal.third => l10n.recurrenceOrdinalThird,
    WeekOrdinal.fourth => l10n.recurrenceOrdinalFourth,
    WeekOrdinal.last => l10n.recurrenceOrdinalLast,
  };
}
