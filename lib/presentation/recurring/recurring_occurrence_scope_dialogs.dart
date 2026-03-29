import 'package:flutter/material.dart';

import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';

Future<RecurringOccurrenceDeleteScope?> showRecurringOccurrenceDeleteScopeDialog(
  BuildContext context,
) async {
  final l10n = AppLocalizations.of(context)!;
  return showDialog<RecurringOccurrenceDeleteScope>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.recurringDeleteScopeTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.recurringDeleteScopeBody),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(
              ctx,
              RecurringOccurrenceDeleteScope.thisOccurrenceOnly,
            ),
            child: Text(l10n.recurringDeleteThisOccurrenceOnly),
          ),
          const SizedBox(height: 8),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.errorContainer,
              foregroundColor: Theme.of(ctx).colorScheme.onErrorContainer,
            ),
            onPressed: () => Navigator.pop(
              ctx,
              RecurringOccurrenceDeleteScope.thisAndFutureInSeries,
            ),
            child: Text(l10n.recurringDeleteThisAndFuture),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l10n.cancel),
        ),
      ],
    ),
  );
}
