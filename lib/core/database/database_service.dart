import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseService {
  static Database? _database;
  static final DatabaseService instance = DatabaseService._init();

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, filePath);
    return await openDatabase(
      path,
      version: 5, // Bump version for migration
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        color TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE expenses (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        categoryId TEXT,
        FOREIGN KEY (categoryId) REFERENCES categories(id)
      )
    ''');
    await db.execute('''
      CREATE TABLE budgets (
        id TEXT PRIMARY KEY,
        amount REAL NOT NULL,
        month INTEGER NOT NULL,
        year INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE recurring_expenses (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        note TEXT,
        start_date TEXT NOT NULL,
        frequency TEXT NOT NULL, -- daily, weekly, monthly
        next_due_date TEXT NOT NULL,
        last_applied_date TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS settings (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Migration for budgets table
      await db.execute('''
        CREATE TABLE budgets (
          id TEXT PRIMARY KEY,
          amount REAL NOT NULL,
          month INTEGER NOT NULL,
          year INTEGER NOT NULL
        )
      ''');
    }
    if (oldVersion < 3) {
      // Migration for recurring_expenses table
      await db.execute('''
        CREATE TABLE recurring_expenses (
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          amount REAL NOT NULL,
          category TEXT NOT NULL,
          note TEXT,
          start_date TEXT NOT NULL,
          frequency TEXT NOT NULL,
          next_due_date TEXT NOT NULL,
          last_applied_date TEXT
        )
      ''');
    }
    if (oldVersion < 4) {
      // Migration for settings table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS settings (
          key TEXT PRIMARY KEY,
          value TEXT
        )
      ''');
    }
    if (oldVersion < 5) {
      // Migration for note column in expenses table
      await db.execute('ALTER TABLE expenses ADD COLUMN note TEXT');
    }
    // Add future migrations here
  }

  // CRUD for categories
  Future<int> insertCategory(Map<String, dynamic> category) async {
    final db = await database;
    return await db.insert('categories', category);
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;
    return await db.query('categories');
  }

  Future<int> updateCategory(Map<String, dynamic> category) async {
    final db = await database;
    return await db.update(
      'categories',
      category,
      where: 'id = ?',
      whereArgs: [category['id']],
    );
  }

  Future<int> deleteCategory(String id) async {
    final db = await database;
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD for expenses
  Future<int> insertExpense(Map<String, dynamic> expense) async {
    final db = await database;
    return await db.insert('expenses', expense);
  }

  Future<List<Map<String, dynamic>>> getExpenses() async {
    final db = await database;
    return await db.query('expenses');
  }

  Future<int> updateExpense(Map<String, dynamic> expense) async {
    final db = await database;
    return await db.update(
      'expenses',
      expense,
      where: 'id = ?',
      whereArgs: [expense['id']],
    );
  }

  Future<int> deleteExpense(String id) async {
    final db = await database;
    return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD for budgets
  Future<int> insertBudget(Map<String, dynamic> budget) async {
    final db = await database;
    return await db.insert('budgets', budget);
  }

  Future<List<Map<String, dynamic>>> getBudgets() async {
    final db = await database;
    return await db.query('budgets');
  }

  Future<int> updateBudget(Map<String, dynamic> budget) async {
    final db = await database;
    return await db.update(
      'budgets',
      budget,
      where: 'id = ?',
      whereArgs: [budget['id']],
    );
  }

  Future<int> deleteBudget(String id) async {
    final db = await database;
    return await db.delete('budgets', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD for recurring expenses
  Future<int> insertRecurringExpense(Map<String, dynamic> rec) async {
    final db = await database;
    return await db.insert('recurring_expenses', rec);
  }
  Future<List<Map<String, dynamic>>> getRecurringExpenses() async {
    final db = await database;
    return await db.query('recurring_expenses');
  }
  Future<int> updateRecurringExpense(Map<String, dynamic> rec) async {
    final db = await database;
    return await db.update('recurring_expenses', rec, where: 'id = ?', whereArgs: [rec['id']]);
  }
  Future<int> deleteRecurringExpense(String id) async {
    final db = await database;
    return await db.delete('recurring_expenses', where: 'id = ?', whereArgs: [id]);
  }

  // Filtered expense queries
  Future<List<Map<String, dynamic>>> filterExpenses({
    String? keyword,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
    double? minAmount,
    double? maxAmount,
  }) async {
    final db = await database;
    final where = <String>[];
    final whereArgs = <dynamic>[];
    if (keyword != null && keyword.isNotEmpty) {
      where.add('note LIKE ?');
      whereArgs.add('%$keyword%');
    }
    if (category != null && category.isNotEmpty) {
      where.add('category = ?');
      whereArgs.add(category);
    }
    if (startDate != null) {
      where.add('date >= ?');
      whereArgs.add(startDate.toIso8601String());
    }
    if (endDate != null) {
      where.add('date <= ?');
      whereArgs.add(endDate.toIso8601String());
    }
    if (minAmount != null) {
      where.add('amount >= ?');
      whereArgs.add(minAmount);
    }
    if (maxAmount != null) {
      where.add('amount <= ?');
      whereArgs.add(maxAmount);
    }
    return await db.query(
      'expenses',
      where: where.isNotEmpty ? where.join(' AND ') : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
    );
  }

  // Analytics queries
  Future<double> getTotalSpentForMonth(int month, int year) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM expenses WHERE strftime("%m", date) = ? AND strftime("%Y", date) = ?',
      [month.toString().padLeft(2, '0'), year.toString()]
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<List<Map<String, dynamic>>> getTopCategoriesForMonth(int month, int year, {int limit = 3}) async {
    final db = await database;
    return await db.rawQuery(
      'SELECT categories.name as category, SUM(expenses.amount) as total '
      'FROM expenses '
      'LEFT JOIN categories ON expenses.categoryId = categories.id '
      'WHERE strftime("%m", expenses.date) = ? AND strftime("%Y", expenses.date) = ? '
      'GROUP BY categories.name '
      'ORDER BY total DESC LIMIT ?',
      [month.toString().padLeft(2, '0'), year.toString(), limit]
    );
  }

  Future<List<Map<String, dynamic>>> getExpenseDistributionForMonth(int month, int year) async {
    final db = await database;
    return await db.rawQuery(
      'SELECT categories.name as category, SUM(expenses.amount) as total '
      'FROM expenses '
      'LEFT JOIN categories ON expenses.categoryId = categories.id '
      'WHERE strftime("%m", expenses.date) = ? AND strftime("%Y", expenses.date) = ? '
      'GROUP BY categories.name',
      [month.toString().padLeft(2, '0'), year.toString()]
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
} 