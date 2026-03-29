import 'package:expense_app/domain/expense.dart';
import 'package:expense_app/domain/income_entry.dart';
import 'package:expense_app/domain/payment_settlement.dart';

/// January at index `0`, December at index `11`.
List<double> monthlyUsdTotalsByCalendarMonth(Iterable<Expense> expenses) {
  final list = List<double>.filled(12, 0);
  for (final e in expenses) {
    final m = e.occurredOn.month;
    if (m >= 1 && m <= 12) {
      list[m - 1] += e.amountUsd;
    }
  }
  return list;
}

/// Same bucketing as [monthlyUsdTotalsByCalendarMonth] for [IncomeEntry.receivedOn].
List<double> monthlyUsdTotalsByCalendarMonthForIncome(Iterable<IncomeEntry> incomes) {
  final list = List<double>.filled(12, 0);
  for (final e in incomes) {
    final m = e.receivedOn.month;
    if (m >= 1 && m <= 12) {
      list[m - 1] += e.amountUsd;
    }
  }
  return list;
}

/// January at index `0`. Only rows with [Expense.occurredOn] in [year].
void monthlyExpenseSettledPendingForYear(
  Iterable<Expense> expenses,
  int year,
  DateTime todayDateOnly,
  List<double> settledOut,
  List<double> pendingOut,
) {
  assert(settledOut.length == 12 && pendingOut.length == 12);
  for (var i = 0; i < 12; i++) {
    settledOut[i] = 0;
    pendingOut[i] = 0;
  }
  for (final e in expenses) {
    if (e.occurredOn.year != year) {
      continue;
    }
    final m = e.occurredOn.month;
    if (m < 1 || m > 12) {
      continue;
    }
    final idx = m - 1;
    if (isEconomicallySettledExpense(e, todayDateOnly)) {
      settledOut[idx] += e.amountUsd;
    } else {
      pendingOut[idx] += e.amountUsd;
    }
  }
}

/// Same as [monthlyExpenseSettledPendingForYear] for [IncomeEntry.receivedOn].
void monthlyIncomeSettledPendingForYear(
  Iterable<IncomeEntry> incomes,
  int year,
  DateTime todayDateOnly,
  List<double> settledOut,
  List<double> pendingOut,
) {
  assert(settledOut.length == 12 && pendingOut.length == 12);
  for (var i = 0; i < 12; i++) {
    settledOut[i] = 0;
    pendingOut[i] = 0;
  }
  for (final e in incomes) {
    if (e.receivedOn.year != year) {
      continue;
    }
    final m = e.receivedOn.month;
    if (m < 1 || m > 12) {
      continue;
    }
    final idx = m - 1;
    if (isEconomicallySettledIncome(e, todayDateOnly)) {
      settledOut[idx] += e.amountUsd;
    } else {
      pendingOut[idx] += e.amountUsd;
    }
  }
}

({double settled, double pending}) splitExpenseUsdSettledPending(
  Iterable<Expense> expenses,
  DateTime todayDateOnly,
) {
  var settled = 0.0;
  var pending = 0.0;
  for (final e in expenses) {
    if (isEconomicallySettledExpense(e, todayDateOnly)) {
      settled += e.amountUsd;
    } else {
      pending += e.amountUsd;
    }
  }
  return (settled: settled, pending: pending);
}

({double settled, double pending}) splitIncomeUsdSettledPending(
  Iterable<IncomeEntry> incomes,
  DateTime todayDateOnly,
) {
  var settled = 0.0;
  var pending = 0.0;
  for (final e in incomes) {
    if (isEconomicallySettledIncome(e, todayDateOnly)) {
      settled += e.amountUsd;
    } else {
      pending += e.amountUsd;
    }
  }
  return (settled: settled, pending: pending);
}

/// Sum of [Expense.amountUsd] (already FX-converted at save time).
double totalUsd(Iterable<Expense> expenses) {
  var s = 0.0;
  for (final e in expenses) {
    s += e.amountUsd;
  }
  return s;
}

double totalIncomeUsd(Iterable<IncomeEntry> incomes) {
  var s = 0.0;
  for (final e in incomes) {
    s += e.amountUsd;
  }
  return s;
}

/// Share of [part] in [whole] as a percentage in `[0, 100]`.
double percentOfTotal(double part, double whole) {
  if (whole <= 0) {
    return 0;
  }
  return (part / whole) * 100;
}

/// One row per category, sorted by [totalUsd] descending.
List<CategoryUsdAggregate> aggregateUsdByCategory(Iterable<Expense> expenses) {
  final map = <String, double>{};
  for (final e in expenses) {
    map[e.categoryId] = (map[e.categoryId] ?? 0) + e.amountUsd;
  }
  final list =
      map.entries
          .map(
            (e) => CategoryUsdAggregate(categoryId: e.key, totalUsd: e.value),
          )
          .toList()
        ..sort((a, b) => b.totalUsd.compareTo(a.totalUsd));
  return list;
}

/// Income categories (uses [IncomeEntry.incomeCategoryId]), sorted by total descending.
List<CategoryUsdAggregate> aggregateUsdByIncomeCategory(
  Iterable<IncomeEntry> incomes,
) {
  final map = <String, double>{};
  for (final e in incomes) {
    map[e.incomeCategoryId] = (map[e.incomeCategoryId] ?? 0) + e.amountUsd;
  }
  final list =
      map.entries
          .map(
            (e) => CategoryUsdAggregate(categoryId: e.key, totalUsd: e.value),
          )
          .toList()
        ..sort((a, b) => b.totalUsd.compareTo(a.totalUsd));
  return list;
}

/// Income subcategories under [categoryId], sorted by [totalUsd] descending.
List<SubcategoryUsdAggregate> aggregateUsdByIncomeSubcategoryForCategory(
  Iterable<IncomeEntry> incomes,
  String categoryId,
) {
  final map = <String, double>{};
  for (final e in incomes) {
    if (e.incomeCategoryId == categoryId) {
      map[e.incomeSubcategoryId] =
          (map[e.incomeSubcategoryId] ?? 0) + e.amountUsd;
    }
  }
  final list =
      map.entries
          .map(
            (e) => SubcategoryUsdAggregate(
              subcategoryId: e.key,
              totalUsd: e.value,
            ),
          )
          .toList()
        ..sort((a, b) => b.totalUsd.compareTo(a.totalUsd));
  return list;
}

/// Subcategories under [categoryId], sorted by [totalUsd] descending.
List<SubcategoryUsdAggregate> aggregateUsdBySubcategoryForCategory(
  Iterable<Expense> expenses,
  String categoryId,
) {
  final map = <String, double>{};
  for (final e in expenses) {
    if (e.categoryId == categoryId) {
      map[e.subcategoryId] = (map[e.subcategoryId] ?? 0) + e.amountUsd;
    }
  }
  final list =
      map.entries
          .map(
            (e) => SubcategoryUsdAggregate(
              subcategoryId: e.key,
              totalUsd: e.value,
            ),
          )
          .toList()
        ..sort((a, b) => b.totalUsd.compareTo(a.totalUsd));
  return list;
}

final class CategoryUsdAggregate {
  const CategoryUsdAggregate({
    required this.categoryId,
    required this.totalUsd,
  });

  final String categoryId;
  final double totalUsd;
}

final class SubcategoryUsdAggregate {
  const SubcategoryUsdAggregate({
    required this.subcategoryId,
    required this.totalUsd,
  });

  final String subcategoryId;
  final double totalUsd;
}
