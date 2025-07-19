import 'package:student_budget_tracker/core/database/database_service.dart';

class AnalyticsService {
  final DatabaseService _dbService = DatabaseService.instance;

  Future<double> getTotalSpentForMonth(int month, int year) async {
    return await _dbService.getTotalSpentForMonth(month, year);
  }

  Future<List<Map<String, dynamic>>> getTopCategoriesForMonth(int month, int year, {int limit = 3}) async {
    return await _dbService.getTopCategoriesForMonth(month, year, limit: limit);
  }

  Future<List<Map<String, dynamic>>> getExpenseDistributionForMonth(int month, int year) async {
    return await _dbService.getExpenseDistributionForMonth(month, year);
  }

  // Data prep for pie/bar charts
  Future<Map<String, double>> getPieChartData(int month, int year) async {
    final data = await getExpenseDistributionForMonth(month, year);
    return {for (var row in data) row['category'] as String: (row['total'] as num).toDouble()};
  }

  Future<List<Map<String, dynamic>>> getBarChartData(int month, int year) async {
    return await getExpenseDistributionForMonth(month, year);
  }
} 