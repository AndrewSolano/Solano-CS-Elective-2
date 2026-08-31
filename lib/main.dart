import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfluttersactivity/dashboard_screen.dart';
import 'package:myfluttersactivity/platform_helper.dart';

void main() {
  runApp(const ResponsiveAdaptiveApp());
}

class ResponsiveAdaptiveApp extends StatelessWidget {
  const ResponsiveAdaptiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (PlatformHelper.isCupertino) {
      return const CupertinoApp(
        title: 'Responsive Dashboard',
        debugShowCheckedModeBanner: false,
        theme: CupertinoThemeData(primaryColor: CupertinoColors.activeBlue),
        home: DashboardScreen(),
      );
    }

    return MaterialApp(
      title: 'Responsive Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}
