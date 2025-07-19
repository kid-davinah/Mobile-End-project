import 'package:student_budget_tracker/core/database/database_service.dart';
import 'package:student_budget_tracker/features/budget_planning/domain/budget.dart';
import 'package:student_budget_tracker/features/expense_tracking/domain/expense.dart';
import 'package:uuid/uuid.dart';

class BudgetService {
  final DatabaseService _dbService = DatabaseService.instance;
  final Uuid _uuid = Uuid();

  Future<void> addBudget(Budget budget) async {
    final budgetMap = budget.toMap();
    budgetMap['id'] = _uuid.v4();
    await _dbService.insertBudget(budgetMap);
  }

  Future<List<Budget>> getBudgets() async {
    final budgetMaps = await _dbService.getBudgets();
    return budgetMaps.map((map) => Budget.fromMap(map)).toList();
  }

  Future<void> deleteBudget(String id) async {
    await _dbService.deleteBudget(id);
  }

  Future<void> updateBudget(String id, Budget budget) async {
    final budgetMap = budget.toMap();
    budgetMap['id'] = id;
    await _dbService.updateBudget(budgetMap);
  }

  // Calculate used and remaining budget for a given month/year/category
  Future<Map<String, Map<String, double>>> calculateBudgetUsage({required int month, required int year, required List<Expense> expenses}) async {
    final budgets = await getBudgets();
    final Map<String, double> used = {};
    final Map<String, double> remaining = {};
    final filteredBudgets = budgets.where((b) => b.month == month && b.year == year);
    for (final budget in filteredBudgets) {
      final category = budget.toMap()['category'] ?? '';
      final usedAmount = expenses
        .where((e) => e.category == category && e.date.month == month && e.date.year == year)
        .fold(0.0, (sum, e) => sum + e.amount);
      used[category] = usedAmount;
      remaining[category] = budget.amount - usedAmount;
    }
    return {'used': used, 'remaining': remaining};
  }

  // Monthly reset: clear or initialize budgets for a new month
  Future<void> resetBudgetsForNewMonth(int month, int year) async {
    // Optionally, copy previous month's budgets or clear all
    final prevBudgets = await getBudgets();
    final newBudgets = prevBudgets.where((b) => b.month == (month == 1 ? 12 : month - 1) && b.year == (month == 1 ? year - 1 : year)).toList();
    for (final budget in newBudgets) {
      await addBudget(Budget(amount: budget.amount, month: month, year: year));
    }
  }
} 