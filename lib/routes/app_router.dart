import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async' show Future;

// Deferred imports for lazy loading
import 'dashboard_screen.dart' deferred as dashboard;
import 'package:student_budget_tracker/features/expense_tracking/presentation/expense_list_screen.dart' deferred as expenses;
import 'package:student_budget_tracker/features/budget_planning/presentation/budget_planner_screen.dart' deferred as budget;
import 'settings_screen.dart' deferred as settings;
import 'package:student_budget_tracker/features/category_management/presentation/category_management_screen.dart' deferred as categories;

Future<Widget> _loadScreen(Future<void> Function() loadLibrary, Widget Function() builder, String name) async {
  final stopwatch = Stopwatch()..start();
  await loadLibrary();
  stopwatch.stop();
  debugPrint('Loaded $name in \\${stopwatch.elapsedMilliseconds}ms');
  return builder();
}

final initialRouteProvider = Provider<String>((ref) {
  // Example: Use firstTimeUserProvider from settings if available
  // For now, always start at dashboard
  return '/dashboard';
});

final appRouterProvider = Provider<GoRouter>((ref) {
  final initialRoute = ref.watch(initialRouteProvider);
  return GoRouter(
    initialLocation: initialRoute,
    routes: [
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => FutureBuilder<Widget>(
          future: _loadScreen(dashboard.loadLibrary, () => dashboard.DashboardScreen(), 'DashboardScreen'),
          builder: (context, snapshot) => snapshot.data ?? const SizedBox.shrink(),
        ),
      ),
      GoRoute(
        path: '/expenses',
        builder: (context, state) => FutureBuilder<Widget>(
          future: _loadScreen(expenses.loadLibrary, () => expenses.ExpenseListScreen(), 'ExpenseListScreen'),
          builder: (context, snapshot) => snapshot.data ?? const SizedBox.shrink(),
        ),
      ),
      GoRoute(
        path: '/budget',
        builder: (context, state) => FutureBuilder<Widget>(
          future: _loadScreen(budget.loadLibrary, () => budget.BudgetPlannerScreen(), 'BudgetPlannerScreen'),
          builder: (context, snapshot) => snapshot.data ?? const SizedBox.shrink(),
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => FutureBuilder<Widget>(
          future: _loadScreen(settings.loadLibrary, () => settings.SettingsScreen(), 'SettingsScreen'),
          builder: (context, snapshot) => snapshot.data ?? const SizedBox.shrink(),
        ),
      ),
      GoRoute(
        path: '/categories',
        builder: (context, state) => FutureBuilder<Widget>(
          future: _loadScreen(categories.loadLibrary, () => categories.CategoryManagementScreen(), 'CategoryManagementScreen'),
          builder: (context, snapshot) => snapshot.data ?? const SizedBox.shrink(),
        ),
      ),
    ],
  );
}); 