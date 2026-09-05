import 'package:flutter/material.dart';
import 'theme.dart';
import 'router.dart';
import 'models/cart.dart';

void main() {
  runApp(const MyApp());
}

// A simple, app-wide "switch" that remembers whether we are in light or
// dark mode. It lives OUTSIDE any widget (top-level) so that any screen
// in the app (like HomeScreen) can read it or change it without having to
// pass it down through many constructors.
//
// ValueNotifier already knows how to notify listeners when its value
// changes — that's what makes the light/dark toggle update the whole app
// immediately.
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

// Same idea as themeNotifier above, but for the shopping cart: one shared
// CartModel that Home (badge count), Product Detail (Add to Cart), Cart,
// and Checkout Confirmation all read from and write to. See cart.dart for
// why a ChangeNotifier is used here instead of a ValueNotifier.
final CartModel cartModel = CartModel();

// MyApp is a StatelessWidget itself: it doesn't manage state directly.
// Instead it "listens" to themeNotifier via ValueListenableBuilder, which
// takes care of rebuilding MaterialApp.router whenever the theme changes.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp.router(
          title: 'GadgetHub',
          debugShowCheckedModeBanner: false,

          // Single ThemeData defined at the MaterialApp level (theme.dart)
          // instead of hardcoding colors inside individual widgets.
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,

          // Navigation 2.0 (go_router) configuration from router.dart.
          routerConfig: appRouter,
        );
      },
    );
  }
}
