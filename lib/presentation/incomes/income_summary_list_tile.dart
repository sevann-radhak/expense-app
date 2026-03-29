import 'package:flutter/material.dart';

import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/formatting/currency_display.dart';
import 'package:expense_app/presentation/formatting/payment_expectation_display.dart';
import 'package:expense_app/presentation/incomes/recurring_income_ui.dart';
import 'package:expense_app/presentation/theme/category_accent_colors.dart';
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

  /// Edit (always); skip/delete when the row is part of a recurring series.
  final void Function(IncomeSummaryTileMenuAction action)? onMenuAction;

  final bool emphasizeAsScheduled;

  /// Paid/received vs expected; shown on the row when non-null and line is not skipped/waived.
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
            constraints: const BoxConstraints.tightFor(width: 36, height: 36),
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
                Text(
                  '$categoryName — $subcategoryName · $dateStr',
                  style: theme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (expectationChip != null && !showSettlementControl)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
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
                    settledLabel: l10n.incomeFormSettlementReceived,
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

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Opacity(
        opacity: emphasizeAsScheduled ? 0.82 : 1,
        child: inner,
      ),
    );
  }
}
