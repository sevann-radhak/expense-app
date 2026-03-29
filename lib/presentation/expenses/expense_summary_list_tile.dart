import 'package:flutter/material.dart';

import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/formatting/currency_display.dart';
import 'package:expense_app/presentation/formatting/payment_expectation_display.dart';
import 'package:expense_app/presentation/expenses/recurring_expense_ui.dart';
import 'package:expense_app/presentation/theme/category_accent_colors.dart';
import 'package:expense_app/presentation/widgets/list_row_settlement_segmented.dart';

/// Compact expense row (category, subcategory, date, amounts) for lists.
class ExpenseSummaryListTile extends StatelessWidget {
  const ExpenseSummaryListTile({
    required this.expense,
    required this.categoryName,
    required this.subcategoryName,
    super.key,
    this.categoryId,
    this.onTap,
    this.showRecurringOverflowMenu = false,
    this.onRecurringMenuAction,
    this.paymentInstrumentLabel,
    this.emphasizeAsScheduled = false,
    this.onSettlementToggle,
  });

  final Expense expense;
  final String categoryName;
  final String subcategoryName;

  /// When set, shows a left accent bar using the shared category palette.
  final String? categoryId;
  final VoidCallback? onTap;

  /// When true and [onRecurringMenuAction] is set, shows a menu for scheduled recurring rows.
  final bool showRecurringOverflowMenu;
  final void Function(RecurringExpenseTileAction action)? onRecurringMenuAction;

  /// Resolved card profile label when [Expense.paidWithCreditCard].
  final String? paymentInstrumentLabel;

  /// Slightly dims the row (e.g. future scheduled expenses).
  final bool emphasizeAsScheduled;

  /// Paid vs expected; shown on the row when non-null and line is not skipped/waived.
  final Future<void> Function(bool settled)? onSettlementToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final localeName = Localizations.localeOf(context).toString();
    final dateStr = ExpenseDates.toStorageDate(expense.occurredOn);
    final originalLabel = formatDisplayCurrencyLine(
      expense.currencyCode,
      expense.amountOriginal,
      localeName,
    );
    final usdLabel = formatDisplayCurrencyLine(
      'USD',
      expense.amountUsd,
      localeName,
    );
    final note = expense.description.trim();
    final today = calendarTodayLocal();
    final expectationChip =
        expenseExpectationChipLabel(expense, l10n, today);

    final isSkipped = expense.effectivePaymentExpectationStatus ==
        PaymentExpectationStatus.skipped;

    final menu = showRecurringOverflowMenu && onRecurringMenuAction != null
        ? PopupMenuButton<RecurringExpenseTileAction>(
            tooltip: l10n.recurringMenuTooltip,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 36, height: 36),
            onSelected: onRecurringMenuAction,
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: RecurringExpenseTileAction.update,
                child: Text(l10n.recurringTileActionUpdate),
              ),
              if (isSkipped)
                PopupMenuItem(
                  value: RecurringExpenseTileAction.restoreSkipped,
                  child: Text(l10n.recurringActionRestoreOccurrence),
                )
              else
                PopupMenuItem(
                  value: RecurringExpenseTileAction.skip,
                  child: Text(l10n.recurringActionSkip),
                ),
              PopupMenuItem(
                value: RecurringExpenseTileAction.delete,
                child: Text(l10n.recurringTileActionDelete),
              ),
            ],
          )
        : null;

    final showSettlementControl = onSettlementToggle != null &&
        showInlineSettlementToggleForExpense(expense);
    final settlementSelected =
        expense.effectivePaymentExpectationStatus ==
            PaymentExpectationStatus.confirmedPaid;

    final cardSuffix = paymentInstrumentLabel != null && paymentInstrumentLabel!.isNotEmpty
        ? ' · ${l10n.expenseListCardLabel(paymentInstrumentLabel!)}'
        : (expense.paidWithCreditCard ? ' · ${l10n.expenseListCardBadge}' : '');

    final inner = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (categoryId != null) ...[
            Container(
              width: 4,
              constraints: const BoxConstraints(minHeight: 40),
              decoration: BoxDecoration(
                color: categoryAccentColor(categoryId!),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text.rich(
                  TextSpan(
                    style: theme.textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: '$categoryName — $subcategoryName · $dateStr',
                      ),
                      if (cardSuffix.isNotEmpty)
                        TextSpan(
                          text: cardSuffix,
                          style: theme.textTheme.bodySmall,
                        ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (expectationChip != null && !showSettlementControl)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Semantics(
                      label: expectationChip,
                      child: Chip(
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        label: Text(
                          expectationChip,
                          style: theme.textTheme.labelSmall,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ),
                if (note.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      note,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showSettlementControl)
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 12),
                  child: ListRowSettlementSegmented(
                    settled: settlementSelected,
                    settledLabel: l10n.paymentExpectationConfirmedShort,
                    unsettledLabel: l10n.paymentExpectationExpectedShort,
                    onChanged: (v) => onSettlementToggle!(v),
                  ),
                ),
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
                  Text(usdLabel, style: theme.textTheme.titleSmall),
                  if (menu != null) ...[
                    const SizedBox(width: 2),
                    menu,
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );

    final child = Opacity(
      opacity: emphasizeAsScheduled ? 0.82 : 1,
      child: inner,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: onTap == null
          ? child
          : InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: child,
            ),
    );
  }
}
