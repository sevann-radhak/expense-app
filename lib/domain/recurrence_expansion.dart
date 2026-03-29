import 'package:expense_app/domain/expense.dart';
import 'package:expense_app/domain/expense_inclusion.dart';
import 'package:expense_app/domain/recurrence_rule.dart';

/// Upper bound for generated dates: last calendar day of the month that is
/// [horizonMonths] months after [referenceDate]'s month (local calendar).
DateTime recurrenceMaterializationHorizonEndInclusive(
  DateTime referenceDate,
  int horizonMonths,
) {
  final ref = calendarDateOnly(referenceDate);
  final y = ref.year;
  final m = ref.month;
  final lastDay = DateTime(y, m + horizonMonths + 1, 0);
  return lastDay;
}

/// Expands [rule] into sorted unique calendar dates in `[anchor, capEnd]` intersected
/// with end condition and optional [maxDates] safety cap.
List<DateTime> expandRecurrenceOccurrences({
  required DateTime anchor,
  required RecurrenceRule rule,
  required RecurrenceEndCondition endCondition,
  required DateTime capEndInclusive,
  int maxDates = 5000,
}) {
  final a = calendarDateOnly(anchor);
  final cap = calendarDateOnly(capEndInclusive);
  if (cap.isBefore(a)) {
    return const [];
  }

  DateTime? untilInclusive;
  int? maxCount;
  switch (endCondition) {
    case RecurrenceEndNever():
      break;
    case RecurrenceEndUntilDate(:final untilDate):
      untilInclusive = calendarDateOnly(untilDate);
    case RecurrenceEndAfterCount(:final occurrenceCount):
      maxCount = occurrenceCount;
  }

  DateTime effectiveEnd = cap;
  if (untilInclusive != null && untilInclusive.isBefore(effectiveEnd)) {
    effectiveEnd = untilInclusive;
  }
  if (effectiveEnd.isBefore(a)) {
    return const [];
  }

  final raw = switch (rule) {
    RecurrenceDaily(:final intervalDays) => _expandDaily(
        a,
        effectiveEnd,
        intervalDays,
        maxCount,
        maxDates,
      ),
    RecurrenceWeekly(:final intervalWeeks, :final weekdays) => _expandWeekly(
        a,
        effectiveEnd,
        intervalWeeks,
        weekdays,
        maxCount,
        maxDates,
      ),
    RecurrenceMonthlyByCalendarDay(:final calendarDay) =>
      _expandMonthlyByDay(
        a,
        effectiveEnd,
        calendarDay,
        maxCount,
        maxDates,
      ),
    RecurrenceMonthlyByWeekOrdinal(:final weekday, :final ordinal) =>
      _expandMonthlyByWeekOrdinal(
        a,
        effectiveEnd,
        weekday,
        ordinal,
        maxCount,
        maxDates,
      ),
    RecurrenceYearly(:final month, :final day) => _expandYearly(
        a,
        effectiveEnd,
        month,
        day,
        maxCount,
        maxDates,
      ),
  };

  raw.sort();
  return raw;
}

bool _reachedLimit(List<DateTime> out, int? maxCount, int maxDates) {
  if (out.length >= maxDates) {
    return true;
  }
  if (maxCount != null && out.length >= maxCount) {
    return true;
  }
  return false;
}

List<DateTime> _expandDaily(
  DateTime anchor,
  DateTime endInclusive,
  int intervalDays,
  int? maxCount,
  int maxDates,
) {
  final out = <DateTime>[];
  var d = anchor;
  while (!d.isAfter(endInclusive)) {
    out.add(d);
    if (_reachedLimit(out, maxCount, maxDates)) {
      break;
    }
    d = DateTime(d.year, d.month, d.day + intervalDays);
  }
  return out;
}

int _mondayWeekIndex(DateTime dateOnly) {
  final monday = dateOnly.subtract(Duration(days: dateOnly.weekday - DateTime.monday));
  return monday.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
}

