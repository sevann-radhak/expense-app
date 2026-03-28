import 'package:flutter/material.dart';

import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/formatting/currency_display.dart';
import 'package:expense_app/presentation/theme/category_accent_colors.dart';

/// Compact expense row (category, subcategory, date, amounts) for lists.
class ExpenseSummaryListTile extends StatelessWidget {
  const ExpenseSummaryListTile({
    required this.expense,
    required this.categoryName,
    required this.subcategoryName,
    super.key,
    this.categoryId,
    this.onTap,
  });

  final Expense expense;
  final String categoryName;
  final String subcategoryName;

  /// When set, shows a left accent bar using the shared category palette.
  final String? categoryId;
  final VoidCallback? onTap;

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

    final child = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              Text(usdLabel, style: theme.textTheme.titleSmall),
            ],
          ),
        ],
      ),
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
