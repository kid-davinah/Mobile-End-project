import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_budget_tracker/features/expense_tracking/data/recurring_expense_service.dart';
import 'package:student_budget_tracker/features/expense_tracking/domain/recurring_expense.dart';
import 'package:student_budget_tracker/features/expense_tracking/domain/expense.dart';

final recurringExpenseServiceProvider = Provider<RecurringExpenseService>((ref) => RecurringExpenseService());

final recurringExpensesProvider = FutureProvider<List<RecurringExpense>>((ref) async {
  final service = ref.watch(recurringExpenseServiceProvider);
  return service.getRecurringExpenses();
});

final autoApplyRecurringExpensesProvider = FutureProvider<List<Expense>>((ref) async {
  final service = ref.watch(recurringExpenseServiceProvider);
  return service.autoApplyRecurringExpenses();
}); 