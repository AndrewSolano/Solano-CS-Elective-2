import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import '../widgets/cart_icon_button.dart';
import '../widgets/theme_toggle_button.dart';

// StatelessWidget justification:
// This screen does not hold any mutable state of its own.
// - The grid column count is just calculated on every build using the
//   current screen width (via LayoutBuilder), it isn't "remembered".
// - The light/dark toggle mutates an external ValueNotifier (themeNotifier)
//   which lives above this widget in main.dart, so this screen never calls
//   setState() itself.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GadgetHub'),
        actions: [
          // Same two buttons are reused on Product Detail's AppBar — see
          // cart_icon_button.dart / theme_toggle_button.dart.
          const CartIconButton(),
          const ThemeToggleButton(),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // Simple hero banner for a more "real store" feel.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            color: Theme.of(context).appBarTheme.backgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Latest Gadgets',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  'Phones, laptops, tablets & more',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Responsive rule required by the exam:
                  // - phone width  -> 2 columns
                  // - tablet width (>= 600) -> 3+ columns
                  final int columnCount = constraints.maxWidth >= 900
                      ? 4
                      : constraints.maxWidth >= 600
                          ? 3
                          : 2;

                  return GridView.builder(
                    itemCount: sampleProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columnCount,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.68,
                    ),
                    itemBuilder: (context, index) {
                      final product = sampleProducts[index];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          // Navigation 2.0 (go_router): push the product
                          // detail route so the AppBar back arrow works.
                          context.push('/product/${product.id}');
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
