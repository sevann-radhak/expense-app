import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/router/app_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final useRail = width >= kNavigationRailBreakpointWidth;

    if (useRail) {
      final extendedRail = width >= 1100;
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              extended: extendedRail,
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: navigationShell.goBranch,
              labelType: extendedRail
                  ? null
                  : NavigationRailLabelType.selected,
              destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home),
                  label: Text(l10n.navHome),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.bar_chart_outlined),
                  selectedIcon: const Icon(Icons.bar_chart),
                  label: Text(l10n.navReports),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.category_outlined),
                  selectedIcon: const Icon(Icons.category),
                  label: Text(l10n.navCategories),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.settings_outlined),
                  selectedIcon: const Icon(Icons.settings),
                  label: Text(l10n.navSettings),
                ),
              ],
            ),
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart),
            label: l10n.navReports,
          ),
          NavigationDestination(
            icon: const Icon(Icons.category_outlined),
            selectedIcon: const Icon(Icons.category),
            label: l10n.navCategories,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}
