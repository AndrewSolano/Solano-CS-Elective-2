import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_image.dart';
import '../widgets/add_to_cart_controls.dart';
import '../widgets/cart_icon_button.dart';
import '../widgets/theme_toggle_button.dart';

// StatelessWidget justification:
// This screen itself doesn't own any mutable state — it just looks up
// the Product for the given id and lays it out. The one truly
// interactive part (choosing a quantity and adding to cart) is broken
// out into AddToCartControls, which IS a StatefulWidget for the reasons
// explained in that file. Keeping this screen Stateless and pushing the
// state down into the smallest widget that actually needs it is
// generally the better Flutter pattern than making the whole screen
// Stateful just because one small part of it changes.
class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    // Find the product that matches the id coming from the route.
    final product = sampleProducts.firstWhere(
      (p) => p.id == productId,
      orElse: () => sampleProducts.first,
    );
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: const [
          CartIconButton(),
          ThemeToggleButton(),
          SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'product-image-${product.id}',
              child: ProductImage(
                imageUrl: product.imageUrl,
                category: product.category,
                height: 280,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(label: Text(product.category.toUpperCase())),
                  const SizedBox(height: 10),
                  Text(product.name, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- Description -------------------------------------
                  Text('Description', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(product.description, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 20),

                  // --- Specs --------------------------------------------
                  Text('Specifications', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: Column(
                        children: [
                          for (final spec in product.specs)
                            ListTile(
                              dense: true,
                              leading: Icon(Icons.check_circle_outline, color: scheme.primary),
                              title: Text(spec, style: theme.textTheme.bodyMedium),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // --- Add to Cart (Stateful — see add_to_cart_controls.dart) ---
                  AddToCartControls(product: product),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
