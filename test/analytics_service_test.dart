import 'package:flutter_test/flutter_test.dart';
import 'package:student_budget_tracker/features/analytics_dashboard/data/analytics_service.dart';
import 'package:student_budget_tracker/features/expense_tracking/data/expense_service.dart';
import 'package:student_budget_tracker/features/expense_tracking/domain/expense.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final analytics = AnalyticsService();
  final expenseService = ExpenseService();

  setUp(() async {
    // Add some expenses for June 2024
    await expenseService.addExpense(Expense(id: 'analytics-id-1', title: 'Groceries', amount: 100.0, categoryId: 'Food', note: 'Groceries', date: DateTime(2024, 6, 1), category: 'Food'));
    await expenseService.addExpense(Expense(id: 'analytics-id-2', title: 'Bus', amount: 50.0, categoryId: 'Transport', note: 'Bus', date: DateTime(2024, 6, 2), category: 'Transport'));
    await expenseService.addExpense(Expense(id: 'analytics-id-3', title: 'Snacks', amount: 30.0, categoryId: 'Food', note: 'Snacks', date: DateTime(2024, 6, 3), category: 'Food'));
    await expenseService.addExpense(Expense(id: 'analytics-id-4', title: 'Movie', amount: 20.0, categoryId: 'Leisure', note: 'Movie', date: DateTime(2024, 6, 4), category: 'Leisure'));
  });

  test('total spent for month', () async {
    final total = await analytics.getTotalSpentForMonth(6, 2024);
    expect(total, 200.0);
  });

  test('top categories for month', () async {
    final top = await analytics.getTopCategoriesForMonth(6, 2024);
    expect(top.first['category'], 'Food');
    expect(top.first['total'], 130.0);
  });

  test('pie chart data for month', () async {
    final pie = await analytics.getPieChartData(6, 2024);
    expect(pie['Food'], 130.0);
    expect(pie['Transport'], 50.0);
    expect(pie['Leisure'], 20.0);
  });
} 