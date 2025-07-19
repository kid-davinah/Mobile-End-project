import 'package:flutter_test/flutter_test.dart';
import 'package:student_budget_tracker/features/expense_tracking/data/expense_service.dart';
import 'package:student_budget_tracker/features/expense_tracking/domain/expense.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ExpenseService', () {
    final service = ExpenseService();
    final testExpense = Expense(
      id: 'test-id-1',
      title: 'Lunch',
      amount: 10.0,
      categoryId: 'Food',
      note: 'Lunch',
      date: DateTime(2024, 6, 1),
      category: 'Food',
    );
    String? insertedId;

    test('add and fetch expenses', () async {
      await service.addExpense(testExpense);
      final expenses = await service.getExpenses();
      expect(expenses.any((e) => e.amount == 100.0 && e.categoryId == 'test-category'), isTrue);
      insertedId = expenses.firstWhere((e) => e.amount == 100.0 && e.categoryId == 'test-category', orElse: () => testExpense).toMap()['id'];
    });

    test('delete expense', () async {
      final expenses = await service.getExpenses();
      if (expenses.isNotEmpty) {
        final id = expenses.first.toMap()['id'];
        await service.deleteExpense(id);
        final afterDelete = await service.getExpenses();
        expect(afterDelete.any((e) => e.toMap()['id'] == id), isFalse);
      }
    });

    test('filter by keyword in note', () async {
      await service.addExpense(Expense(id: 'test-id-2', title: 'Bus ticket', amount: 20.0, categoryId: 'Transport', note: 'Bus ticket', date: DateTime(2024, 6, 1), category: 'Transport'));
      final filtered = await service.filterExpenses(keyword: 'Bus');
      expect(filtered.any((e) => e.note.contains('Bus')), isTrue);
    });

    test('filter by category', () async {
      await service.addExpense(Expense(id: 'test-id-3', title: 'Supermarket', amount: 30.0, categoryId: 'Groceries', note: 'Supermarket', date: DateTime(2024, 6, 2), category: 'Groceries'));
      final filtered = await service.filterExpenses(category: 'Groceries');
      expect(filtered.every((e) => e.category == 'Groceries'), isTrue);
    });

    test('filter by date range', () async {
      await service.addExpense(Expense(id: 'test-id-4', title: 'Electricity', amount: 40.0, categoryId: 'Bills', note: 'Electricity', date: DateTime(2024, 6, 3), category: 'Bills'));
      final filtered = await service.filterExpenses(startDate: DateTime(2024, 6, 2), endDate: DateTime(2024, 6, 4));
      expect(filtered.every((e) => e.date.isAfter(DateTime(2024, 6, 1)) && e.date.isBefore(DateTime(2024, 6, 5))), isTrue);
    });

    test('filter by amount range', () async {
      await service.addExpense(Expense(id: 'test-id-5', title: 'Movie', amount: 50.0, categoryId: 'Leisure', note: 'Movie', date: DateTime(2024, 6, 4), category: 'Leisure'));
      final filtered = await service.filterExpenses(minAmount: 40.0, maxAmount: 50.0);
      expect(filtered.every((e) => e.amount >= 40.0 && e.amount <= 50.0), isTrue);
    });
  });
} 