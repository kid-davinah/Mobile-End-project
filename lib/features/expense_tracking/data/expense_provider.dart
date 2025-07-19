import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_budget_tracker/features/expense_tracking/data/expense_service.dart';
import 'package:student_budget_tracker/features/expense_tracking/domain/expense.dart';

final expenseServiceProvider = Provider<ExpenseService>((ref) => ExpenseService());

final expensesProvider = FutureProvider<List<Expense>>((ref) async {
  final service = ref.watch(expenseServiceProvider);
  return service.getExpenses();
}); 