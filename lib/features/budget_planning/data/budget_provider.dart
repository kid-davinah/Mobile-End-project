import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_budget_tracker/features/budget_planning/data/budget_service.dart';
import 'package:student_budget_tracker/features/budget_planning/domain/budget.dart';
import 'package:student_budget_tracker/features/expense_tracking/domain/expense.dart';

final budgetServiceProvider = Provider<BudgetService>((ref) => BudgetService());

class BudgetListNotifier extends StateNotifier<AsyncValue<List<Budget>>> {
  final BudgetService _service;
  BudgetListNotifier(this._service) : super(const AsyncValue.loading()) {
    loadBudgets();
  }

  Future<void> loadBudgets() async {
    state = const AsyncValue.loading();
    try {
      final budgets = await _service.getBudgets();
      state = AsyncValue.data(budgets);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addBudget(Budget budget) async {
    await _service.addBudget(budget);
    await loadBudgets();
  }

  Future<void> deleteBudget(String id) async {
    await _service.deleteBudget(id);
    await loadBudgets();
  }

  Future<void> updateBudget(String id, Budget budget) async {
    await _service.updateBudget(id, budget);
    await loadBudgets();
  }

  Future<void> resetBudgetsForNewMonth(int month, int year) async {
    await _service.resetBudgetsForNewMonth(month, year);
    await loadBudgets();
  }
}

final budgetListProvider = StateNotifierProvider<BudgetListNotifier, AsyncValue<List<Budget>>>((ref) {
  final service = ref.watch(budgetServiceProvider);
  return BudgetListNotifier(service);
});

// Budget overview provider: calculates used/remaining per category
final budgetOverviewProvider = FutureProvider.family<Map<String, Map<String, double>>, Map<String, dynamic>>((ref, params) async {
  final budgetService = ref.watch(budgetServiceProvider);
  final expenses = params['expenses'] as List<Expense>;
  final month = params['month'] as int;
  final year = params['year'] as int;
  return await budgetService.calculateBudgetUsage(month: month, year: year, expenses: expenses);
}); 