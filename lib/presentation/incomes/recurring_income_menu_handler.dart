import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/presentation/income/income_form_dialog.dart';
import 'package:expense_app/presentation/incomes/recurring_income_ui.dart';
import 'package:expense_app/presentation/providers/providers.dart';
import 'package:expense_app/presentation/recurring/recurring_occurrence_scope_dialogs.dart';

Future<void> handleRecurringIncomeTileAction(
  BuildContext context,
  WidgetRef ref,
  IncomeEntry entry,
  RecurringIncomeTileAction action,
) async {
  final repo = ref.read(incomeRepositoryProvider);
  final seriesRepo = ref.read(recurringIncomeSeriesRepositoryProvider);
  final today = calendarTodayLocal();
  switch (action) {
    case RecurringIncomeTileAction.update:
      if (!context.mounted) {
        return;
      }
      await showDialog<void>(
        context: context,
        builder: (ctx) => IncomeFormDialog(initial: entry),
      );
      break;
    case RecurringIncomeTileAction.skip:
      await repo.update(
        entry.copyWith(
          expectationStatus: PaymentExpectationStatus.skipped,
          clearExpectationConfirmedOn: true,
        ),
      );
      break;
    case RecurringIncomeTileAction.delete:
      if (!context.mounted) {
        return;
      }
      final scope = await showRecurringOccurrenceDeleteScopeDialog(context);
      if (scope == null || !context.mounted) {
        return;
      }
      final sid = entry.recurringSeriesId;
      if (sid == null || sid.isEmpty) {
        return;
      }
      switch (scope) {
        case RecurringOccurrenceDeleteScope.thisOccurrenceOnly:
          await repo.delete(entry.id);
          break;
        case RecurringOccurrenceDeleteScope.thisAndFutureInSeries:
          await seriesRepo.trimSeriesFromOccurrenceDate(
            seriesId: sid,
            fromReceivedOnDateOnly: calendarDateOnly(entry.receivedOn),
            todayDateOnly: today,
          );
          break;
      }
      break;
  }
}
