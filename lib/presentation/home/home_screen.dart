import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/expenses/expense_summary_list_tile.dart';
import 'package:expense_app/presentation/home/expense_form_dialog.dart';
import 'package:expense_app/presentation/home/recurring_expense_menu_handler.dart';
import 'package:expense_app/presentation/formatting/currency_display.dart';
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
                icon: const Icon(Icons.chevron_right),
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
                  _MonthSpendSummary(
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
                        showRecurringOverflowMenu:
                            e.recurringSeriesId != null &&
                                !isRealizedOnLocalCalendar(
                                  e.occurredOn,
                                  today,
                                ) &&
                                e.effectivePaymentExpectationStatus ==
                                    PaymentExpectationStatus.expected,
                        onRecurringMenuAction: (action) {
                          handleRecurringExpenseTileAction(
                            context,
                            ref,
                            e,
                            action,
                          );
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

class _MonthSpendSummary extends StatelessWidget {
  const _MonthSpendSummary({
    required this.expenses,
    required this.locale,
    required this.l10n,
  });

  final List<Expense> expenses;
  final Locale locale;
  final AppLocalizations l10n;

  /// Horizontal [ListView] needs a bounded cross-axis height; inside a parent
  /// [ListView] the [Row] otherwise gets unbounded vertical constraints → 0-size
  /// viewport and "Cannot hit test a render box with no size" on web.
  static double _chipStripHeight(BuildContext context) {
    const base = kMinInteractiveDimension + 8;
    return MediaQuery.textScalerOf(context).scale(base).clamp(48.0, 80.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final byCurrency = <String, double>{};
    for (final e in expenses) {
      final c = e.currencyCode.toUpperCase();
      byCurrency[c] = (byCurrency[c] ?? 0) + e.amountOriginal;
    }
    final leftCodes = byCurrency.keys.where((c) => c != 'USD').toList()..sort();

    final usdTotal = expenses.fold<double>(0, (s, e) => s + e.amountUsd);
    final usdLine = formatDisplayCurrencyLine(
      'USD',
      usdTotal,
      locale.toString(),
    );
    final usdAccessibilityAmount = NumberFormat.decimalPatternDigits(
      locale: locale.toString(),
      decimalDigits: 2,
    ).format(usdTotal);

    return Card(
      elevation: 0,
      clipBehavior: Clip.none,
      color: scheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.monthSummaryTitle,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 10),
            if (expenses.isEmpty)
              Text(
                l10n.monthSummaryNoExpenses,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: leftCodes.isEmpty
                        ? const SizedBox(height: 40)
                        : SizedBox(
                            height:
                                _chipStripHeight(context) + (kIsWeb ? 10 : 0),
                            child: _MonthTotalsCurrencyStrip(
                              currencyCodes: leftCodes,
                              amountByCurrency: byCurrency,
                              localeName: locale.toString(),
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Semantics(
                    label: l10n.monthSummaryUsdTotal(usdAccessibilityAmount),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            scheme.primaryContainer,
                            Color.alphaBlend(
                              scheme.primary.withValues(alpha: 0.12),
                              scheme.primaryContainer,
                            ),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: scheme.primary.withValues(alpha: 0.18),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        child: Text(
                          usdLine,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: scheme.onPrimaryContainer,
                            letterSpacing: 0.15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _MonthTotalsCurrencyStrip extends StatefulWidget {
  const _MonthTotalsCurrencyStrip({
    required this.currencyCodes,
    required this.amountByCurrency,
    required this.localeName,
  });

  final List<String> currencyCodes;
  final Map<String, double> amountByCurrency;
  final String localeName;

  @override
  State<_MonthTotalsCurrencyStrip> createState() =>
      _MonthTotalsCurrencyStripState();
}

class _MonthTotalsCurrencyStripState extends State<_MonthTotalsCurrencyStrip> {
  late final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final codes = widget.currencyCodes;
    return Scrollbar(
      controller: _controller,
      thumbVisibility: kIsWeb,
      thickness: kIsWeb ? 5 : null,
      radius: const Radius.circular(4),
      child: ListView.separated(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        primary: false,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.only(right: 8, bottom: kIsWeb ? 6 : 0),
        itemCount: codes.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          return Align(
            alignment: Alignment.centerLeft,
            child: _MonthSummaryCurrencyChip(
              label: formatDisplayCurrencyLine(
                codes[i],
                widget.amountByCurrency[codes[i]]!,
                widget.localeName,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MonthSummaryCurrencyChip extends StatelessWidget {
  const _MonthSummaryCurrencyChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      color: scheme.surface,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.9)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
            color: scheme.onSurface,
          ),
        ),
      ),
    );
  }
}
