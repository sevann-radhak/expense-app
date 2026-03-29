import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:expense_app/data/local/default_fx_rates_loader.dart';
import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/formatting/currency_display.dart';
import 'package:expense_app/presentation/providers/providers.dart';
import 'package:expense_app/presentation/recurring/recurring_occurrence_scope_dialogs.dart';
import 'package:expense_app/presentation/theme/category_accent_colors.dart';

enum _IncomeRecurrenceFormKind { monthly, weekly }

class IncomeFormDialog extends ConsumerWidget {
  const IncomeFormDialog({super.key, this.initial});

  final IncomeEntry? initial;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(defaultFxCatalogProvider);
    final userSettings = ref.watch(appUserSettingsProvider);
    return async.when(
      data: (catalog) => _IncomeFormLoaded(
        catalog: catalog,
        initial: initial,
        userDefaultCurrencyCode: userSettings.defaultCurrencyCode,
      ),
      loading: () => const AlertDialog(
        content: SizedBox(
          width: 200,
          height: 120,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, _) => AlertDialog(content: Text('$e')),
    );
  }
}

class _IncomeFormLoaded extends ConsumerStatefulWidget {
  const _IncomeFormLoaded({
    required this.catalog,
    this.initial,
    this.userDefaultCurrencyCode,
  });

  final DefaultFxCatalog catalog;
  final IncomeEntry? initial;
  final String? userDefaultCurrencyCode;

  @override
  ConsumerState<_IncomeFormLoaded> createState() => _IncomeFormLoadedState();
}

