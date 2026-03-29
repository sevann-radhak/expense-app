import 'package:flutter/material.dart';

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
    required this.originalLabel,
    required this.usdLabel,
    super.key,
    this.settlement,
    this.menu,
  });

  final Widget? settlement;
  final String originalLabel;
  final String usdLabel;
  final Widget? menu;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              menu!,
            ],
          ],
        ),
      ],
    );
  }
}
