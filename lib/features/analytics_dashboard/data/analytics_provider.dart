import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_budget_tracker/features/analytics_dashboard/data/analytics_service.dart';

final analyticsServiceProvider = Provider<AnalyticsService>((ref) => AnalyticsService());

class TotalSpentAsyncNotifier extends AsyncNotifier<double> {
  @override
  Future<double> build() async {
    // Example: cache for current month/year
    final now = DateTime.now();
    final analytics = ref.read(analyticsServiceProvider);
    return analytics.getTotalSpentForMonth(now.month, now.year);
  }
}

final totalSpentProvider = AsyncNotifierProvider<TotalSpentAsyncNotifier, double>(TotalSpentAsyncNotifier.new);

class TopCategoriesAsyncNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
  @override
  Future<List<Map<String, dynamic>>> build() async {
    final now = DateTime.now();
    final analytics = ref.read(analyticsServiceProvider);
    return analytics.getTopCategoriesForMonth(now.month, now.year);
  }
}

final topCategoriesProvider = AsyncNotifierProvider<TopCategoriesAsyncNotifier, List<Map<String, dynamic>>>(TopCategoriesAsyncNotifier.new);

// Pie/bar chart providers can be similarly refactored if needed. 