import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/expenses/expense_summary_list_tile.dart';
import 'package:expense_app/presentation/home/expense_form_dialog.dart';
import 'package:expense_app/presentation/home/recurring_expense_menu_handler.dart';
import 'package:expense_app/presentation/providers/providers.dart';
import 'package:expense_app/presentation/theme/app_icons.dart';
import 'package:expense_app/presentation/widgets/month_cashflow_summary_card.dart';

class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final month = ref.watch(selectedMonthProvider);
    final monthLabel = DateFormat.yMMMM(locale).format(month);
    final expensesAsync = ref.watch(expensesForSelectedMonthProvider);
    final categories = ref.watch(categoriesStreamProvider).valueOrNull ?? [];
    final allSubs = ref.watch(allSubcategoriesStreamProvider).valueOrNull ?? [];
    final categoryName = {for (final c in categories) c.id: c.name};
    final subcategoryName = {for (final s in allSubs) s.id: s.name};
    final instruments =
        ref.watch(paymentInstrumentsStreamProvider).valueOrNull ?? [];
    final instrumentLabel = {for (final p in instruments) p.id: p.label};

    return Scaffold(
      appBar: AppBar(title: Text(l10n.homeTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: categories.isEmpty
            ? null
            : () {
                showDialog<void>(
                  context: context,
                  builder: (ctx) => const ExpenseFormDialog(),
                );
              },
        tooltip: l10n.addExpenseTooltip,
        child: Icon(AppIcons.add),
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
                icon: Icon(AppIcons.caretLeft),
              ),
              Expanded(
                child: Text(
                  monthLabel,
                  key: const ValueKey<String>('selected-month-label'),
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
                icon: Icon(AppIcons.caretRight),
              ),
            ],
          ),
          const SizedBox(height: 16),
          expensesAsync.when(
            data: (expenses) {
              final locale = Localizations.localeOf(context);
              final today = calendarTodayLocal();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _monthExpenseSummaryCard(
                    context: context,
                    expenses: expenses,
                    locale: locale,
                    l10n: l10n,
                  ),
                  if (expenses.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      l10n.expensesThisMonthHeading,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ...expenses.map(
                      (e) => ExpenseSummaryListTile(
                        expense: e,
                        categoryId: e.categoryId,
                        categoryName: categoryName[e.categoryId] ??
                            l10n.taxonomyUnknownLabel,
                        subcategoryName: subcategoryName[e.subcategoryId] ??
                            l10n.taxonomyUnknownLabel,
                        paymentInstrumentLabel: e.paymentInstrumentId != null
                            ? instrumentLabel[e.paymentInstrumentId!]
                            : null,
                        emphasizeAsScheduled:
                            !isEconomicallySettledExpense(e, today),
                        showRecurringOverflowMenu:
                            e.recurringSeriesId != null &&
                                e.recurringSeriesId!.isNotEmpty,
                        onRecurringMenuAction: (action) {
                          handleRecurringExpenseTileAction(
                            context,
                            ref,
                            e,
                            action,
                          );
                        },
                        onSettlementToggle: (settled) async {
                          try {
                            await ref.read(expenseRepositoryProvider).update(
                                  withExpenseSettlementChoice(
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
                            builder: (ctx) => ExpenseFormDialog(initial: e),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('$e'),
          ),
        ],
      ),
    );
  }
}

Widget _monthExpenseSummaryCard({
  required BuildContext context,
  required List<Expense> expenses,
  required Locale locale,
  required AppLocalizations l10n,
}) {
  final split = monthCashflowOriginalUsdSplitForExpenses(
    expenses,
    calendarTodayLocal(),
  );

  return MonthCashflowSummaryCard(
    title: l10n.monthSummaryTitle,
    locale: locale,
    l10n: l10n,
    split: split,
    emptyStateMessage:
        expenses.isEmpty ? l10n.monthSummaryNoExpenses : null,
  );
}
