import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/providers/providers.dart';
import 'package:expense_app/presentation/router/app_router.dart';

/// Enables mouse / trackpad dragging on scrollables (Flutter web & desktop
/// default only scrolls with touch).
final class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.stylus,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

class ExpenseApp extends ConsumerWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSettings = ref.watch(appUserSettingsProvider);
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      scrollBehavior: const _AppScrollBehavior(),
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: userSettings.localeLanguageCode == null
          ? null
          : Locale(userSettings.localeLanguageCode!),
      localeResolutionCallback: (deviceLocale, supported) {
        if (userSettings.localeLanguageCode != null) {
          for (final l in supported) {
            if (l.languageCode == userSettings.localeLanguageCode) {
              return l;
            }
          }
          return supported.first;
        }
        for (final l in supported) {
          if (l.languageCode == deviceLocale?.languageCode) {
            return l;
          }
        }
        return supported.first;
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
