import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_budget_tracker/core/database/database_service.dart';

final categoriesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final dbService = DatabaseService.instance;
  return await dbService.getCategories();
}); 