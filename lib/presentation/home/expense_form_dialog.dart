import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/providers/providers.dart';

class ExpenseFormDialog extends ConsumerStatefulWidget {
  const ExpenseFormDialog({super.key, this.initial});

  final Expense? initial;

  @override
  ConsumerState<ExpenseFormDialog> createState() => _ExpenseFormDialogState();
}

class _ExpenseFormDialogState extends ConsumerState<ExpenseFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _currencyController = TextEditingController(text: 'USD');
  final _fxController = TextEditingController(text: '1');

  late DateTime _occurredOn;
  String? _categoryId;
  String? _subcategoryId;
  bool _paidWithCreditCard = false;

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    if (i != null) {
      _occurredOn = DateTime(i.occurredOn.year, i.occurredOn.month, i.occurredOn.day);
      _categoryId = i.categoryId;
      _subcategoryId = i.subcategoryId;
      _amountController.text = _formatAmount(i.amountOriginal);
      _currencyController.text = i.currencyCode;
      _fxController.text = _formatAmount(i.manualFxRateToUsd);
      _paidWithCreditCard = i.paidWithCreditCard;
    } else {
      final n = DateTime.now();
      _occurredOn = DateTime(n.year, n.month, n.day);
    }
  }

  String _formatAmount(double v) {
    if (v == v.roundToDouble()) {
      return v.toInt().toString();
    }
    return v.toString();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _currencyController.dispose();
    _fxController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _occurredOn,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _occurredOn = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  double? _parseAmount(String raw) {
    final t = raw.trim().replaceAll(',', '.');
    return double.tryParse(t);
  }

  double get _previewUsd {
    final a = _parseAmount(_amountController.text);
    final fx = _parseAmount(_fxController.text);
    if (a == null || fx == null) {
      return 0;
    }
    return Expense.computeUsd(a, fx);
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final amount = _parseAmount(_amountController.text);
    final fx = _parseAmount(_fxController.text);
    if (amount == null || fx == null) {
      return;
    }
    if (_categoryId == null || _subcategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.expenseCategoryRequired)),
      );
      return;
    }
    final currency = _currencyController.text.trim().toUpperCase();
    if (currency.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.expenseCurrencyRequired)),
      );
      return;
    }

    final repo = ref.read(expenseRepositoryProvider);
    final expense = Expense(
      id: widget.initial?.id ?? Uuid().v4(),
      occurredOn: _occurredOn,
      categoryId: _categoryId!,
      subcategoryId: _subcategoryId!,
      amountOriginal: amount,
      currencyCode: currency,
      manualFxRateToUsd: fx,
      amountUsd: Expense.computeUsd(amount, fx),
      paidWithCreditCard: _paidWithCreditCard,
    );

    try {
      if (widget.initial == null) {
        await repo.create(expense);
      } else {
        await repo.update(expense);
      }
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

  Future<void> _confirmDelete() async {
    final l10n = AppLocalizations.of(context)!;
    final id = widget.initial?.id;
    if (id == null) {
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteExpenseConfirmTitle),
        content: Text(l10n.deleteExpenseConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.confirmDelete),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      await ref.read(expenseRepositoryProvider).delete(id);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final categories = ref.watch(categoriesStreamProvider).valueOrNull ?? [];
    final subsAsync = _categoryId == null
        ? const AsyncValue<List<Subcategory>>.data([])
        : ref.watch(subcategoriesForCategoryProvider(_categoryId!));

    if (widget.initial == null &&
        _categoryId == null &&
        categories.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _categoryId = categories.first.id;
          });
        }
      });
    }

    final subs = subsAsync.valueOrNull ?? [];
    if (_categoryId != null &&
        subs.isNotEmpty &&
        (_subcategoryId == null || !subs.any((s) => s.id == _subcategoryId))) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _subcategoryId = subs.first.id;
          });
        }
      });
    }

    return AlertDialog(
      title: Text(
        widget.initial == null ? l10n.addExpenseTitle : l10n.editExpenseTitle,
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
                if (widget.initial != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: _confirmDelete,
                      icon: const Icon(Icons.delete_outline),
                      label: Text(l10n.deleteExpenseAction),
                    ),
                  ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.expenseDateLabel),
                  subtitle: Text(ExpenseDates.toStorageDate(_occurredOn)),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickDate,
                  ),
                ),
                DropdownButtonFormField<String>(
                  // Controlled selection; `initialValue` does not track parent updates here.
                  // ignore: deprecated_member_use
                  value: _categoryId != null &&
                          categories.any((c) => c.id == _categoryId)
                      ? _categoryId
                      : null,
                  decoration: InputDecoration(labelText: l10n.expenseCategoryLabel),
                  items: categories
                      .map(
                        (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                      )
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      _categoryId = v;
                      _subcategoryId = null;
                    });
                  },
                  validator: (v) =>
                      v == null ? l10n.expenseCategoryRequired : null,
                ),
                const SizedBox(height: 8),
                subsAsync.when(
                  data: (list) {
                    if (list.isEmpty && _categoryId != null) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          l10n.expenseNoSubcategories,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      );
                    }
                    return DropdownButtonFormField<String>(
                      // ignore: deprecated_member_use
                      value: _subcategoryId != null &&
                              list.any((s) => s.id == _subcategoryId)
                          ? _subcategoryId
                          : null,
                      decoration:
                          InputDecoration(labelText: l10n.expenseSubcategoryLabel),
                      items: list
                          .map(
                            (s) =>
                                DropdownMenuItem(value: s.id, child: Text(s.name)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _subcategoryId = v),
                      validator: (v) =>
                          v == null ? l10n.expenseSubcategoryRequired : null,
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('$e'),
                ),
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(labelText: l10n.expenseAmountLabel),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  onChanged: (_) => setState(() {}),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return l10n.expenseAmountRequired;
                    }
                    if (_parseAmount(v) == null) {
                      return l10n.expenseAmountInvalid;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _currencyController,
                  decoration: InputDecoration(labelText: l10n.expenseCurrencyLabel),
                  textCapitalization: TextCapitalization.characters,
                  onChanged: (_) => setState(() {}),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return l10n.expenseCurrencyRequired;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _fxController,
                  decoration:
                      InputDecoration(labelText: l10n.expenseFxToUsdLabel),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  onChanged: (_) => setState(() {}),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return l10n.expenseFxRequired;
                    }
                    final x = _parseAmount(v);
                    if (x == null || x <= 0) {
                      return l10n.expenseFxInvalid;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.expenseUsdComputedLabel(_previewUsd.toStringAsFixed(2)),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.expensePaidWithCardLabel),
                  value: _paidWithCreditCard,
                  onChanged: (v) => setState(() => _paidWithCreditCard = v),
                ),
              ],
            ),
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
          child: Text(l10n.saveExpenseAction),
        ),
      ],
    );
  }
}
