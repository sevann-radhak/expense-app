import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/formatting/currency_display.dart';
import 'package:expense_app/presentation/providers/providers.dart';
import 'package:expense_app/presentation/settings/recurrence_rule_summary.dart';

class RecurringIncomeSeriesEditDialog extends ConsumerStatefulWidget {
  const RecurringIncomeSeriesEditDialog({super.key, required this.series});

  final IncomeRecurringSeries series;

  @override
  ConsumerState<RecurringIncomeSeriesEditDialog> createState() =>
      _RecurringIncomeSeriesEditDialogState();
}

class _RecurringIncomeSeriesEditDialogState
    extends ConsumerState<RecurringIncomeSeriesEditDialog> {
  late final TextEditingController _amountController;
  late final TextEditingController _horizonController;
  late final TextEditingController _descriptionController;
  bool _appliedAmountMask = false;

  @override
  void initState() {
    super.initState();
    final s = widget.series;
    _amountController = TextEditingController();
    _horizonController = TextEditingController(text: '${s.horizonMonths}');
    _descriptionController = TextEditingController(text: s.description);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_appliedAmountMask) {
      return;
    }
    _appliedAmountMask = true;
    final loc = Localizations.localeOf(context).toString();
    _amountController.text = formatAmountGrouped(
      widget.series.amountOriginal,
      loc,
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _horizonController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final loc = Localizations.localeOf(context).toString();
    final amount = tryParseDecimalInput(_amountController.text, loc);
    final h = int.tryParse(_horizonController.text.trim());
    if (amount == null || amount <= 0) {
      return;
    }
    if (h == null || h < 1 || h > 120) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.expenseFormHorizonMonthsInvalid)),
      );
      return;
    }
    final s = widget.series;
    final updated = s.copyWith(
      amountOriginal: amount,
      horizonMonths: h,
      description: _descriptionController.text.trim(),
      amountUsd: IncomeEntry.computeUsd(amount, s.manualFxRateToUsd),
    );
    try {
      await ref
          .read(recurringIncomeSeriesRepositoryProvider)
          .upsertAndRematerialize(updated, calendarTodayLocal());
      if (mounted) {
        Navigator.of(context).pop();
      }
    } on InvalidSubcategoryPairingException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.invalidSubcategoryPairing)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeName = Localizations.localeOf(context).toString();
    return AlertDialog(
      title: Text(l10n.recurringIncomeSeriesEditTitle),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                recurrenceRuleSummary(context, widget.series.rule),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              Text(
                l10n.recurringSeriesReadOnlyRule,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: l10n.recurringSeriesAmountLabel,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _horizonController,
                decoration: InputDecoration(
                  labelText: l10n.recurringSeriesHorizonLabel,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: l10n.recurringSeriesDescriptionLabel,
                ),
                maxLines: 2,
                maxLength: 500,
              ),
              const SizedBox(height: 8),
              Builder(
                builder: (ctx) {
                  final preview = IncomeEntry.computeUsd(
                    tryParseDecimalInput(_amountController.text, localeName) ??
                        widget.series.amountOriginal,
                    widget.series.manualFxRateToUsd,
                  );
                  final st = Theme.of(ctx).textTheme.titleSmall;
                  return Text.rich(
                    TextSpan(
                      style: st,
                      children: [
                        TextSpan(text: l10n.expenseUsdComputedPrefix),
                        ...usdAmountOnlyInlineSpans(
                          preview,
                          localeName,
                          style: st,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _save,
          child: Text(l10n.recurringSeriesSave),
        ),
      ],
    );
  }
}
