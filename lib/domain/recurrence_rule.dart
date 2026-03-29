import 'package:expense_app/domain/expense.dart';

/// Which instance of a weekday within a month (e.g. first Monday).
enum WeekOrdinal { first, second, third, fourth, last }

/// Calendar recurrence pattern (v1 custom model; not iCal RRULE).
sealed class RecurrenceRule {
  const RecurrenceRule();

  void validate();
}

/// Every [intervalDays] days from the anchor date (inclusive). [intervalDays] >= 1.
final class RecurrenceDaily extends RecurrenceRule {
  const RecurrenceDaily({required this.intervalDays});

  final int intervalDays;

  @override
  void validate() {
    if (intervalDays < 1) {
      throw ArgumentError.value(intervalDays, 'intervalDays', 'must be >= 1');
    }
  }
}

/// Every [intervalWeeks] weeks on [weekdays] (DateTime.weekday: Mon=1 … Sun=7).
/// [weekdays] must be non-empty; [intervalWeeks] >= 1.
final class RecurrenceWeekly extends RecurrenceRule {
  const RecurrenceWeekly({
    required this.intervalWeeks,
    required this.weekdays,
  });

  final int intervalWeeks;
  final Set<int> weekdays;

  @override
  void validate() {
    if (intervalWeeks < 1) {
      throw ArgumentError.value(intervalWeeks, 'intervalWeeks', 'must be >= 1');
    }
    if (weekdays.isEmpty) {
      throw ArgumentError('weekdays must be non-empty');
    }
    for (final w in weekdays) {
      if (w < DateTime.monday || w > DateTime.sunday) {
        throw ArgumentError.value(w, 'weekdays', 'must be 1–7 (DateTime.weekday)');
      }
    }
  }
}

/// Same calendar day each month; if the day exceeds the month length, use the last day
/// of that month (clamp).
final class RecurrenceMonthlyByCalendarDay extends RecurrenceRule {
  const RecurrenceMonthlyByCalendarDay({required this.calendarDay});

  /// 1–31.
  final int calendarDay;

  @override
  void validate() {
    if (calendarDay < 1 || calendarDay > 31) {
      throw ArgumentError.value(calendarDay, 'calendarDay', 'must be 1–31');
    }
  }
}

/// Nth [weekday] in each month (e.g. first Monday). If no such day exists (extremely rare),
/// that month is skipped.
final class RecurrenceMonthlyByWeekOrdinal extends RecurrenceRule {
  const RecurrenceMonthlyByWeekOrdinal({
    required this.weekday,
    required this.ordinal,
  });

  final int weekday;
  final WeekOrdinal ordinal;

  @override
  void validate() {
    if (weekday < DateTime.monday || weekday > DateTime.sunday) {
      throw ArgumentError.value(weekday, 'weekday', 'must be 1–7');
    }
  }
}

/// Same month and calendar day each year; day is clamped to month length (e.g. Feb 29 → Feb 28).
final class RecurrenceYearly extends RecurrenceRule {
  const RecurrenceYearly({required this.month, required this.day});

  final int month;
  final int day;

  @override
  void validate() {
    if (month < 1 || month > 12) {
      throw ArgumentError.value(month, 'month', 'must be 1–12');
    }
    if (day < 1 || day > 31) {
      throw ArgumentError.value(day, 'day', 'must be 1–31');
    }
  }
}

/// When recurrence stops (combined with a materialization horizon in the use case).
sealed class RecurrenceEndCondition {
  const RecurrenceEndCondition();

  void validate();
}

/// No explicit end; horizon only limits materialized rows.
final class RecurrenceEndNever extends RecurrenceEndCondition {
  const RecurrenceEndNever();

  @override
  void validate() {}
}

/// Stop after this calendar date (inclusive).
final class RecurrenceEndUntilDate extends RecurrenceEndCondition {
  const RecurrenceEndUntilDate({required this.untilDate});

  final DateTime untilDate;

  @override
  void validate() {
    ExpenseDates.toStorageDate(untilDate);
  }
}

/// Stop after this many occurrences from the anchor (inclusive of the first matching date).
final class RecurrenceEndAfterCount extends RecurrenceEndCondition {
  const RecurrenceEndAfterCount({required this.occurrenceCount});

  final int occurrenceCount;

  @override
  void validate() {
    if (occurrenceCount < 1) {
      throw ArgumentError.value(
        occurrenceCount,
        'occurrenceCount',
        'must be >= 1',
      );
    }
  }
}
