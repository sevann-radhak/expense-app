import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/presentation/expenses/recurring_expense_ui.dart';
import 'package:expense_app/presentation/home/expense_form_dialog.dart';
import 'package:expense_app/presentation/providers/providers.dart';
import 'package:expense_app/presentation/recurring/recurring_occurrence_scope_dialogs.dart';

Future<void> handleRecurringExpenseTileAction(
  BuildContext context,
  WidgetRef ref,
  Expense expense,
  RecurringExpenseTileAction action,
) async {
  final repo = ref.read(expenseRepositoryProvider);
  final seriesRepo = ref.read(recurringExpenseSeriesRepositoryProvider);
  final today = calendarTodayLocal();
  switch (action) {
    case RecurringExpenseTileAction.update:
      if (!context.mounted) {
        return;
      }
      await showDialog<void>(
        context: context,
        builder: (ctx) => ExpenseFormDialog(initial: expense),
      );
      break;
    case RecurringExpenseTileAction.skip:
      await repo.update(
        expense.copyWith(
          paymentExpectationStatus: PaymentExpectationStatus.skipped,
          clearPaymentExpectationConfirmedOn: true,
        ),
      );
      break;
    case RecurringExpenseTileAction.delete:
      if (!context.mounted) {
        return;
      }
      final scope = await showRecurringOccurrenceDeleteScopeDialog(context);
      if (scope == null || !context.mounted) {
        return;
      }
      final sid = expense.recurringSeriesId;
      if (sid == null || sid.isEmpty) {
        return;
      }
      switch (scope) {
        case RecurringOccurrenceDeleteScope.thisOccurrenceOnly:
          await repo.delete(expense.id);
          break;
        case RecurringOccurrenceDeleteScope.thisAndFutureInSeries:
          await seriesRepo.trimSeriesFromOccurrenceDate(
            seriesId: sid,
            fromOccurredOnDateOnly: calendarDateOnly(expense.occurredOn),
            todayDateOnly: today,
          );
          break;
      }
      break;
  }
}
