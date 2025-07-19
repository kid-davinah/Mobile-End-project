import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_budget_tracker/features/settings_and_backup/data/security_service.dart';

final securityServiceProvider = Provider<SecurityService>((ref) => SecurityService());
final isLockedProvider = StateProvider<bool>((ref) => true);
final authFallbackProvider = StateProvider<bool>((ref) => false); // true if fallback to PIN 