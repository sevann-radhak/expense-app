import 'package:expense_app/domain/domain.dart';

/// Stable JSON for Drift + book backup (`schemaVersion` 2+).
abstract final class RecurrenceJsonKeys {
  static const version = 'v';
  static const rule = 'rule';
  static const end = 'end';
  static const type = 'type';

  static const daily = 'daily';
  static const weekly = 'weekly';
  static const monthlyByDay = 'monthlyByDay';
  static const monthlyByWeekOrdinal = 'monthlyByWeekOrdinal';
  static const yearly = 'yearly';

  static const never = 'never';
  static const until = 'until';
  static const afterCount = 'afterCount';
}

Map<String, dynamic> encodeRecurrencePayload({
  required RecurrenceRule rule,
  required RecurrenceEndCondition endCondition,
}) {
  return <String, dynamic>{
    RecurrenceJsonKeys.version: 1,
    RecurrenceJsonKeys.rule: _encodeRule(rule),
    RecurrenceJsonKeys.end: _encodeEnd(endCondition),
  };
}

RecurrenceRule decodeRecurrenceRule(Map<String, dynamic> map) {
  final t = map[RecurrenceJsonKeys.type];
  if (t is! String) {
    throw const FormatException('recurrence rule type');
  }
  switch (t) {
    case RecurrenceJsonKeys.daily:
      final n = map['intervalDays'];
      if (n is! int && n is! num) {
        throw const FormatException('daily.intervalDays');
      }
      return RecurrenceDaily(intervalDays: (n as num).toInt());
    case RecurrenceJsonKeys.weekly:
      final iw = map['intervalWeeks'];
      final wd = map['weekdays'];
      if (iw is! int && iw is! num) {
        throw const FormatException('weekly.intervalWeeks');
      }
      if (wd is! List) {
        throw const FormatException('weekly.weekdays');
      }
      final set = wd.map((e) {
        if (e is! int && e is! num) {
          throw const FormatException('weekly.weekdays entry');
        }
        return (e as num).toInt();
      }).toSet();
      return RecurrenceWeekly(
        intervalWeeks: (iw as num).toInt(),
        weekdays: set,
      );
    case RecurrenceJsonKeys.monthlyByDay:
      final d = map['calendarDay'];
      if (d is! int && d is! num) {
        throw const FormatException('monthlyByDay.calendarDay');
      }
      return RecurrenceMonthlyByCalendarDay(
        calendarDay: (d as num).toInt(),
      );
    case RecurrenceJsonKeys.monthlyByWeekOrdinal:
      final w = map['weekday'];
      final o = map['ordinal'];
      if (w is! int && w is! num) {
        throw const FormatException('monthlyByWeekOrdinal.weekday');
      }
      if (o is! String) {
        throw const FormatException('monthlyByWeekOrdinal.ordinal');
      }
      final ord = WeekOrdinal.values.firstWhere(
        (e) => e.name == o,
        orElse: () => throw FormatException('unknown WeekOrdinal: $o'),
      );
      return RecurrenceMonthlyByWeekOrdinal(
        weekday: (w as num).toInt(),
        ordinal: ord,
      );
    case RecurrenceJsonKeys.yearly:
      final m = map['month'];
      final d = map['day'];
      if (m is! int && m is! num) {
        throw const FormatException('yearly.month');
      }
      if (d is! int && d is! num) {
        throw const FormatException('yearly.day');
      }
      return RecurrenceYearly(
        month: (m as num).toInt(),
        day: (d as num).toInt(),
      );
    default:
      throw FormatException('unknown recurrence rule: $t');
  }
}

RecurrenceEndCondition decodeRecurrenceEnd(Map<String, dynamic> map) {
  final t = map[RecurrenceJsonKeys.type];
  if (t is! String) {
    throw const FormatException('recurrence end type');
  }
  switch (t) {
    case RecurrenceJsonKeys.never:
      return const RecurrenceEndNever();
    case RecurrenceJsonKeys.until:
      final d = map['date'];
      if (d is! String) {
        throw const FormatException('until.date');
      }
      return RecurrenceEndUntilDate(untilDate: ExpenseDates.fromStorageDate(d));
    case RecurrenceJsonKeys.afterCount:
      final c = map['count'];
      if (c is! int && c is! num) {
        throw const FormatException('afterCount.count');
      }
      return RecurrenceEndAfterCount(
        occurrenceCount: (c as num).toInt(),
      );
    default:
      throw FormatException('unknown recurrence end: $t');
  }
}

Map<String, dynamic> _encodeRule(RecurrenceRule rule) {
  return switch (rule) {
    RecurrenceDaily(:final intervalDays) => <String, dynamic>{
        RecurrenceJsonKeys.type: RecurrenceJsonKeys.daily,
        'intervalDays': intervalDays,
      },
    RecurrenceWeekly(:final intervalWeeks, :final weekdays) => <String, dynamic>{
        RecurrenceJsonKeys.type: RecurrenceJsonKeys.weekly,
        'intervalWeeks': intervalWeeks,
        'weekdays': weekdays.toList()..sort(),
      },
    RecurrenceMonthlyByCalendarDay(:final calendarDay) => <String, dynamic>{
        RecurrenceJsonKeys.type: RecurrenceJsonKeys.monthlyByDay,
        'calendarDay': calendarDay,
      },
    RecurrenceMonthlyByWeekOrdinal(:final weekday, :final ordinal) =>
      <String, dynamic>{
        RecurrenceJsonKeys.type: RecurrenceJsonKeys.monthlyByWeekOrdinal,
        'weekday': weekday,
        'ordinal': ordinal.name,
      },
    RecurrenceYearly(:final month, :final day) => <String, dynamic>{
        RecurrenceJsonKeys.type: RecurrenceJsonKeys.yearly,
        'month': month,
        'day': day,
      },
  };
}

Map<String, dynamic> _encodeEnd(RecurrenceEndCondition end) {
  return switch (end) {
    RecurrenceEndNever() => <String, dynamic>{
        RecurrenceJsonKeys.type: RecurrenceJsonKeys.never,
      },
    RecurrenceEndUntilDate(:final untilDate) => <String, dynamic>{
        RecurrenceJsonKeys.type: RecurrenceJsonKeys.until,
        'date': ExpenseDates.toStorageDate(untilDate),
      },
    RecurrenceEndAfterCount(:final occurrenceCount) => <String, dynamic>{
        RecurrenceJsonKeys.type: RecurrenceJsonKeys.afterCount,
        'count': occurrenceCount,
      },
  };
}

(RecurrenceRule, RecurrenceEndCondition) decodeRecurrencePayloadMap(
  Map<String, dynamic> root,
) {
  final v = root[RecurrenceJsonKeys.version];
  if (v is! int || v != 1) {
    throw FormatException('unsupported recurrence payload v: $v');
  }
  final r = root[RecurrenceJsonKeys.rule];
  final e = root[RecurrenceJsonKeys.end];
  if (r is! Map<String, dynamic> || e is! Map<String, dynamic>) {
    throw const FormatException('recurrence rule/end shape');
  }
  final rule = decodeRecurrenceRule(r);
  final end = decodeRecurrenceEnd(e);
  rule.validate();
  end.validate();
  return (rule, end);
}
