import 'package:expense_app/domain/expense.dart';
import 'package:expense_app/domain/income_entry.dart';

/// Filters any list with a calendar [dateOnly] using the same rules as [ExpenseInclusion].
List<T> applyCalendarDateInclusion<T>(
  List<T> items,
  ExpenseInclusion inclusion,
  DateTime todayDateOnly,
  DateTime Function(T item) dateOnly,
) {
  if (inclusion == ExpenseInclusion.all) {
    return List<T>.from(items);
  }
  final t = calendarDateOnly(todayDateOnly);
  return items.where((item) {
    final d = calendarDateOnly(dateOnly(item));
    switch (inclusion) {
      case ExpenseInclusion.all:
        return true;
      case ExpenseInclusion.realizedOnly:
        return !d.isAfter(t);
      case ExpenseInclusion.scheduledOnly:
        return d.isAfter(t);
    }
  }).toList();
}

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

/// Filters [expenses] in memory. Prefer this for small books; DB predicates are
/// optional if lists grow large.
List<Expense> applyExpenseInclusion(
  List<Expense> expenses,
  ExpenseInclusion inclusion,
  DateTime todayDateOnly,
) {
  return applyCalendarDateInclusion<Expense>(
    expenses,
    inclusion,
    todayDateOnly,
    (e) => e.occurredOn,
  );
}

/// Same date filter as [applyExpenseInclusion], using [IncomeEntry.receivedOn].
List<IncomeEntry> applyIncomeInclusion(
  List<IncomeEntry> incomes,
  ExpenseInclusion inclusion,
  DateTime todayDateOnly,
) {
  return applyCalendarDateInclusion<IncomeEntry>(
    incomes,
    inclusion,
    todayDateOnly,
    (e) => e.receivedOn,
  );
}
