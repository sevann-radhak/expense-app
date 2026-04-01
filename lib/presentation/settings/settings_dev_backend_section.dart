import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:expense_app/application/cloud_backend_env.dart';
import 'package:expense_app/data/remote/dev_backend_api_client.dart';
import 'package:expense_app/l10n/app_localizations.dart';

/// Debug-only controls for Phase 5.b dev book endpoints on **expense-app-backend**.
class SettingsDevBackendSection extends StatefulWidget {
  const SettingsDevBackendSection({super.key});

  @override
  State<SettingsDevBackendSection> createState() =>
      _SettingsDevBackendSectionState();
}

class _SettingsDevBackendSectionState extends State<SettingsDevBackendSection> {
  bool _busy = false;

  Future<void> _run(
    BuildContext context,
    AppLocalizations l10n,
    Future<void> Function(DevBackendApiClient client, String userId) action,
  ) async {
    if (!CloudBackendEnv.isRemoteApiConfigured) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsDevBackendNotConfigured)),
        );
      }
      return;
    }
    setState(() => _busy = true);
    final userId = CloudBackendEnv.devTestUserId;
    final client = DevBackendApiClient();
    try {
      await action(client, userId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsDevBackendOk)),
        );
      }
    } on Object catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    } finally {
      client.close();
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(kDebugMode);
    final l10n = AppLocalizations.of(context)!;
    final url = CloudBackendEnv.isRemoteApiConfigured
        ? CloudBackendEnv.apiBaseUrl
        : '(not set)';
    final userId = CloudBackendEnv.devTestUserId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.settingsDevBackendSectionTitle,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.settingsDevBackendDescription(url, userId),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton(
              onPressed: _busy
                  ? null
                  : () => _run(
                        context,
                        l10n,
                        (c, u) => c.resetBook(userId: u),
                      ),
              child: Text(l10n.settingsDevBackendResetBook),
            ),
            OutlinedButton(
              onPressed: _busy
                  ? null
                  : () => _run(
                        context,
                        l10n,
                        (c, u) => c.seedTaxonomy(userId: u),
                      ),
              child: Text(l10n.settingsDevBackendSeedTaxonomy),
            ),
            OutlinedButton(
              onPressed: _busy
                  ? null
                  : () => _run(
                        context,
                        l10n,
                        (c, u) => c.seedDemo(userId: u),
                      ),
              child: Text(l10n.settingsDevBackendSeedDemo),
            ),
          ],
        ),
      ],
    );
  }
}
