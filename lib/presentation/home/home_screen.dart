import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/home/expense_form_dialog.dart';
import 'package:expense_app/presentation/providers/providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final month = ref.watch(selectedMonthProvider);
    final monthLabel = DateFormat.yMMMM(locale).format(month);
    final expensesAsync = ref.watch(expensesForSelectedMonthProvider);
    final categories = ref.watch(categoriesStreamProvider).valueOrNull ?? [];
    final allSubs = ref.watch(allSubcategoriesStreamProvider).valueOrNull ?? [];
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    final categoryName = {for (final c in categories) c.id: c.name};
    final subcategoryName = {for (final s in allSubs) s.id: s.name};

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
                  ref.read(selectedMonthProvider.notifier).state =
                      DateTime(month.year, month.month - 1);
                },
                icon: const Icon(Icons.chevron_left),
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
                  ref.read(selectedMonthProvider.notifier).state =
                      DateTime(month.year, month.month + 1);
                },
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.expensesThisMonthHeading,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          expensesAsync.when(
            data: (expenses) {
              if (expenses.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    l10n.homeEmptyState,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              }
              return Column(
                children: expenses
                    .map(
                      (e) => _ExpenseTile(
                        expense: e,
                        categoryName: categoryName[e.categoryId] ?? e.categoryId,
                        subcategoryName:
                            subcategoryName[e.subcategoryId] ?? e.subcategoryId,
                        onTap: () {
                          showDialog<void>(
                            context: context,
                            builder: (ctx) => ExpenseFormDialog(initial: e),
                          );
                        },
                      ),
                    )
                    .toList(),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('$e'),
          ),
          const SizedBox(height: 24),
          categoriesAsync.when(
            data: (cats) => ExpansionTile(
              initiallyExpanded: false,
              title: Text(l10n.categoriesDebugHeading),
              children: [
                ...cats.map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: _CategoryExpansionTile(category: c),
                  ),
                ),
              ],
            ),
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('$e'),
          ),
        ],
      ),
    );
  }
}

class _ExpenseTile extends StatelessWidget {
  const _ExpenseTile({
    required this.expense,
    required this.categoryName,
    required this.subcategoryName,
    required this.onTap,
  });

  final Expense expense;
  final String categoryName;
  final String subcategoryName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final dateStr = ExpenseDates.toStorageDate(expense.occurredOn);
    final usdStr = expense.amountUsd.toStringAsFixed(2);
    final origStr = expense.amountOriginal.toStringAsFixed(2);
    final originalLabel = l10n.expenseListOriginal(origStr, expense.currencyCode);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: theme.textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: '$categoryName — $subcategoryName · $dateStr',
                      ),
                      if (expense.paidWithCreditCard)
                        TextSpan(
                          text: ' · ${l10n.expenseListCardBadge}',
                          style: theme.textTheme.bodySmall,
                        ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    originalLabel,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    l10n.expenseListUsd(usdStr),
                    style: theme.textTheme.titleSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryExpansionTile extends ConsumerWidget {
  const _CategoryExpansionTile({required this.category});

  final Category category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final subsAsync = ref.watch(
      subcategoriesForCategoryProvider(category.id),
    );

    return Card(
      margin: EdgeInsets.zero,
      child: ExpansionTile(
        title: Text(category.name),
        subtitle: Text(
          category.id,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        children: subsAsync.when(
          data: (subs) => subs
              .map(
                (s) => ListTile(
                  dense: true,
                  title: Text(s.name),
                  subtitle: Text('${s.slug} · ${s.id}'),
                  trailing: s.isSystemReserved
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            try {
                              await ref
                                  .read(categoryRepositoryProvider)
                                  .deleteSubcategory(s.id);
                            } on ReservedSubcategoryException {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      l10n.cannotDeleteReservedSubcategory,
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                ),
              )
              .toList(),
          loading: () => [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
          error: (e, _) => [
            ListTile(title: Text('$e')),
          ],
        ),
      ),
    );
  }
}