class _IncomeFormLoadedState extends ConsumerState<_IncomeFormLoaded> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _fxController = TextEditingController();
  final _amountFocus = FocusNode();
  final _categorySearch = SearchController();
  final _subcategorySearch = SearchController();

  late DateTime _receivedOn;
  late String _currencyCode;
  String? _incomeCategoryId;
  String? _incomeSubcategoryId;
  bool _appliedInitialAmountMask = false;
  bool _makeRecurring = false;
  _IncomeRecurrenceFormKind _recurrenceKind = _IncomeRecurrenceFormKind.monthly;
  final _horizonMonthsController = TextEditingController(text: '12');
  RecurringMaterializedEditScope _recurringSaveScope =
      RecurringMaterializedEditScope.thisOccurrenceOnly;

  bool get _editingRecurringRow =>
      widget.initial?.recurringSeriesId?.isNotEmpty == true;

  bool get _dateLockedForRecurringBulk =>
      _editingRecurringRow &&
      _recurringSaveScope ==
          RecurringMaterializedEditScope.thisAndFutureMaterialized;

  @override
  void initState() {
    super.initState();
    _amountFocus.addListener(_onAmountFocusChange);
    final i = widget.initial;
    final catalog = widget.catalog;
    if (i != null) {
      _receivedOn = DateTime(i.receivedOn.year, i.receivedOn.month, i.receivedOn.day);
      _incomeCategoryId = i.incomeCategoryId;
      _incomeSubcategoryId = i.incomeSubcategoryId;
      _currencyCode = i.currencyCode.toUpperCase();
      final m = i.manualFxRateToUsd;
      _fxController.text = m > 0
          ? formatLocalUnitsPerUsdForField(1.0 / m)
          : formatLocalUnitsPerUsdForField(catalog.localUnitsPerUsdFor(_currencyCode));
      _descriptionController.text = i.description;
    } else {
      final n = DateTime.now();
      _receivedOn = DateTime(n.year, n.month, n.day);
      _currencyCode = effectiveDefaultCurrencyForForm(
        widget.userDefaultCurrencyCode,
        catalog,
      );
      _fxController.text = formatLocalUnitsPerUsdForField(
        catalog.localUnitsPerUsdFor(_currencyCode),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_appliedInitialAmountMask) {
      return;
    }
    final i = widget.initial;
    if (i != null) {
      _appliedInitialAmountMask = true;
      final loc = Localizations.localeOf(context).toString();
      _amountController.text = formatAmountGrouped(i.amountOriginal, loc);
    }
  }

  void _onAmountFocusChange() {
    if (!mounted) {
      return;
    }
    final loc = Localizations.localeOf(context).toString();
    if (_amountFocus.hasFocus) {
      final v = tryParseDecimalInput(_amountController.text, loc);
      if (v != null) {
        final plain = formatAmountPlainForEdit(v);
        if (_amountController.text != plain) {
          _amountController.value = TextEditingValue(
            text: plain,
            selection: TextSelection.collapsed(offset: plain.length),
          );
        }
      }
    } else {
      final v = tryParseDecimalInput(_amountController.text, loc);
      if (v != null) {
        final g = formatAmountGrouped(v, loc);
        if (_amountController.text != g) {
          _amountController.value = TextEditingValue(
            text: g,
            selection: TextSelection.collapsed(offset: g.length),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _amountFocus.removeListener(_onAmountFocusChange);
    _amountFocus.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _fxController.dispose();
    _categorySearch.dispose();
    _subcategorySearch.dispose();
    _horizonMonthsController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _receivedOn,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _receivedOn = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  double? _parseFx(String raw) {
    final t = raw.trim().replaceAll(',', '.');
    return double.tryParse(t);
  }

  double get _previewUsd {
    final loc = Localizations.localeOf(context).toString();
    final amount = tryParseDecimalInput(_amountController.text, loc);
    final localPerUsd = _parseFx(_fxController.text);
    if (amount == null || localPerUsd == null || localPerUsd <= 0) {
      return 0;
    }
    return amount / localPerUsd;
  }

  List<DropdownMenuItem<String>> _currencyMenuItems(AppLocalizations l10n) {
    final catalog = widget.catalog;
    final inCatalog = catalog.currencies.map((c) => c.code).toSet();
    final items = catalog.currencies
        .map(
          (c) => DropdownMenuItem<String>(
            value: c.code,
            child: Text(c.menuLabel),
          ),
        )
        .toList();
    final code = _currencyCode;
    if (!inCatalog.contains(code)) {
      items.insert(
        0,
        DropdownMenuItem<String>(
          value: code,
          child: Text(l10n.expenseCurrencyCustom(code)),
        ),
      );
    }
    return items;
  }

  void _onCurrencyChanged(String? code) {
    if (code == null) {
      return;
    }
    setState(() {
      _currencyCode = code;
      final opt = widget.catalog.optionForCode(code);
      if (opt != null) {
        _fxController.text = formatLocalUnitsPerUsdForField(opt.localUnitsPerUsd);
      }
    });
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final loc = Localizations.localeOf(context).toString();
    final amount = tryParseDecimalInput(_amountController.text, loc);
    final localPerUsd = _parseFx(_fxController.text);
    if (amount == null || localPerUsd == null || localPerUsd <= 0) {
      return;
    }
    if (_incomeCategoryId == null || _incomeSubcategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.expenseCategoryRequired)),
      );
      return;
    }

    if (widget.initial == null && _makeRecurring) {
      final h = int.tryParse(_horizonMonthsController.text.trim());
      if (h == null || h < 1 || h > 120) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.expenseFormHorizonMonthsInvalid)),
        );
        return;
      }
    }

    final manualFx = 1.0 / localPerUsd;
    final repo = ref.read(incomeRepositoryProvider);
    final seriesId = const Uuid().v4();
    final makeRecurring = widget.initial == null && _makeRecurring;
    final incomeId = makeRecurring
        ? materializedIncomeIdForSeriesDate(
            seriesId: seriesId,
            receivedOn: _receivedOn,
          )
        : (widget.initial?.id ?? const Uuid().v4());

    final today = calendarTodayLocal();
    final recvDay = calendarDateOnly(_receivedOn);
    final firstOccurrenceSettled =
        makeRecurring && !recvDay.isAfter(calendarDateOnly(today));
    final editingRecurringRow =
        widget.initial?.recurringSeriesId?.isNotEmpty == true;

    PaymentExpectationStatus resolvedExpectationStatus;
    DateTime? resolvedExpectationConfirmedOn;
    if (editingRecurringRow) {
      resolvedExpectationStatus = widget.initial!.expectationStatus ??
          PaymentExpectationStatus.expected;
      resolvedExpectationConfirmedOn =
          widget.initial!.expectationConfirmedOn;
    } else if (makeRecurring) {
      resolvedExpectationStatus = firstOccurrenceSettled
          ? PaymentExpectationStatus.confirmedPaid
          : PaymentExpectationStatus.expected;
      resolvedExpectationConfirmedOn =
          firstOccurrenceSettled ? recvDay : null;
    } else {
      final initialSt = widget.initial?.expectationStatus;
      if (initialSt == PaymentExpectationStatus.skipped ||
          initialSt == PaymentExpectationStatus.waived) {
        resolvedExpectationStatus = initialSt!;
        resolvedExpectationConfirmedOn =
            widget.initial?.expectationConfirmedOn;
      } else {
        final editingOneOff = widget.initial != null &&
            (widget.initial!.recurringSeriesId == null ||
                widget.initial!.recurringSeriesId!.isEmpty);
        if (editingOneOff) {
          resolvedExpectationStatus =
              widget.initial!.expectationStatus ??
                  (!recvDay.isAfter(calendarDateOnly(today))
                      ? PaymentExpectationStatus.confirmedPaid
                      : PaymentExpectationStatus.expected);
          if (resolvedExpectationStatus ==
              PaymentExpectationStatus.expected) {
            resolvedExpectationConfirmedOn = null;
          } else {
            resolvedExpectationConfirmedOn =
                widget.initial!.expectationConfirmedOn ??
                    (recvDay.isAfter(calendarDateOnly(today))
                        ? calendarDateOnly(today)
                        : recvDay);
          }
        } else {
          final standaloneSettled =
              !recvDay.isAfter(calendarDateOnly(today));
          resolvedExpectationStatus = standaloneSettled
              ? PaymentExpectationStatus.confirmedPaid
              : PaymentExpectationStatus.expected;
          resolvedExpectationConfirmedOn = standaloneSettled
              ? (recvDay.isAfter(calendarDateOnly(today))
                  ? calendarDateOnly(today)
                  : recvDay)
              : null;
        }
      }
    }

    final entry = IncomeEntry(
      id: incomeId,
      receivedOn: _receivedOn,
      incomeCategoryId: _incomeCategoryId!,
      incomeSubcategoryId: _incomeSubcategoryId!,
      amountOriginal: amount,
      currencyCode: _currencyCode,
      manualFxRateToUsd: manualFx,
      amountUsd: IncomeEntry.computeUsd(amount, manualFx),
      description: _descriptionController.text.trim(),
      recurringSeriesId: widget.initial?.recurringSeriesId ??
          (makeRecurring ? seriesId : null),
      expectationStatus: resolvedExpectationStatus,
      expectationConfirmedOn: resolvedExpectationConfirmedOn,
    );

    try {
      if (widget.initial == null) {
        await repo.create(entry);
        if (makeRecurring) {
          final h = int.parse(_horizonMonthsController.text.trim());
          final rule = _recurrenceKind == _IncomeRecurrenceFormKind.monthly
              ? RecurrenceMonthlyByCalendarDay(calendarDay: _receivedOn.day)
              : RecurrenceWeekly(
                  intervalWeeks: 1,
                  weekdays: {_receivedOn.weekday},
                );
          final series = IncomeRecurringSeries(
            id: seriesId,
            anchorReceivedOn: _receivedOn,
            rule: rule,
            endCondition: const RecurrenceEndNever(),
            horizonMonths: h,
            active: true,
            incomeCategoryId: entry.incomeCategoryId,
            incomeSubcategoryId: entry.incomeSubcategoryId,
            amountOriginal: entry.amountOriginal,
            currencyCode: entry.currencyCode,
            manualFxRateToUsd: entry.manualFxRateToUsd,
            amountUsd: entry.amountUsd,
            description: entry.description,
          );
          await ref
              .read(recurringIncomeSeriesRepositoryProvider)
              .upsertAndRematerialize(series, calendarTodayLocal());
        }
      } else {
        if (editingRecurringRow &&
            _recurringSaveScope ==
                RecurringMaterializedEditScope.thisAndFutureMaterialized) {
          final seriesRepo =
              ref.read(recurringIncomeSeriesRepositoryProvider);
          final sid = widget.initial!.recurringSeriesId!;
          final series = await seriesRepo.getById(sid);
          if (series == null) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.recurringSeriesMissingForUpdate)),
              );
            }
            return;
          }
          final updated = series.copyWith(
            incomeCategoryId: entry.incomeCategoryId,
            incomeSubcategoryId: entry.incomeSubcategoryId,
            amountOriginal: entry.amountOriginal,
            currencyCode: entry.currencyCode,
            manualFxRateToUsd: entry.manualFxRateToUsd,
            amountUsd: entry.amountUsd,
          );
          await seriesRepo.updateSeriesTemplateAndMaterializedFromDate(
            updatedSeries: updated,
            fromReceivedOnDateOnly: calendarDateOnly(_receivedOn),
            todayDateOnly: today,
            occurrenceNoteFromEditedDate: entry.description,
          );
        } else {
          await repo.update(entry);
        }
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
    final initial = widget.initial;
    if (initial == null) {
      return;
    }
    if (initial.recurringSeriesId?.isNotEmpty == true) {
      final scope = await showRecurringOccurrenceDeleteScopeDialog(context);
      if (scope == null || !mounted) {
        return;
      }
      final sid = initial.recurringSeriesId!;
      try {
        switch (scope) {
          case RecurringOccurrenceDeleteScope.thisOccurrenceOnly:
            await ref.read(incomeRepositoryProvider).delete(initial.id);
            break;
          case RecurringOccurrenceDeleteScope.thisAndFutureInSeries:
            await ref
                .read(recurringIncomeSeriesRepositoryProvider)
                .trimSeriesFromOccurrenceDate(
                  seriesId: sid,
                  fromReceivedOnDateOnly:
                      calendarDateOnly(initial.receivedOn),
                  todayDateOnly: calendarTodayLocal(),
                );
            break;
        }
        if (mounted) {
          Navigator.of(context).pop();
        }
      } on Object catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$e')),
          );
        }
      }
      return;
    }
    final id = initial.id;
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
      await ref.read(incomeRepositoryProvider).delete(id);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeName = Localizations.localeOf(context).toString();
    final categories = ref.watch(incomeCategoriesStreamProvider).valueOrNull ?? [];
    final subsAsync = _incomeCategoryId == null
        ? const AsyncValue<List<IncomeSubcategory>>.data([])
        : ref.watch(incomeSubcategoriesForCategoryProvider(_incomeCategoryId!));
    final subs = subsAsync.valueOrNull ?? [];

    if (widget.initial == null &&
        _incomeCategoryId == null &&
        categories.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _incomeCategoryId = categories.first.id);
        }
      });
    }
    if (_incomeCategoryId != null &&
        subs.isNotEmpty &&
        (_incomeSubcategoryId == null ||
            !subs.any((s) => s.id == _incomeSubcategoryId))) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _incomeSubcategoryId = subs.first.id);
        }
      });
    }

    IncomeCategory? selectedCat;
    for (final c in categories) {
      if (c.id == _incomeCategoryId) {
        selectedCat = c;
        break;
      }
    }
    IncomeSubcategory? selectedSub;
    for (final s in subs) {
      if (s.id == _incomeSubcategoryId) {
        selectedSub = s;
        break;
      }
    }

    return AlertDialog(
      title: Text(
        widget.initial == null ? l10n.incomeFormAddTitle : l10n.incomeFormEditTitle,
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
                if (_editingRecurringRow)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              l10n.incomeFromRecurringBanner,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l10n.recurringFormApplyScopeTitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            SegmentedButton<RecurringMaterializedEditScope>(
                              showSelectedIcon: false,
                              segments: [
                                ButtonSegment(
                                  value: RecurringMaterializedEditScope
                                      .thisOccurrenceOnly,
                                  label: Text(
                                    l10n.recurringFormApplyThisOccurrenceOnly,
                                  ),
                                ),
                                ButtonSegment(
                                  value: RecurringMaterializedEditScope
                                      .thisAndFutureMaterialized,
                                  label: Text(
                                    l10n.recurringFormApplyThisAndFuture,
                                  ),
                                ),
                              ],
                              selected: {_recurringSaveScope},
                              onSelectionChanged: (next) {
                                if (next.isEmpty) {
                                  return;
                                }
                                setState(() {
                                  _recurringSaveScope = next.single;
                                  if (_dateLockedForRecurringBulk) {
                                    final i = widget.initial!;
                                    _receivedOn = DateTime(
                                      i.receivedOn.year,
                                      i.receivedOn.month,
                                      i.receivedOn.day,
                                    );
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
                  subtitle: Text(ExpenseDates.toStorageDate(_receivedOn)),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed:
                        _dateLockedForRecurringBulk ? null : _pickDate,
                  ),
                ),
                Text(
                  l10n.taxonomySearchCategoryHint,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 4),
                SearchAnchor(
                  searchController: _categorySearch,
                  builder: (context, controller) {
                    return SearchBar(
                      controller: controller,
                      hintText: selectedCat?.name ?? l10n.expenseCategoryLabel,
                      leading: _incomeCategoryId != null
                          ? Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor:
                                    categoryAccentColor(_incomeCategoryId!),
                              ),
                            )
                          : const Icon(Icons.search),
                      onTap: () => controller.openView(),
                      onChanged: (_) => controller.openView(),
                    );
                  },
                  suggestionsBuilder: (context, controller) {
                    final q = controller.text.trim().toLowerCase();
                    final list = q.isEmpty
                        ? categories
                        : categories
                            .where((c) => c.name.toLowerCase().contains(q))
                            .toList();
                    return list
                        .map(
                          (c) => ListTile(
                            leading: CircleAvatar(
                              radius: 14,
                              backgroundColor: categoryAccentColor(c.id),
                            ),
                            title: Text(c.name),
                            onTap: () {
                              setState(() {
                                _incomeCategoryId = c.id;
                                _incomeSubcategoryId = null;
                              });
                              controller.closeView(c.name);
                            },
                          ),
                        )
                        .toList();
                  },
                ),
                const SizedBox(height: 12),
                if (_incomeCategoryId != null) ...[
                  Text(
                    l10n.taxonomySearchSubcategoryHint,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 4),
                  subsAsync.when(
                    data: (list) {
                      if (list.isEmpty) {
                        return Text(
                          l10n.expenseNoSubcategories,
                          style: Theme.of(context).textTheme.bodySmall,
                        );
                      }
                      return SearchAnchor(
                        searchController: _subcategorySearch,
                        builder: (context, controller) {
                          return SearchBar(
                            controller: controller,
                            hintText:
                                selectedSub?.name ?? l10n.expenseSubcategoryLabel,
                            leading: _incomeCategoryId != null
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: CircleAvatar(
                                      radius: 14,
                                      backgroundColor: categoryAccentColor(
                                        _incomeCategoryId!,
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.search),
                            onTap: () => controller.openView(),
                            onChanged: (_) => controller.openView(),
                          );
                        },
                        suggestionsBuilder: (context, controller) {
                          final q = controller.text.trim().toLowerCase();
                          final filtered = q.isEmpty
                              ? list
                              : list
                                  .where((s) => s.name.toLowerCase().contains(q))
                                  .toList();
                          return filtered
                              .map(
                                (s) {
                                  final i = list.indexOf(s);
                                  final parent =
                                      categoryAccentColor(_incomeCategoryId!);
                                  final tone = subcategoryTonalColor(
                                    parent,
                                    i,
                                    list.length,
                                  );
                                  return ListTile(
                                    leading: CircleAvatar(
                                      radius: 14,
                                      backgroundColor: tone,
                                    ),
                                    title: Text(s.name),
                                    onTap: () {
                                      setState(() => _incomeSubcategoryId = s.id);
                                      controller.closeView(s.name);
                                    },
                                  );
                                },
                              )
                              .toList();
                        },
                      );
                    },
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text('$e'),
                  ),
                ],
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: l10n.expenseNotesLabel,
                    alignLabelWithHint: true,
                  ),
                  maxLength: 500,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                ),
                Text(
                  l10n.expenseFxPresetHint(widget.catalog.asOf),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 46,
                      child: DropdownButtonFormField<String>(
                        // ignore: deprecated_member_use
                        value: _currencyCode,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: l10n.expenseCurrencyLabel,
                        ),
                        items: _currencyMenuItems(l10n),
                        onChanged: _onCurrencyChanged,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 54,
                      child: TextFormField(
                        controller: _amountController,
                        focusNode: _amountFocus,
                        decoration: InputDecoration(
                          labelText: l10n.expenseAmountLabel,
                          hintText: formatAmountGrouped(10000, localeName),
                        ),
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
                          final loc = Localizations.localeOf(context).toString();
                          if (tryParseDecimalInput(v, loc) == null) {
                            return l10n.expenseAmountInvalid;
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _fxController,
                  decoration: InputDecoration(
                    labelText: l10n.expenseFxFieldLabel,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  onChanged: (_) => setState(() {}),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return l10n.expenseFxRequired;
                    }
                    final x = _parseFx(v);
                    if (x == null || x <= 0) {
                      return l10n.expenseFxInvalid;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.expenseUsdComputedLabel(
                    formatUsdAmountOnly(_previewUsd, localeName),
                  ),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                if (widget.initial == null) ...[
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.incomeFormMakeRecurringLabel),
                    value: _makeRecurring,
                    onChanged: (v) => setState(() => _makeRecurring = v),
                  ),
                  if (_makeRecurring) ...[
                    DropdownButtonFormField<_IncomeRecurrenceFormKind>(
                      // ignore: deprecated_member_use
                      value: _recurrenceKind,
                      decoration: InputDecoration(
                        labelText: l10n.expenseFormRecurrenceLabel,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: _IncomeRecurrenceFormKind.monthly,
                          child: Text(l10n.expenseFormRecurrenceMonthly),
                        ),
                        DropdownMenuItem(
                          value: _IncomeRecurrenceFormKind.weekly,
                          child: Text(l10n.expenseFormRecurrenceWeekly),
                        ),
                      ],
                      onChanged: (v) => setState(
                        () => _recurrenceKind =
                            v ?? _IncomeRecurrenceFormKind.monthly,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _horizonMonthsController,
                      decoration: InputDecoration(
                        labelText: l10n.expenseFormHorizonMonthsLabel,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ],
                ],
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
