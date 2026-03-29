import 'package:flutter/material.dart';

import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/formatting/payment_expectation_display.dart';
import 'package:expense_app/presentation/expenses/recurring_expense_ui.dart';
import 'package:expense_app/presentation/widgets/cashflow_summary_list_row.dart';
import 'package:expense_app/presentation/widgets/list_row_settlement_segmented.dart';

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
  final String? categoryId;
  final VoidCallback? onTap;
  final bool showRecurringOverflowMenu;
  final void Function(RecurringExpenseTileAction action)? onRecurringMenuAction;
  final String? paymentInstrumentLabel;
  final bool emphasizeAsScheduled;
  final Future<void> Function(bool settled)? onSettlementToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final localeName = Localizations.localeOf(context).toString();
    final dateStr = ExpenseDates.toStorageDate(expense.occurredOn);
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
            child: kListRowOverflowMenuIconChild,
          )
        : null;

    final showSettlementControl = onSettlementToggle != null &&
        showInlineSettlementToggleForExpense(expense);
    final settlementSelected =
        expense.effectivePaymentExpectationStatus ==
            PaymentExpectationStatus.confirmedPaid;

    final cardSuffix = paymentInstrumentLabel != null &&
            paymentInstrumentLabel!.isNotEmpty
        ? ' · ${l10n.expenseListCardLabel(paymentInstrumentLabel!)}'
        : (expense.paidWithCreditCard ? ' · ${l10n.expenseListCardBadge}' : '');

    final inner = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (categoryId != null)
            ListRowCategoryLeadingAccent(categoryId: categoryId!),
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
          CashflowSummaryTrailing(
            originalCurrencyCode: expense.currencyCode,
            originalAmount: expense.amountOriginal,
            usdAmount: expense.amountUsd,
            localeName: localeName,
            settlement: showSettlementControl
                ? ListRowSettlementSegmented(
                    settled: settlementSelected,
                    settledLabel: l10n.paymentExpectationConfirmedShort,
                    unsettledLabel: l10n.paymentExpectationExpectedShort,
                    onChanged: (v) => onSettlementToggle!(v),
                  )
                : null,
            menu: menu,
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
