import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/presentation/incomes/recurring_income_ui.dart';
import 'package:expense_app/presentation/providers/providers.dart';

Future<void> handleRecurringIncomeTileAction(
  BuildContext context,
  WidgetRef ref,
  IncomeEntry entry,
  RecurringIncomeTileAction action,
) async {
  final repo = ref.read(incomeRepositoryProvider);
  final today = calendarTodayLocal();
  switch (action) {
    case RecurringIncomeTileAction.confirmReceived:
      await repo.update(
        entry.copyWith(
          expectationStatus: PaymentExpectationStatus.confirmedPaid,
          expectationConfirmedOn: calendarDateOnly(entry.receivedOn),
        ),
      );
      break;
    case RecurringIncomeTileAction.receivedEarly:
      final last = _lastDateForReceivedEarlyPicker(entry, today);
      final picked = await showDatePicker(
        context: context,
        initialDate: last,
        firstDate: DateTime(2000),
        lastDate: last,
      );
      if (picked != null && context.mounted) {
        await repo.update(
          entry.copyWith(
            expectationStatus: PaymentExpectationStatus.confirmedPaid,
            expectationConfirmedOn: calendarDateOnly(picked),
          ),
        );
      }
      break;
    case RecurringIncomeTileAction.skip:
      await repo.update(
        entry.copyWith(
          expectationStatus: PaymentExpectationStatus.skipped,
          clearExpectationConfirmedOn: true,
        ),
      );
      break;
    case RecurringIncomeTileAction.waive:
      await repo.update(
        entry.copyWith(
          expectationStatus: PaymentExpectationStatus.waived,
          clearExpectationConfirmedOn: true,
        ),
      );
      break;
  }
}

DateTime _lastDateForReceivedEarlyPicker(IncomeEntry e, DateTime todayDateOnly) {
  final r = calendarDateOnly(e.receivedOn);
  final t = calendarDateOnly(todayDateOnly);
  return r.isBefore(t) ? r : t;
}
