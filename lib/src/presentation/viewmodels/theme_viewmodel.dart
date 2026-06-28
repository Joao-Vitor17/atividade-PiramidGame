import 'package:signals_flutter/signals_flutter.dart';

class ThemeViewModel {
  late final Signal<bool> isDarkMode = signal(false);

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }

  void setDarkMode(bool value) {
    isDarkMode.value = value;
  }
}
