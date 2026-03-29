import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/providers/providers.dart';
import 'package:expense_app/presentation/settings/payment_instrument_form_dialog.dart';

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
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
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
                color: Theme.of(context).colorScheme.onSurfaceVariant,
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
          icon: const Icon(Icons.add_card_outlined),
          label: Text(l10n.settingsPaymentInstrumentAdd),
        ),
        const SizedBox(height: 12),
        async.when(
          data: (list) {
            if (list.isEmpty) {
              return Text(
                l10n.settingsPaymentInstrumentNoneYet,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              );
            }
            return Column(
              children: list.map((p) {
                final sub = _subtitle(l10n, p);
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(p.label),
                    subtitle: sub.isEmpty ? null : Text(sub),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: l10n.settingsPaymentInstrumentEditTitle,
                          icon: const Icon(Icons.edit_outlined),
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
                          icon: const Icon(Icons.delete_outline),
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
