import 'package:go_router/go_router.dart';

import 'package:expense_app/presentation/categories/categories_screen.dart';
import 'package:expense_app/presentation/expenses/expenses_screen.dart';
import 'package:expense_app/presentation/income/income_screen.dart';
import 'package:expense_app/presentation/reports/reports_screen.dart';
import 'package:expense_app/presentation/settings/settings_screen.dart';
import 'package:expense_app/presentation/shell/app_shell.dart';

/// Narrow layouts use a bottom [NavigationBar]; wider layouts use [NavigationRail].
const double kNavigationRailBreakpointWidth = 720;

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
          routes: [
            GoRoute(
              path: '/expenses',
              pageBuilder: (context, state) =>
                  const NoTransitionPage<void>(child: ExpensesScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/income',
              pageBuilder: (context, state) =>
                  const NoTransitionPage<void>(child: IncomeScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/reports',
              pageBuilder: (context, state) =>
                  const NoTransitionPage<void>(child: ReportsScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/categories',
              pageBuilder: (context, state) =>
                  const NoTransitionPage<void>(child: CategoriesScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
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
