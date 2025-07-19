import 'package:student_budget_tracker/core/database/database_service.dart';
import 'package:student_budget_tracker/features/expense_tracking/domain/expense.dart';
import 'package:uuid/uuid.dart';

class ExpenseService {
  final DatabaseService _dbService = DatabaseService.instance;
  final Uuid _uuid = Uuid();

  Future<void> addExpense(Expense expense) async {
    final expenseMap = expense.toMap();
    expenseMap['id'] = _uuid.v4();
    await _dbService.insertExpense(expenseMap);
  }

  Future<List<Expense>> getExpenses() async {
    final expenseMaps = await _dbService.getExpenses();
    return expenseMaps.map((map) => Expense.fromMap(map)).toList();
  }

  Future<void> deleteExpense(String id) async {
    await _dbService.deleteExpense(id);
  }

  Future<void> updateExpense(String id, Expense expense) async {
    final expenseMap = expense.toMap();
    expenseMap['id'] = id;
    await _dbService.updateExpense(expenseMap);
  }

  Future<List<Expense>> filterExpenses({
    String? keyword,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
    double? minAmount,
    double? maxAmount,
  }) async {
    final expenseMaps = await _dbService.filterExpenses(
      keyword: keyword,
      category: category,
      startDate: startDate,
      endDate: endDate,
      minAmount: minAmount,
      maxAmount: maxAmount,
    );
    return expenseMaps.map((map) => Expense.fromMap(map)).toList();
  }
} 