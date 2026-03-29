import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/formatting/currency_display.dart';
import 'package:expense_app/presentation/income/income_form_dialog.dart';
import 'package:expense_app/presentation/incomes/income_summary_list_tile.dart';
import 'package:expense_app/presentation/incomes/recurring_income_menu_handler.dart';
import 'package:expense_app/presentation/providers/providers.dart';

class IncomeScreen extends ConsumerWidget {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final month = ref.watch(selectedMonthProvider);
    final monthLabel = DateFormat.yMMMM(locale).format(month);
    final incomeAsync = ref.watch(incomeForSelectedMonthProvider);
    final categories = ref.watch(incomeCategoriesStreamProvider).valueOrNull ?? [];
    final allSubs =
        ref.watch(allIncomeSubcategoriesStreamProvider).valueOrNull ?? [];
    final categoryName = {for (final c in categories) c.id: c.name};
    final subcategoryName = {for (final s in allSubs) s.id: s.name};
    final today = calendarTodayLocal();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.incomeScreenTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: categories.isEmpty
            ? null
            : () {
                showDialog<void>(
                  context: context,
                  builder: (ctx) => const IncomeFormDialog(),
                );
              },
        tooltip: l10n.incomeAddTooltip,
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Row(
            children: [
              IconButton(
                tooltip: l10n.monthPickerPrevious,
                onPressed: () {
                  ref.read(selectedMonthProvider.notifier).state = DateTime(
                    month.year,
                    month.month - 1,
                  );
                },
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  monthLabel,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(
                tooltip: l10n.monthPickerNext,
                onPressed: () {
                  ref.read(selectedMonthProvider.notifier).state = DateTime(
                    month.year,
                    month.month + 1,
                  );
                },
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 16),
          incomeAsync.when(
            data: (entries) {
              if (entries.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.incomeEmptyTitle,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.incomeEmptyBody,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              final totalUsd = entries.fold<double>(0, (s, e) => s + e.amountUsd);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        l10n.incomeThisMonthHeading,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.reportsIncomeThisMonthLine(
                      formatUsdAmountOnly(totalUsd, locale),
                    ),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 16),
                  ...entries.map(
                    (e) => IncomeSummaryListTile(
                      entry: e,
                      categoryId: e.incomeCategoryId,
                      categoryName:
                          categoryName[e.incomeCategoryId] ?? l10n.taxonomyUnknownLabel,
                      subcategoryName: subcategoryName[e.incomeSubcategoryId] ??
                          l10n.taxonomyUnknownLabel,
                      emphasizeAsScheduled:
                          !isEconomicallySettledIncome(e, today),
                      showRecurringOverflowMenu:
                          e.recurringSeriesId != null &&
                              e.recurringSeriesId!.isNotEmpty &&
                              !isRealizedOnLocalCalendar(
                                e.receivedOn,
                                today,
                              ) &&
                              e.effectiveExpectationStatus ==
                                  PaymentExpectationStatus.expected,
                      onRecurringMenuAction: (action) {
                        handleRecurringIncomeTileAction(
                          context,
                          ref,
                          e,
                          action,
                        );
                      },
                      onSettlementToggle: (settled) async {
                        try {
                          await ref.read(incomeRepositoryProvider).update(
                                withIncomeSettlementChoice(
                                  e,
                                  settled,
                                  calendarTodayLocal(),
                                ),
                              );
                        } on Object catch (err) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('$err')),
                            );
                          }
                        }
                      },
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          builder: (ctx) => IncomeFormDialog(initial: e),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('$e'),
          ),
        ],
      ),
    );
  }
}
