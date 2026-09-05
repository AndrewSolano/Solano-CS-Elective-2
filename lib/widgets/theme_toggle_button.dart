import 'package:flutter/material.dart';
import '../main.dart' show themeNotifier;

// StatelessWidget justification:
// The widget itself holds no state — it mutates the external themeNotifier
// (a ValueNotifier living in main.dart) and lets ValueListenableBuilder
// handle rebuilding just this icon whenever the mode changes.
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        return IconButton(
          tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          onPressed: () {
            themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
          },
        );
      },
    );
  }
}
