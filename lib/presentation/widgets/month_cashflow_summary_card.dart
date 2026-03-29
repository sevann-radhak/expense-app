import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/formatting/currency_display.dart';

/// Summary card: title, then one or two rows splitting **confirmed** (paid /
/// received) vs **still expected** original-currency chips and USD chips.
class MonthCashflowSummaryCard extends StatelessWidget {
  const MonthCashflowSummaryCard({
    required this.title,
    required this.locale,
    required this.l10n,
    required this.split,
    super.key,
    this.emptyStateMessage,
    this.confirmedBucketLabel,
    this.pendingBucketLabel,
  });

  final String title;
  final Locale locale;
  final AppLocalizations l10n;

  /// Per-currency original amounts and USD, split by settlement (see domain helpers).
  final MonthCashflowOriginalUsdSplit split;

  final String? emptyStateMessage;

  /// Overrides default [AppLocalizations.monthSummaryTotalsConfirmedLabel].
  final String? confirmedBucketLabel;

  /// Overrides default [AppLocalizations.monthSummaryTotalsExpectedLabel].
  final String? pendingBucketLabel;

  static double chipStripHeight(BuildContext context) {
    const base = kMinInteractiveDimension + 8;
    return MediaQuery.textScalerOf(context).scale(base).clamp(48.0, 80.0);
  }

  bool get _showEmptyState =>
      emptyStateMessage != null && split.isEmptyCashflow;

  static Map<String, double> _upperMap(Map<String, double> raw) {
    return {for (final e in raw.entries) e.key.toUpperCase(): e.value};
  }

  static bool _bucketVisible(Map<String, double> upper, double usdSum) {
    if (usdSum > 0) {
      return true;
    }
    for (final c in upper.keys.where((k) => k != 'USD')) {
      if ((upper[c] ?? 0) != 0) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final localeName = locale.toString();
    final chipH = chipStripHeight(context) + (kIsWeb ? 10 : 0);

    final settled = _upperMap(split.settledOriginalByCurrency);
    final pending = _upperMap(split.pendingOriginalByCurrency);
    final showSettled = _bucketVisible(settled, split.usdSettled);
    final showPending = _bucketVisible(pending, split.usdPending);

    return Card(
      elevation: 0,
      clipBehavior: Clip.none,
      color: scheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            if (_showEmptyState) ...[
              const SizedBox(height: 10),
              Text(
                emptyStateMessage!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ] else ...[
              const SizedBox(height: 10),
              if (showSettled)
                _SettlementBucketBlock(
                  rowLabel:
                      confirmedBucketLabel ?? l10n.monthSummaryTotalsConfirmedLabel,
                  byCurrency: settled,
                  usdSum: split.usdSettled,
                  localeName: localeName,
                  l10n: l10n,
                  chipStripHeightPx: chipH,
                  muted: false,
                ),
              if (showSettled && showPending) const SizedBox(height: 12),
              if (showPending)
                _SettlementBucketBlock(
                  rowLabel:
                      pendingBucketLabel ?? l10n.monthSummaryTotalsExpectedLabel,
                  byCurrency: pending,
                  usdSum: split.usdPending,
                  localeName: localeName,
                  l10n: l10n,
                  chipStripHeightPx: chipH,
                  muted: true,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SettlementBucketBlock extends StatelessWidget {
  const _SettlementBucketBlock({
    required this.rowLabel,
    required this.byCurrency,
    required this.usdSum,
    required this.localeName,
    required this.l10n,
    required this.chipStripHeightPx,
    required this.muted,
  });

  final String rowLabel;
  final Map<String, double> byCurrency;
  final double usdSum;
  final String localeName;
  final AppLocalizations l10n;
  final double chipStripHeightPx;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final leftCodes = byCurrency.keys.where((c) => c != 'USD').toList()..sort();

    final usdAccessibilityAmount = NumberFormat.decimalPatternDigits(
      locale: localeName,
      decimalDigits: 2,
    ).format(usdSum);

    final labelStyle = theme.textTheme.labelMedium?.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
      color: muted
          ? scheme.onSurfaceVariant.withValues(alpha: 0.85)
          : scheme.onSurfaceVariant,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(rowLabel, style: labelStyle),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: leftCodes.isEmpty
                  ? SizedBox(
                      height:
                          MonthCashflowSummaryCard.chipStripHeight(context)
                              .clamp(40.0, 80.0),
                    )
                  : SizedBox(
                      height: chipStripHeightPx,
                      child: MonthTotalsCurrencyStrip(
                        currencyCodes: leftCodes,
                        amountByCurrency: byCurrency,
                        localeName: localeName,
                        muted: muted,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Semantics(
              label: l10n.monthSummaryUsdTotal(usdAccessibilityAmount),
              child: _UsdSummaryChip(
                usdAmount: usdSum,
                localeName: localeName,
                muted: muted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _UsdSummaryChip extends StatelessWidget {
  const _UsdSummaryChip({
    required this.usdAmount,
    required this.localeName,
    required this.muted,
  });

  final double usdAmount;
  final String localeName;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (muted) {
      final style = theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: scheme.onSurfaceVariant.withValues(alpha: 0.92),
        letterSpacing: 0.12,
      );
      return DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHigh.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.65),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text.rich(
            TextSpan(
              style: style,
              children: displayCurrencyInlineSpans(
                'USD',
                usdAmount,
                localeName,
                style: style,
              ),
            ),
          ),
        ),
      );
    }

    final style = theme.textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.w700,
      color: scheme.onPrimaryContainer,
      letterSpacing: 0.15,
    );
    return DecoratedBox(
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Text.rich(
          TextSpan(
            style: style,
            children: displayCurrencyInlineSpans(
              'USD',
              usdAmount,
              localeName,
              style: style,
            ),
          ),
        ),
      ),
    );
  }
}

class MonthTotalsCurrencyStrip extends StatefulWidget {
  const MonthTotalsCurrencyStrip({
    required this.currencyCodes,
    required this.amountByCurrency,
    required this.localeName,
    super.key,
    this.muted = false,
  });

  final List<String> currencyCodes;
  final Map<String, double> amountByCurrency;
  final String localeName;
  final bool muted;

  @override
  State<MonthTotalsCurrencyStrip> createState() =>
      _MonthTotalsCurrencyStripState();
}

class _MonthTotalsCurrencyStripState extends State<MonthTotalsCurrencyStrip> {
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
              muted: widget.muted,
              currencyCode: codes[i],
              amount: widget.amountByCurrency[codes[i]]!,
              localeName: widget.localeName,
            ),
          );
        },
      ),
    );
  }
}

class _MonthSummaryCurrencyChip extends StatelessWidget {
  const _MonthSummaryCurrencyChip({
    required this.currencyCode,
    required this.amount,
    required this.localeName,
    required this.muted,
  });

  final String currencyCode;
  final double amount;
  final String localeName;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final fill = muted
        ? scheme.surfaceContainerHigh.withValues(alpha: 0.5)
        : scheme.surface;
    final borderA = muted ? 0.55 : 0.9;
    final textColor = muted
        ? scheme.onSurfaceVariant.withValues(alpha: 0.92)
        : scheme.onSurface;
    final style = theme.textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      color: textColor,
    );

    return Material(
      color: fill,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: BorderSide(
          color: scheme.outlineVariant.withValues(alpha: borderA),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Text.rich(
          TextSpan(
            style: style,
            children: displayCurrencyInlineSpans(
              currencyCode,
              amount,
              localeName,
              style: style,
            ),
          ),
        ),
      ),
    );
  }
}
