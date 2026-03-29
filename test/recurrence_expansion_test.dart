import 'package:flutter_test/flutter_test.dart';

import 'package:expense_app/domain/domain.dart';

void main() {
  group('expandRecurrenceOccurrences', () {
    test('monthly by calendar day clamps 31 across February', () {
      final dates = expandRecurrenceOccurrences(
        anchor: DateTime(2026, 1, 31),
        rule: const RecurrenceMonthlyByCalendarDay(calendarDay: 31),
        endCondition: const RecurrenceEndNever(),
        capEndInclusive: DateTime(2026, 3, 31),
      );
      expect(dates, [
        DateTime(2026, 1, 31),
        DateTime(2026, 2, 28),
        DateTime(2026, 3, 31),
      ]);
    });

    test('yearly Feb 29 clamps on non-leap years', () {
      final dates = expandRecurrenceOccurrences(
        anchor: DateTime(2024, 2, 29),
        rule: const RecurrenceYearly(month: 2, day: 29),
        endCondition: const RecurrenceEndNever(),
        capEndInclusive: DateTime(2027, 12, 31),
      );
      expect(dates, [
        DateTime(2024, 2, 29),
        DateTime(2025, 2, 28),
        DateTime(2026, 2, 28),
        DateTime(2027, 2, 28),
      ]);
    });

    test('monthly first Monday of month', () {
      final dates = expandRecurrenceOccurrences(
        anchor: DateTime(2026, 1, 1),
        rule: const RecurrenceMonthlyByWeekOrdinal(
          weekday: DateTime.monday,
          ordinal: WeekOrdinal.first,
        ),
        endCondition: const RecurrenceEndNever(),
        capEndInclusive: DateTime(2026, 3, 31),
      );
      expect(dates, [
        DateTime(2026, 1, 5),
        DateTime(2026, 2, 2),
        DateTime(2026, 3, 2),
      ]);
    });

    test('monthly last Friday of month', () {
      final dates = expandRecurrenceOccurrences(
        anchor: DateTime(2026, 1, 1),
        rule: const RecurrenceMonthlyByWeekOrdinal(
          weekday: DateTime.friday,
          ordinal: WeekOrdinal.last,
        ),
        endCondition: const RecurrenceEndNever(),
        capEndInclusive: DateTime(2026, 2, 28),
      );
      expect(dates, [
        DateTime(2026, 1, 30),
        DateTime(2026, 2, 27),
      ]);
    });

    test('end after count stops early', () {
      final dates = expandRecurrenceOccurrences(
        anchor: DateTime(2026, 1, 1),
        rule: const RecurrenceDaily(intervalDays: 1),
        endCondition: const RecurrenceEndAfterCount(occurrenceCount: 3),
        capEndInclusive: DateTime(2026, 12, 31),
      );
      expect(dates.length, 3);
      expect(dates.last, DateTime(2026, 1, 3));
    });

    test('recurrenceMaterializationHorizonEndInclusive spans months', () {
      final end = recurrenceMaterializationHorizonEndInclusive(
        DateTime(2026, 1, 15),
        2,
      );
      expect(end, DateTime(2026, 3, 31));
    });
  });
}
