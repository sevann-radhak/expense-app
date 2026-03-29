import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/presentation/expenses/recurring_expense_ui.dart';
import 'package:expense_app/presentation/providers/providers.dart';

Future<void> handleRecurringExpenseTileAction(
  BuildContext context,
  WidgetRef ref,
  Expense expense,
  RecurringExpenseTileAction action,
) async {
  final repo = ref.read(expenseRepositoryProvider);
  final today = calendarTodayLocal();
  switch (action) {
    case RecurringExpenseTileAction.confirmPaid:
      await repo.update(
        expense.copyWith(
          paymentExpectationStatus: PaymentExpectationStatus.confirmedPaid,
          paymentExpectationConfirmedOn: calendarDateOnly(expense.occurredOn),
        ),
      );
      break;
    case RecurringExpenseTileAction.paidEarly:
      final last = _lastDateForPaidEarlyPicker(expense, today);
      final picked = await showDatePicker(
        context: context,
        initialDate: last,
        firstDate: DateTime(2000),
        lastDate: last,
      );
      if (picked != null && context.mounted) {
        await repo.update(
          expense.copyWith(
            paymentExpectationStatus: PaymentExpectationStatus.confirmedPaid,
            paymentExpectationConfirmedOn: calendarDateOnly(picked),
          ),
        );
      }
      break;
    case RecurringExpenseTileAction.skip:
      await repo.update(
        expense.copyWith(
          paymentExpectationStatus: PaymentExpectationStatus.skipped,
          clearPaymentExpectationConfirmedOn: true,
        ),
      );
      break;
    case RecurringExpenseTileAction.waive:
      await repo.update(
        expense.copyWith(
          paymentExpectationStatus: PaymentExpectationStatus.waived,
          clearPaymentExpectationConfirmedOn: true,
        ),
      );
      break;
  }
}

DateTime _lastDateForPaidEarlyPicker(Expense e, DateTime todayDateOnly) {
  final o = calendarDateOnly(e.occurredOn);
  final t = calendarDateOnly(todayDateOnly);
  return o.isBefore(t) ? o : t;
}
