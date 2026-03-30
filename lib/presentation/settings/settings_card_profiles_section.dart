import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/providers/providers.dart';
import 'package:expense_app/presentation/settings/payment_instrument_form_dialog.dart';
import 'package:expense_app/presentation/theme/app_icons.dart';

class SettingsCardProfilesSection extends ConsumerWidget {
  const SettingsCardProfilesSection({super.key});

  String _subtitle(AppLocalizations l10n, PaymentInstrument p) {
    final parts = <String>[];
    final bank = p.bankName?.trim();
    if (bank != null && bank.isNotEmpty) {
      parts.add(bank);
    }
    final d = p.billingCycleDay;
    if (d != null) {
      parts.add(l10n.settingsPaymentInstrumentCycleDaySummary(d));
    }
    final sc = p.statementClosingDay;
    if (sc != null) {
      parts.add('Close $sc');
    }
    final pd = p.paymentDueDay;
    if (pd != null) {
      parts.add('Due $pd');
    }
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final async = ref.watch(paymentInstrumentsStreamProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.settingsPaymentInstrumentsSectionTitle,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.settingsPaymentInstrumentsDescription,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () async {
            await showDialog<bool>(
              context: context,
              builder: (ctx) => const PaymentInstrumentFormDialog(),
            );
          },
          icon: Icon(AppIcons.creditCard),
          label: Text(l10n.settingsPaymentInstrumentAdd),
        ),
        const SizedBox(height: 12),
        async.when(
          data: (list) {
            if (list.isEmpty) {
              return Text(
                l10n.settingsPaymentInstrumentNoneYet,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              );
            }
            return Column(
              children: list.map((p) {
                final sub = _subtitle(l10n, p);
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 4, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                p.label,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                if (!p.isActive)
                                  Chip(
                                    label: Text(
                                      l10n.settingsPaymentInstrumentInactive,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                if (p.isDefault)
                                  Chip(
                                    label: Text(
                                      l10n.settingsPaymentInstrumentDefaultBadge,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                              ],
                            ),
                          ],
                        ),
                        if (sub.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              sub,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                            ),
                          ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Wrap(
                            spacing: 0,
                            children: [
                              if (p.isActive && !p.isDefault)
                                TextButton(
                                  onPressed: () async {
                                    try {
                                      await ref
                                          .read(paymentInstrumentRepositoryProvider)
                                          .update(p.copyWith(isDefault: true));
                                    } on Object catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('$e')),
                                        );
                                      }
                                    }
                                  },
                                  child: Text(l10n.settingsPaymentInstrumentSetDefault),
                                ),
                              IconButton(
                                tooltip: l10n.settingsPaymentInstrumentEditTitle,
                                icon: Icon(AppIcons.edit),
                                onPressed: () async {
                                  await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) =>
                                        PaymentInstrumentFormDialog(initial: p),
                                  );
                                },
                              ),
                              IconButton(
                                tooltip: l10n.deleteExpenseAction,
                                icon: Icon(AppIcons.delete),
                                onPressed: () async {
                                  final ok = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text(
                                        l10n.settingsPaymentInstrumentDeleteTitle,
                                      ),
                                      content: Text(
                                        l10n.settingsPaymentInstrumentDeleteMessage,
                                      ),
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
                                  if (ok == true && context.mounted) {
                                    try {
                                      await ref
                                          .read(paymentInstrumentRepositoryProvider)
                                          .deleteById(p.id);
                                    } on Object catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('$e')),
                                        );
                                      }
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const SizedBox(height: 24),
          error: (e, _) => Text('$e'),
        ),
      ],
    );
  }
}