List<DateTime> _expandWeekly(
  DateTime anchor,
  DateTime endInclusive,
  int intervalWeeks,
  Set<int> weekdays,
  int? maxCount,
  int maxDates,
) {
  final out = <DateTime>[];
  final anchorIdx = _mondayWeekIndex(anchor);
  var d = anchor;
  while (!d.isAfter(endInclusive)) {
    if (weekdays.contains(d.weekday)) {
      final wIdx = _mondayWeekIndex(d);
      if ((wIdx - anchorIdx) % intervalWeeks == 0) {
        out.add(d);
        if (_reachedLimit(out, maxCount, maxDates)) {
          break;
        }
      }
    }
    d = DateTime(d.year, d.month, d.day + 1);
  }
  return out;
}

int _clampDayInMonth(int year, int month, int desiredDay) {
  final last = DateTime(year, month + 1, 0).day;
  return desiredDay > last ? last : desiredDay;
}

List<DateTime> _expandMonthlyByDay(
  DateTime anchor,
  DateTime endInclusive,
  int calendarDay,
  int? maxCount,
  int maxDates,
) {
  final out = <DateTime>[];
  var y = anchor.year;
  var m = anchor.month;
  while (true) {
    final day = _clampDayInMonth(y, m, calendarDay);
    final candidate = DateTime(y, m, day);
    if (!candidate.isBefore(anchor) && !candidate.isAfter(endInclusive)) {
      out.add(candidate);
      if (_reachedLimit(out, maxCount, maxDates)) {
        break;
      }
    }
    if (candidate.isAfter(endInclusive)) {
      break;
    }
    m++;
    if (m > 12) {
      m = 1;
      y++;
    }
    if (DateTime(y, m, 1).isAfter(endInclusive)) {
      break;
    }
  }
  return out;
}

DateTime? _nthWeekdayInMonth(int year, int month, int weekday, WeekOrdinal ordinal) {
  final lastDay = DateTime(year, month + 1, 0).day;
  if (ordinal == WeekOrdinal.last) {
    for (var d = lastDay; d >= 1; d--) {
      final dt = DateTime(year, month, d);
      if (dt.weekday == weekday) {
        return dt;
      }
    }
    return null;
  }
  final ord = ordinal.index + 1;
  var seen = 0;
  for (var d = 1; d <= lastDay; d++) {
    final dt = DateTime(year, month, d);
    if (dt.weekday == weekday) {
      seen++;
      if (seen == ord) {
        return dt;
      }
    }
  }
  return null;
}

List<DateTime> _expandMonthlyByWeekOrdinal(
  DateTime anchor,
  DateTime endInclusive,
  int weekday,
  WeekOrdinal ordinal,
  int? maxCount,
  int maxDates,
) {
  final out = <DateTime>[];
  var y = anchor.year;
  var m = anchor.month;
  while (true) {
    final dt = _nthWeekdayInMonth(y, m, weekday, ordinal);
    if (dt != null && !dt.isBefore(anchor) && !dt.isAfter(endInclusive)) {
      out.add(dt);
      if (_reachedLimit(out, maxCount, maxDates)) {
        break;
      }
    }
    if (DateTime(y, m, 1).isAfter(endInclusive)) {
      break;
    }
    m++;
    if (m > 12) {
      m = 1;
      y++;
    }
  }
  return out;
}

List<DateTime> _expandYearly(
  DateTime anchor,
  DateTime endInclusive,
  int month,
  int day,
  int? maxCount,
  int maxDates,
) {
  final out = <DateTime>[];
  for (var y = anchor.year; y <= endInclusive.year + 1; y++) {
    final d = _clampDayInMonth(y, month, day);
    final candidate = DateTime(y, month, d);
    if (candidate.isBefore(anchor) || candidate.isAfter(endInclusive)) {
      continue;
    }
    out.add(candidate);
    if (_reachedLimit(out, maxCount, maxDates)) {
      break;
    }
  }
  return out;
}

/// Deterministic id for a materialized expense from a series and date.
String materializedExpenseIdForSeriesDate({
  required String seriesId,
  required DateTime occurredOn,
}) {
  final iso = ExpenseDates.toStorageDate(occurredOn);
  return 'sr_${seriesId}_$iso';
}
