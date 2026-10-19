import 'package:signals_flutter/signals_flutter.dart';
import 'package:piramidgame/src/core/constants/app_constants.dart';
import '../../data/services/storage_service.dart';

class ThemeViewModel {
  final IStorageService storage;
  late final Signal<bool> isDarkMode = signal(false);

  ThemeViewModel({required this.storage});

  Future<void> initialize() async {
    isDarkMode.value = await storage.getString(AppConstants.themeKey) == 'dark';
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    storage.saveString(AppConstants.themeKey, isDarkMode.value ? 'dark' : 'light');
  }

  void setDarkMode(bool value) {
    isDarkMode.value = value;
    storage.saveString(AppConstants.themeKey, value ? 'dark' : 'light');
  }
}
