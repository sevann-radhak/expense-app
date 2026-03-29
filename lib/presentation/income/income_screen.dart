import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/formatting/currency_display.dart';
import 'package:expense_app/presentation/income/income_form_dialog.dart';
import 'package:expense_app/presentation/providers/providers.dart';
import 'package:expense_app/presentation/theme/category_accent_colors.dart';

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
                    (e) => _IncomeListTile(
                      entry: e,
                      categoryName:
                          categoryName[e.incomeCategoryId] ?? l10n.taxonomyUnknownLabel,
                      subcategoryName: subcategoryName[e.incomeSubcategoryId] ??
                          l10n.taxonomyUnknownLabel,
                      locale: locale,
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

class _IncomeListTile extends StatelessWidget {
  const _IncomeListTile({
    required this.entry,
    required this.categoryName,
    required this.subcategoryName,
    required this.locale,
    required this.onTap,
  });

  final IncomeEntry entry;
  final String categoryName;
  final String subcategoryName;
  final String locale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final original = formatDisplayCurrencyLine(
      entry.currencyCode,
      entry.amountOriginal,
      locale,
    );
    final usd = formatDisplayCurrencyLine('USD', entry.amountUsd, locale);
    final dateStr = ExpenseDates.toStorageDate(entry.receivedOn);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 4,
                constraints: const BoxConstraints(minHeight: 40),
                decoration: BoxDecoration(
                  color: categoryAccentColor(entry.incomeCategoryId),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$categoryName · $subcategoryName',
                      style: theme.textTheme.titleSmall,
                    ),
                    Text(dateStr, style: theme.textTheme.bodySmall),
                    if (entry.description.trim().isNotEmpty)
                      Text(
                        entry.description.trim(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(original, style: theme.textTheme.bodyMedium),
                    Text(usd, style: theme.textTheme.labelMedium),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
