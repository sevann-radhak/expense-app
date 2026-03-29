import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/formatting/currency_display.dart';
import 'package:expense_app/presentation/providers/providers.dart';

class PaymentInstrumentFormDialog extends ConsumerStatefulWidget {
  const PaymentInstrumentFormDialog({super.key, this.initial});

  final PaymentInstrument? initial;

  @override
  ConsumerState<PaymentInstrumentFormDialog> createState() =>
      _PaymentInstrumentFormDialogState();
}

class _PaymentInstrumentFormDialogState
    extends ConsumerState<PaymentInstrumentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _labelController;
  late final TextEditingController _bankController;
  late final TextEditingController _billingDayController;
  late final TextEditingController _annualFeeController;
  late final TextEditingController _monthlyFeeController;
  late final TextEditingController _feeDescriptionController;

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    _labelController = TextEditingController(text: i?.label ?? '');
    _bankController = TextEditingController(text: i?.bankName ?? '');
    _billingDayController = TextEditingController(
      text: i?.billingCycleDay?.toString() ?? '',
    );
    _annualFeeController = TextEditingController(
      text: i?.annualFeeAmount != null
          ? formatAmountPlainForEdit(i!.annualFeeAmount!)
          : '',
    );
    _monthlyFeeController = TextEditingController(
      text: i?.monthlyFeeAmount != null
          ? formatAmountPlainForEdit(i!.monthlyFeeAmount!)
          : '',
    );
    _feeDescriptionController = TextEditingController(
      text: i?.feeDescription ?? '',
    );
  }

  @override
  void dispose() {
    _labelController.dispose();
    _bankController.dispose();
    _billingDayController.dispose();
    _annualFeeController.dispose();
    _monthlyFeeController.dispose();
    _feeDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final localeName = Localizations.localeOf(context).toString();
    int? billingDay;
    final dayRaw = _billingDayController.text.trim();
    if (dayRaw.isNotEmpty) {
      billingDay = int.tryParse(dayRaw);
      if (billingDay == null || billingDay < 1 || billingDay > 31) {
        return;
      }
    }
    double? annual;
    final a = _annualFeeController.text.trim();
    if (a.isNotEmpty) {
      annual = tryParseDecimalInput(a, localeName);
      if (annual == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.expenseAmountInvalid)),
        );
        return;
      }
    }
    double? monthly;
    final m = _monthlyFeeController.text.trim();
    if (m.isNotEmpty) {
      monthly = tryParseDecimalInput(m, localeName);
      if (monthly == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.expenseAmountInvalid)),
        );
        return;
      }
    }
    final bank = _bankController.text.trim();
    final instrument = PaymentInstrument(
      id: widget.initial?.id ?? const Uuid().v4(),
      label: _labelController.text.trim(),
      bankName: bank.isEmpty ? null : bank,
      billingCycleDay: billingDay,
      annualFeeAmount: annual,
      monthlyFeeAmount: monthly,
      feeDescription: _feeDescriptionController.text.trim().isEmpty
          ? null
          : _feeDescriptionController.text.trim(),
    );
    final repo = ref.read(paymentInstrumentRepositoryProvider);
    try {
      if (widget.initial == null) {
        await repo.create(instrument);
      } else {
        await repo.update(instrument);
      }
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } on Object catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeName = Localizations.localeOf(context).toString();
    final isNew = widget.initial == null;
    return AlertDialog(
      title: Text(
        isNew
            ? l10n.settingsPaymentInstrumentCreateTitle
            : l10n.settingsPaymentInstrumentEditTitle,
      ),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _labelController,
                  decoration: InputDecoration(
                    labelText: l10n.settingsPaymentInstrumentLabel,
                    border: const OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return l10n.settingsPaymentInstrumentLabelRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _bankController,
                  decoration: InputDecoration(
                    labelText: l10n.settingsPaymentInstrumentBank,
                    border: const OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _billingDayController,
                  decoration: InputDecoration(
                    labelText: l10n.settingsPaymentInstrumentBillingDay,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return null;
                    }
                    final n = int.tryParse(v.trim());
                    if (n == null || n < 1 || n > 31) {
                      return l10n.settingsPaymentInstrumentBillingDayInvalid;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _annualFeeController,
                  decoration: InputDecoration(
                    labelText: l10n.settingsPaymentInstrumentAnnualFee,
                    border: const OutlineInputBorder(),
                    hintText: formatAmountGrouped(0, localeName),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _monthlyFeeController,
                  decoration: InputDecoration(
                    labelText: l10n.settingsPaymentInstrumentMonthlyFee,
                    border: const OutlineInputBorder(),
                    hintText: formatAmountGrouped(0, localeName),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _feeDescriptionController,
                  decoration: InputDecoration(
                    labelText: l10n.settingsPaymentInstrumentFeeDescription,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(l10n.settingsPaymentInstrumentSave),
        ),
      ],
    );
  }
}
