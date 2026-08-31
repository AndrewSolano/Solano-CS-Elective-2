import 'package:flutter/foundation.dart' show kIsWeb, TargetPlatform, defaultTargetPlatform, kDebugMode;

/// Simple enum describing which "look and feel" the UI should adopt.
enum AppPlatform { ios, android, web, other }

class PlatformHelper {
  /// TESTING ONLY: set this to AppPlatform.ios or AppPlatform.android to force
  /// that styling even while running in Chrome, so you can eyeball the
  /// Cupertino/Material branches without a real device or simulator.
  /// Leave as `null` for normal behavior (and before submitting).
  static AppPlatform? debugForcePlatform;

  /// Detects the platform we should adapt widgets for.
  static AppPlatform get current {
    if (kDebugMode && debugForcePlatform != null) return debugForcePlatform!;
    if (kIsWeb) return AppPlatform.web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return AppPlatform.ios;
      case TargetPlatform.android:
        return AppPlatform.android;
      default:
        return AppPlatform.other;
    }
  }

  static bool get isCupertino => current == AppPlatform.ios;
  static bool get isWeb => current == AppPlatform.web;
}

/// Screen-size breakpoints used by LayoutBuilder throughout the app.
class Responsive {
  static const double mobileMax = 600;
  static const double tabletMax = 1024;

  static bool isMobile(double width) => width < mobileMax;
  static bool isTablet(double width) => width >= mobileMax && width < tabletMax;
  static bool isDesktop(double width) => width >= tabletMax;

  /// Grid columns per breakpoint: mobile = 2 cols, tablet/desktop = 4 cols.
  static int gridColumns(double width) {
    if (isMobile(width)) return 2;
    return 4;
  }
}
