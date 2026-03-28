import 'package:go_router/go_router.dart';

import 'package:expense_app/presentation/categories/categories_screen.dart';
import 'package:expense_app/presentation/home/home_screen.dart';
import 'package:expense_app/presentation/settings/settings_screen.dart';
import 'package:expense_app/presentation/shell/app_shell.dart';

/// Narrow layouts use a bottom [NavigationBar]; wider layouts use [NavigationRail].
const double kNavigationRailBreakpointWidth = 720;

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) =>
                  const NoTransitionPage<void>(child: HomeScreen()),
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
