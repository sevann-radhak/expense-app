import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_app/data/local/default_fx_rates_loader.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/providers/providers.dart';
import 'package:expense_app/presentation/settings/settings_card_profiles_section.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _languageSystemValue = '';
  static const _languageEnglishValue = 'en';
  static const _currencyCatalogDefaultValue = '';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(appUserSettingsProvider);
    final settingsNotifier = ref.read(appUserSettingsProvider.notifier);
    final asyncCatalog = ref.watch(defaultFxCatalogProvider);

    final languageValue = settings.localeLanguageCode == null
        ? _languageSystemValue
        : _languageEnglishValue;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.settingsPreferencesSectionTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  key: ValueKey<String>('settings_lang_${settings.localeLanguageCode}'),
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: l10n.settingsLanguageLabel,
                    border: const OutlineInputBorder(),
                  ),
                  initialValue: languageValue,
                  items: [
                    DropdownMenuItem(
                      value: _languageSystemValue,
                      child: Text(l10n.settingsLanguageSystem),
                    ),
                    DropdownMenuItem(
                      value: _languageEnglishValue,
                      child: Text(l10n.settingsLanguageEnglish),
                    ),
                  ],
                  onChanged: (v) {
                    if (v == null) {
                      return;
                    }
                    final code = v.isEmpty ? null : v;
                    settingsNotifier.setLocaleLanguageCode(code);
                  },
                ),
                const SizedBox(height: 16),
                asyncCatalog.when(
                  loading: () => const SizedBox(height: 56),
                  error: (e, _) => Text('$e'),
                  data: (DefaultFxCatalog catalog) {
                    final currencyValue = _currencyDropdownValue(
                      settings.defaultCurrencyCode,
                      catalog,
                    );
                    return DropdownButtonFormField<String>(
                      key: ValueKey<String>('settings_ccy_$currencyValue'),
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: l10n.settingsDefaultCurrencyLabel,
                        border: const OutlineInputBorder(),
                      ),
                      initialValue: currencyValue,
                      items: [
                        DropdownMenuItem(
                          value: _currencyCatalogDefaultValue,
                          child: Text(
                            l10n.settingsDefaultCurrencyCatalogDefault(
                              catalog.defaultCurrencyCode.toUpperCase(),
                            ),
                          ),
                        ),
                        ...catalog.currencies.map(
                          (c) => DropdownMenuItem(
                            value: c.code,
                            child: Text(c.menuLabel),
                          ),
                        ),
                      ],
                      onChanged: (v) {
                        if (v == null) {
                          return;
                        }
                        final code = v.isEmpty ? null : v;
                        settingsNotifier.setDefaultCurrencyCode(code);
                      },
                    );
                  },
                ),
                const SizedBox(height: 32),
                const SettingsCardProfilesSection(),
                const SizedBox(height: 32),
                Text(
                  l10n.settingsAccountSectionTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.settingsAccountPlaceholder,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 32),
                Text(
                  l10n.settingsResetDataButton,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(l10n.settingsResetDataTitle),
                        content: Text(l10n.settingsResetDataMessage),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text(l10n.cancel),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: Text(l10n.settingsResetDataConfirm),
                          ),
                        ],
                      ),
                    );
                    if (ok == true && context.mounted) {
                      await resetLocalAppDatabase(ref);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.settingsResetDataSuccess)),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.delete_forever_outlined),
                  label: Text(l10n.settingsResetDataButton),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.settingsPopulateExampleDataSectionTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.settingsPopulateExampleDataDescription,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(l10n.settingsPopulateExampleDataTitle),
                        content: Text(l10n.settingsPopulateExampleDataMessage),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text(l10n.cancel),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: Text(l10n.settingsPopulateExampleDataConfirm),
                          ),
                        ],
                      ),
                    );
                    if (ok == true && context.mounted) {
                      try {
                        await populateExampleDemoData(ref);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.settingsPopulateExampleDataSuccess),
                            ),
                          );
                        }
                      } on Object catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('$e')),
                          );
                        }
                      }
                    }
                  },
                  icon: const Icon(Icons.playlist_add_outlined),
                  label: Text(l10n.settingsPopulateExampleDataButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _currencyDropdownValue(
  String? stored,
  DefaultFxCatalog catalog,
) {
  if (stored == null || stored.isEmpty) {
    return SettingsScreen._currencyCatalogDefaultValue;
  }
  if (catalog.optionForCode(stored) == null) {
    return SettingsScreen._currencyCatalogDefaultValue;
  }
  return stored.toUpperCase();
}
