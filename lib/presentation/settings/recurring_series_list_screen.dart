import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/providers/providers.dart';
import 'package:expense_app/presentation/settings/recurrence_rule_summary.dart';
import 'package:expense_app/presentation/settings/recurring_series_edit_dialog.dart';

class RecurringSeriesListScreen extends ConsumerWidget {
  const RecurringSeriesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final async = ref.watch(recurringExpenseSeriesListProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.recurringSeriesScreenTitle)),
      body: async.when(
        data: (list) {
          if (list.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  l10n.recurringSeriesEmpty,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (ctx, i) {
              final s = list[i];
              final title = s.description.trim().isEmpty
                  ? l10n.recurringSeriesDefaultTitle
                  : s.description.trim();
              final subtitle =
                  '${recurrenceRuleSummary(context, s.rule)}\n${l10n.recurringSeriesHorizonMonths(s.horizonMonths)} · ${s.active ? l10n.recurringSeriesActive : l10n.recurringSeriesInactive}';
              return Card(
                child: ListTile(
                  title: Text(title),
                  subtitle: Text(subtitle),
                  isThreeLine: true,
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      builder: (c) => RecurringSeriesEditDialog(series: s),
                    );
                  },
                  trailing: s.active
                      ? PopupMenuButton<_SeriesMenuAction>(
                          onSelected: (action) async {
                            if (action == _SeriesMenuAction.stop) {
                              final ok = await showDialog<bool>(
                                context: context,
                                builder: (dCtx) => AlertDialog(
                                  title: Text(l10n.recurringSeriesStopTitle),
                                  content: Text(l10n.recurringSeriesStopBody),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(dCtx, false),
                                      child: Text(l10n.cancel),
                                    ),
                                    FilledButton(
                                      onPressed: () =>
                                          Navigator.pop(dCtx, true),
                                      child: Text(l10n.recurringSeriesStop),
                                    ),
                                  ],
                                ),
                              );
                              if (ok == true && context.mounted) {
                                await ref
                                    .read(
                                      recurringExpenseSeriesRepositoryProvider,
                                    )
                                    .deactivateSeries(
                                      seriesId: s.id,
                                      todayDateOnly: calendarTodayLocal(),
                                    );
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        l10n.recurringSeriesStoppedSnackbar,
                                      ),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          itemBuilder: (c) => [
                            PopupMenuItem(
                              value: _SeriesMenuAction.stop,
                              child: Text(l10n.recurringSeriesStop),
                            ),
                          ],
                        )
                      : null,
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}

enum _SeriesMenuAction { stop }
