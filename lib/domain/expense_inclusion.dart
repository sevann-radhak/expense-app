import 'package:expense_app/domain/expense.dart';

/// How expenses are included when comparing [Expense.occurredOn] to local calendar
/// "today" (date-only; time-of-day is ignored).
enum ExpenseInclusion {
  /// No date filter.
  all,

  /// [Expense.occurredOn] is on or before local today (inclusive).
  realizedOnly,

  /// [Expense.occurredOn] is strictly after local today.
  scheduledOnly,
}

/// Strips time-of-day; uses the device’s local calendar fields.
DateTime calendarDateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Local calendar “today” from [DateTime.now()] (no time-of-day).
DateTime calendarTodayLocal() {
  final n = DateTime.now();
  return DateTime(n.year, n.month, n.day);
}

/// True if [occurredOn] is realized relative to [todayDateOnly] (same calendar day
/// or earlier). [todayDateOnly] must be date-only (midnight is fine).
bool isRealizedOnLocalCalendar(
  DateTime occurredOn,
  DateTime todayDateOnly,
) {
  final o = calendarDateOnly(occurredOn);
  final t = calendarDateOnly(todayDateOnly);
  return !o.isAfter(t);
}

bool _matchesInclusion(
  DateTime occurredOn,
  ExpenseInclusion inclusion,
  DateTime todayDateOnly,
) {
  switch (inclusion) {
    case ExpenseInclusion.all:
      return true;
    case ExpenseInclusion.realizedOnly:
      return isRealizedOnLocalCalendar(occurredOn, todayDateOnly);
    case ExpenseInclusion.scheduledOnly:
      return !isRealizedOnLocalCalendar(occurredOn, todayDateOnly);
  }
}

/// Filters [expenses] in memory. Prefer this for small books; DB predicates are
/// optional if lists grow large.
List<Expense> applyExpenseInclusion(
  List<Expense> expenses,
  ExpenseInclusion inclusion,
  DateTime todayDateOnly,
) {
  if (inclusion == ExpenseInclusion.all) {
    return List<Expense>.from(expenses);
  }
  return expenses
      .where(
        (e) => _matchesInclusion(e.occurredOn, inclusion, todayDateOnly),
      )
      .toList();
}
