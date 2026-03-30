import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/router/app_router.dart';
import 'package:expense_app/presentation/theme/app_icons.dart';

void _onShellBranchSelected(
  StatefulNavigationShell navigationShell,
  int index,
) {
  if (index != navigationShell.currentIndex) {
    popShellBranchOverlayRoutes();
  }
  navigationShell.goBranch(index);
}

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
              onDestinationSelected: (index) => _onShellBranchSelected(
                navigationShell,
                index,
              ),
              labelType: extendedRail
                  ? null
                  : NavigationRailLabelType.selected,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(AppIcons.navExpenses),
                  selectedIcon: Icon(AppIcons.navExpensesSelected),
                  label: Text(l10n.navHome),
                ),
                NavigationRailDestination(
                  icon: Icon(AppIcons.navIncome),
                  selectedIcon: Icon(AppIcons.navIncomeSelected),
                  label: Text(l10n.navIncome),
                ),
                NavigationRailDestination(
                  icon: Icon(AppIcons.navReports),
                  selectedIcon: Icon(AppIcons.navReportsSelected),
                  label: Text(l10n.navReports),
                ),
                NavigationRailDestination(
                  icon: Icon(AppIcons.navCategories),
                  selectedIcon: Icon(AppIcons.navCategoriesSelected),
                  label: Text(l10n.navCategories),
                ),
                NavigationRailDestination(
                  icon: Icon(AppIcons.navSettings),
                  selectedIcon: Icon(AppIcons.navSettingsSelected),
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
        onDestinationSelected: (index) => _onShellBranchSelected(
          navigationShell,
          index,
        ),
        destinations: [
          NavigationDestination(
            icon: Icon(AppIcons.navExpenses),
            selectedIcon: Icon(AppIcons.navExpensesSelected),
            label: l10n.navHome,
          ),
          NavigationDestination(
            icon: Icon(AppIcons.navIncome),
            selectedIcon: Icon(AppIcons.navIncomeSelected),
            label: l10n.navIncome,
          ),
          NavigationDestination(
            icon: Icon(AppIcons.navReports),
            selectedIcon: Icon(AppIcons.navReportsSelected),
            label: l10n.navReports,
          ),
          NavigationDestination(
            icon: Icon(AppIcons.navCategories),
            selectedIcon: Icon(AppIcons.navCategoriesSelected),
            label: l10n.navCategories,
          ),
          NavigationDestination(
            icon: Icon(AppIcons.navSettings),
            selectedIcon: Icon(AppIcons.navSettingsSelected),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}
