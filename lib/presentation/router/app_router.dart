import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:expense_app/presentation/categories/categories_screen.dart';
import 'package:expense_app/presentation/expenses/expenses_screen.dart';
import 'package:expense_app/presentation/income/income_screen.dart';
import 'package:expense_app/presentation/reports/reports_screen.dart';
import 'package:expense_app/presentation/settings/settings_screen.dart';
import 'package:expense_app/presentation/shell/app_shell.dart';

/// Narrow layouts use a bottom [NavigationBar]; wider layouts use [NavigationRail].
const double kNavigationRailBreakpointWidth = 720;

final List<GlobalKey<NavigatorState>> kShellBranchNavigatorKeys = [
  GlobalKey<NavigatorState>(debugLabel: 'shellBranchExpenses'),
  GlobalKey<NavigatorState>(debugLabel: 'shellBranchIncome'),
  GlobalKey<NavigatorState>(debugLabel: 'shellBranchReports'),
  GlobalKey<NavigatorState>(debugLabel: 'shellBranchCategories'),
  GlobalKey<NavigatorState>(debugLabel: 'shellBranchSettings'),
];

void popShellBranchOverlayRoutes() {
  for (final key in kShellBranchNavigatorKeys) {
    final nav = key.currentState;
    if (nav != null && nav.canPop()) {
      nav.popUntil((route) => route.isFirst);
    }
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/expenses',
  routes: [
    GoRoute(
      path: '/home',
      redirect: (context, state) => '/expenses',
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: kShellBranchNavigatorKeys[0],
          routes: [
            GoRoute(
              path: '/expenses',
              pageBuilder: (context, state) =>
                  const NoTransitionPage<void>(child: ExpensesScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: kShellBranchNavigatorKeys[1],
          routes: [
            GoRoute(
              path: '/income',
              pageBuilder: (context, state) =>
                  const NoTransitionPage<void>(child: IncomeScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: kShellBranchNavigatorKeys[2],
          routes: [
            GoRoute(
              path: '/reports',
              pageBuilder: (context, state) =>
                  const NoTransitionPage<void>(child: ReportsScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: kShellBranchNavigatorKeys[3],
          routes: [
            GoRoute(
              path: '/categories',
              pageBuilder: (context, state) =>
                  const NoTransitionPage<void>(child: CategoriesScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: kShellBranchNavigatorKeys[4],
          routes: [
            GoRoute(
              path: '/settings',
              pageBuilder: (context, state) =>
                  const NoTransitionPage<void>(child: SettingsScreen()),
            ),
          ],
        ),
      ],
    ),
  ],
);
