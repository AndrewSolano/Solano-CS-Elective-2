// fruit_router_demo.dart
//
// Nested routing demo with go_router.
//
//   /              -> FruitListScreen  (list of fruits)
//   /fruit/:name    -> FruitDetailScreen (illustration for that fruit)
//
// Tapping a fruit does context.go('/fruit/$name') so the URL updates
// and the browser back button / deep link to e.g. /fruit/mango works
// out of the box.
//
// pubspec.yaml needs:
//   dependencies:
//     flutter:
//       sdk: flutter
//     go_router: ^14.0.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(const FruitApp());

// ---------------------------------------------------------------------------
// Fruit data
// ---------------------------------------------------------------------------

class Fruit {
  final String name;
  final Color color;
  final IconData icon;

  const Fruit(this.name, this.color, this.icon);
}

const List<Fruit> fruits = [
  Fruit('apple', Colors.red, Icons.circle),
  Fruit('banana', Colors.yellow, Icons.emoji_food_beverage), // placeholder shape
  Fruit('grape', Colors.purple, Icons.bubble_chart),
  Fruit('orange', Colors.orange, Icons.circle),
  Fruit('mango', Colors.deepOrange, Icons.egg),
];

Fruit? fruitByName(String name) {
  for (final f in fruits) {
    if (f.name == name) return f;
  }
  return null;
}

// ---------------------------------------------------------------------------
// Router — this is the part the lesson deck calls "the single source of
// truth". Nesting FruitDetailRoute under FruitListRoute (via `routes:`)
// means Flutter knows /fruit/:name is a child of /, so back-button and
// transition behavior fall out of the tree automatically.
// ---------------------------------------------------------------------------

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'fruitList',
      builder: (context, state) => const FruitListScreen(),
      routes: [
        // Nested route: full path becomes /fruit/:name
        GoRoute(
          path: 'fruit/:name',
          name: 'fruitDetail',
          builder: (context, state) {
            final name = state.pathParameters['name']!;
            return FruitDetailScreen(name: name);
          },
        ),
      ],
    ),
  ],
  // If someone deep-links to a fruit that doesn't exist, bounce home.
  redirect: (context, state) {
    final match = RegExp(r'^/fruit/([^/]+)$').firstMatch(state.uri.path);
    if (match != null && fruitByName(match.group(1)!) == null) {
      return '/';
    }
    return null;
  },
);

// ---------------------------------------------------------------------------
// App
// ---------------------------------------------------------------------------

class FruitApp extends StatelessWidget {
  const FruitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Fruit Router Demo',
      routerConfig: _router,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
    );
  }
}

// ---------------------------------------------------------------------------
// Screen 1: fruit list at "/"
// ---------------------------------------------------------------------------

class FruitListScreen extends StatelessWidget {
  const FruitListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fruits')),
      body: ListView.builder(
        itemCount: fruits.length,
        itemBuilder: (context, index) {
          final fruit = fruits[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: fruit.color.withOpacity(0.2),
              child: Icon(fruit.icon, color: fruit.color),
            ),
            title: Text(
              fruit.name[0].toUpperCase() + fruit.name.substring(1),
            ),
            trailing: const Icon(Icons.chevron_right),
            // URL becomes /fruit/<name> — context.go() replaces the
            // current location (compare to context.push(), which would
            // stack on top instead).
            onTap: () => context.go('/fruit/${fruit.name}'),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Screen 2: fruit detail at "/fruit/:name"
// ---------------------------------------------------------------------------

class FruitDetailScreen extends StatelessWidget {
  final String name;
  const FruitDetailScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final fruit = fruitByName(name);

    return Scaffold(
      appBar: AppBar(
        title: Text(fruit != null
            ? fruit.name[0].toUpperCase() + fruit.name.substring(1)
            : 'Unknown fruit'),
      ),
      body: Center(
        child: fruit == null
            ? const Text('No such fruit.')
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Simple illustration built from the fruit's icon/color
                  // instead of a network image, so the demo has no
                  // external asset dependency.
                  FruitIllustration(fruit: fruit),
                  const SizedBox(height: 24),
                  Text(
                    fruit.name[0].toUpperCase() + fruit.name.substring(1),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Text('URL: /fruit/${fruit.name}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back to list'),
                    // pop() unwinds to the parent route (/) since
                    // fruit/:name is nested under it in the router tree.
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
      ),
    );
  }
}

/// A small painted "illustration" for a fruit — a colored circle with a
/// leaf, sized and shaped per fruit. Swap this for Image.asset/.network
/// in a real app; kept self-contained here so the demo has no assets.
class FruitIllustration extends StatelessWidget {
  final Fruit fruit;
  const FruitIllustration({super.key, required this.fruit});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 160,
      child: CustomPaint(
        painter: _FruitPainter(fruit.color),
      ),
    );
  }
}

class _FruitPainter extends CustomPainter {
  final Color color;
  _FruitPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final bodyPaint = Paint()..color = color;
    final leafPaint = Paint()..color = Colors.green;
    final stemPaint = Paint()
      ..color = Colors.brown
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2 + 10);
    final radius = size.width / 2 - 20;

    // Body
    canvas.drawCircle(center, radius, bodyPaint);

    // Stem
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy - radius - 16),
      stemPaint,
    );

    // Leaf
    final leafPath = Path()
      ..moveTo(center.dx, center.dy - radius - 12)
      ..quadraticBezierTo(
        center.dx + 30,
        center.dy - radius - 30,
        center.dx + 4,
        center.dy - radius - 4,
      )
      ..close();
    canvas.drawPath(leafPath, leafPaint);
  }

  @override
  bool shouldRepaint(covariant _FruitPainter oldDelegate) =>
      oldDelegate.color != color;
}
