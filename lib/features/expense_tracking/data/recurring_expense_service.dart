import 'package:student_budget_tracker/core/database/database_service.dart';
import 'package:student_budget_tracker/features/expense_tracking/domain/recurring_expense.dart';
import 'package:student_budget_tracker/features/expense_tracking/domain/expense.dart';
import 'package:uuid/uuid.dart';

class RecurringExpenseService {
  final DatabaseService _dbService = DatabaseService.instance;
  final Uuid _uuid = Uuid();

  Future<void> addRecurringExpense(RecurringExpense rec) async {
    await _dbService.insertRecurringExpense(rec.toMap());
  }

  Future<List<RecurringExpense>> getRecurringExpenses() async {
    final recs = await _dbService.getRecurringExpenses();
    return recs.map((map) => RecurringExpense.fromMap(map)).toList();
  }

  Future<void> updateRecurringExpense(RecurringExpense rec) async {
    await _dbService.updateRecurringExpense(rec.toMap());
  }

  Future<void> deleteRecurringExpense(String id) async {
    await _dbService.deleteRecurringExpense(id);
  }

  // Auto-apply logic: check and insert due recurring expenses
  Future<List<Expense>> autoApplyRecurringExpenses() async {
    final now = DateTime.now();
    final recs = await getRecurringExpenses();
    final List<Expense> applied = [];
    for (final rec in recs) {
      if (rec.nextDueDate.isBefore(now) || rec.nextDueDate.isAtSameMomentAs(now)) {
        // Insert expense
        final expense = Expense(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: rec.note.isNotEmpty ? rec.note : rec.category,
          amount: rec.amount,
          categoryId: rec.categoryId,
          note: rec.note,
          date: DateTime.now(),
          category: rec.categoryId,
        );
        await _dbService.insertExpense({
          'id': _uuid.v4(),
          'title': rec.title,
          'amount': rec.amount,
          'categoryId': rec.category, // Use rec.category as categoryId for now
          'note': rec.note,
          'date': rec.nextDueDate.toIso8601String(),
        });
        applied.add(expense);
        // Update nextDueDate and lastAppliedDate
        DateTime nextDue;
        switch (rec.frequency) {
          case 'daily':
            nextDue = rec.nextDueDate.add(Duration(days: 1));
            break;
          case 'weekly':
            nextDue = rec.nextDueDate.add(Duration(days: 7));
            break;
          case 'monthly':
            nextDue = DateTime(rec.nextDueDate.year, rec.nextDueDate.month + 1, rec.nextDueDate.day);
            break;
          default:
            nextDue = rec.nextDueDate;
        }
        final updatedRec = RecurringExpense(
          id: rec.id,
          title: rec.title,
          amount: rec.amount,
          categoryId: rec.category,
          category: rec.category,
          note: rec.note,
          startDate: rec.startDate,
          frequency: rec.frequency,
          nextDueDate: nextDue,
          lastAppliedDate: DateTime.now(),
        );
        await updateRecurringExpense(updatedRec);
      }
    }
    return applied;
  }
} 