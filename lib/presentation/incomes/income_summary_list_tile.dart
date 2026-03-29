import 'package:flutter/material.dart';

import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/formatting/currency_display.dart';
import 'package:expense_app/presentation/formatting/payment_expectation_display.dart';
import 'package:expense_app/presentation/incomes/recurring_income_ui.dart';
import 'package:expense_app/presentation/widgets/cashflow_summary_list_row.dart';
import 'package:expense_app/presentation/widgets/list_row_settlement_segmented.dart';

class IncomeSummaryListTile extends StatelessWidget {
  const IncomeSummaryListTile({
    required this.entry,
    required this.categoryName,
    required this.subcategoryName,
    super.key,
    this.categoryId,
    this.onMenuAction,
    this.emphasizeAsScheduled = false,
    this.onSettlementToggle,
  });

  final IncomeEntry entry;
  final String categoryName;
  final String subcategoryName;
  final String? categoryId;
  final void Function(IncomeSummaryTileMenuAction action)? onMenuAction;
  final bool emphasizeAsScheduled;
  final Future<void> Function(bool settled)? onSettlementToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final localeName = Localizations.localeOf(context).toString();
    final dateStr = ExpenseDates.toStorageDate(entry.receivedOn);
    final originalLabel = formatDisplayCurrencyLine(
      entry.currencyCode,
      entry.amountOriginal,
      localeName,
    );
    final usdLabel = formatDisplayCurrencyLine(
      'USD',
      entry.amountUsd,
      localeName,
    );
    final note = entry.description.trim();
    final today = calendarTodayLocal();
    final expectationChip = incomeExpectationChipLabel(entry, l10n, today);

    final hasRecurring = entry.recurringSeriesId != null &&
        entry.recurringSeriesId!.isNotEmpty;
    final isSkipped =
        entry.effectiveExpectationStatus == PaymentExpectationStatus.skipped;

    final menu = onMenuAction != null
        ? PopupMenuButton<IncomeSummaryTileMenuAction>(
            tooltip: l10n.incomeListTileMenuTooltip,
            padding: EdgeInsets.zero,
            onSelected: onMenuAction,
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: IncomeSummaryTileMenuAction.edit,
                child: Text(l10n.recurringSeriesEdit),
              ),
              if (hasRecurring) ...[
                if (isSkipped)
                  PopupMenuItem(
                    value: IncomeSummaryTileMenuAction.restoreSkipped,
                    child: Text(l10n.recurringActionRestoreOccurrence),
                  )
                else
                  PopupMenuItem(
                    value: IncomeSummaryTileMenuAction.skip,
                    child: Text(l10n.recurringActionSkip),
                  ),
                PopupMenuItem(
                  value: IncomeSummaryTileMenuAction.delete,
                  child: Text(l10n.recurringTileActionDelete),
                ),
              ],
            ],
            child: kListRowOverflowMenuIconChild,
          )
        : null;

    final showSettlementControl = onSettlementToggle != null &&
        showInlineSettlementToggleForIncome(entry);
    final settlementSelected =
        entry.effectiveExpectationStatus ==
            PaymentExpectationStatus.confirmedPaid;

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
                Text(
                  '$categoryName — $subcategoryName · $dateStr',
                  style: theme.textTheme.bodyMedium,
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
            settlement: showSettlementControl
                ? ListRowSettlementSegmented(
                    settled: settlementSelected,
                    settledLabel: l10n.incomeFormSettlementReceived,
                    unsettledLabel: l10n.paymentExpectationExpectedShort,
                    onChanged: (v) => onSettlementToggle!(v),
                  )
                : null,
            originalLabel: originalLabel,
            usdLabel: usdLabel,
            menu: menu,
          ),
        ],
      ),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Opacity(
        opacity: emphasizeAsScheduled ? 0.82 : 1,
        child: inner,
      ),
    );
  }
}
