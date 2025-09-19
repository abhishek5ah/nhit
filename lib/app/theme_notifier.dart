import 'package:flutter/material.dart';

// Global ValueNotifier to hold the current theme mode
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.dark);

// Function to toggle theme mode between light and dark
void toggleTheme() {
  themeModeNotifier.value = themeModeNotifier.value == ThemeMode.dark
      ? ThemeMode.light
      : ThemeMode.dark;
}
