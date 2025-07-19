import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_budget_tracker/features/settings_and_backup/data/settings_service.dart';

final settingsServiceProvider = Provider<SettingsService>((ref) => SettingsService());

final defaultCurrencyProvider = StateProvider<String>((ref) => 'USD');
final themeModeProvider = StateProvider<String>((ref) => 'system');
final firstTimeUserProvider = StateProvider<bool>((ref) => true);

final settingsInitializerProvider = FutureProvider<void>((ref) async {
  final service = ref.watch(settingsServiceProvider);
  await service.initializeDefaults();
  final currency = await service.getDefaultCurrency();
  final theme = await service.getThemeMode();
  final firstTime = await service.isFirstTimeUser();
  ref.read(defaultCurrencyProvider.notifier).state = currency ?? 'USD';
  ref.read(themeModeProvider.notifier).state = theme ?? 'system';
  ref.read(firstTimeUserProvider.notifier).state = firstTime;
}); 