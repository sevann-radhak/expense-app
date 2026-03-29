import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_app/application/application.dart';
import 'package:expense_app/data/local/book_backup_importer.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/providers/providers.dart';
import 'package:expense_app/presentation/settings/book_backup_pick.dart';

class SettingsBackupSection extends ConsumerWidget {
  const SettingsBackupSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.settingsBackupSectionTitle,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.settingsBackupImportDescription,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () async {
            final messenger = ScaffoldMessenger.maybeOf(context);
            if (!kIsWeb) {
              messenger?.showSnackBar(
                SnackBar(content: Text(l10n.settingsImportJsonWebOnly)),
              );
              return;
            }
            final text = await pickBookBackupJsonText();
            if (!context.mounted) {
              return;
            }
            if (text == null || text.trim().isEmpty) {
              return;
            }
            final ok = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(l10n.settingsBackupImportTitle),
                content: Text(l10n.settingsBackupImportMessage),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text(l10n.cancel),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text(l10n.settingsBackupImportConfirm),
                  ),
                ],
              ),
            );
            if (ok != true || !context.mounted) {
              return;
            }
            try {
              final snapshot = decodeBookBackup(text);
              final report = await importBookBackupReplacingAll(
                ref.read(appDatabaseProvider),
                snapshot,
              );
              if (context.mounted) {
                final msg = report.hadRepairs
                    ? l10n.settingsBackupImportRepaired(
                        report.expensesSkipped,
                        report.paymentInstrumentLinksCleared,
                        report.subcategoriesDropped,
                      )
                    : l10n.settingsBackupImportSuccess;
                messenger?.showSnackBar(SnackBar(content: Text(msg)));
              }
            } on Object catch (e) {
              if (context.mounted) {
                messenger?.showSnackBar(
                  SnackBar(
                    content: Text('${l10n.settingsBackupImportFailed}: $e'),
                  ),
                );
              }
            }
          },
          icon: const Icon(Icons.upload_file_outlined),
          label: Text(l10n.settingsBackupImportButton),
        ),
      ],
    );
  }
}
