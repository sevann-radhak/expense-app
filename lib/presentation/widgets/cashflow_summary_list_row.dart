import 'package:flutter/material.dart';

import 'package:expense_app/presentation/formatting/currency_display.dart';
import 'package:expense_app/presentation/theme/category_accent_colors.dart';

const Widget kListRowOverflowMenuIconChild = SizedBox(
  width: 36,
  height: 36,
  child: Center(
    child: Icon(Icons.more_vert, size: 22),
  ),
);

class ListRowCategoryLeadingAccent extends StatelessWidget {
  const ListRowCategoryLeadingAccent({required this.categoryId, super.key});

  final String categoryId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 4,
          constraints: const BoxConstraints(minHeight: 40),
          decoration: BoxDecoration(
            color: categoryAccentColor(categoryId),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}

class CashflowSummaryTrailing extends StatelessWidget {
  const CashflowSummaryTrailing({
    required this.originalCurrencyCode,
    required this.originalAmount,
    required this.usdAmount,
    required this.localeName,
    super.key,
    this.settlement,
    this.menu,
  });

  final String originalCurrencyCode;
  final double originalAmount;
  final double usdAmount;
  final String localeName;
  final Widget? settlement;
  final Widget? menu;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final originalStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
    );
    final usdStyle = theme.textTheme.titleSmall;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (settlement != null)
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 12),
            child: settlement!,
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text.rich(
              TextSpan(
                style: originalStyle,
                children: displayCurrencyInlineSpans(
                  originalCurrencyCode,
                  originalAmount,
                  localeName,
                  style: originalStyle,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text.rich(
              TextSpan(
                style: usdStyle,
                children: displayCurrencyInlineSpans(
                  'USD',
                  usdAmount,
                  localeName,
                  style: usdStyle,
                ),
              ),
            ),
            if (menu != null) ...[
              const SizedBox(width: 2),
              menu!,
            ],
          ],
        ),
      ],
    );
  }
}
