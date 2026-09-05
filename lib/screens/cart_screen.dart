import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../main.dart' show cartModel;
import '../widgets/cart_item_tile.dart';

// StatelessWidget justification:
// CartScreen doesn't hold any state of its own — it wraps its body in an
// AnimatedBuilder listening to cartModel (a ChangeNotifier). Whenever the
// cart changes (add, remove, +/-), cartModel calls notifyListeners() and
// AnimatedBuilder rebuilds just the part that depends on it. This is the
// same "external notifier" pattern already used for the light/dark
// toggle (ValueListenableBuilder + themeNotifier) — just applied to a
// ChangeNotifier instead of a ValueNotifier because the cart is a list,
// not a single value.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: AnimatedBuilder(
        animation: cartModel,
        builder: (context, _) {
          final items = cartModel.items;

          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 64, color: theme.hintColor),
                    const SizedBox(height: 16),
                    Text('Your cart is empty', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Browse the catalog and add a product to get started.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => context.go('/'),
                      child: const Text('Continue Shopping'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => CartItemTile(item: items[index]),
                ),
              ),
              _CheckoutBar(total: cartModel.total),
            ],
          );
        },
      ),
    );
  }
}

// A small, self-contained bottom bar so the running total and the
// Checkout button are visually pinned below the scrollable list.
class _CheckoutBar extends StatelessWidget {
  final double total;

  const _CheckoutBar({required this.total});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          border: Border(top: BorderSide(color: theme.dividerColor)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total', style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              // Navigation 2.0: go_router evaluates /checkout's redirect
              // guard here — since the cart is non-empty at this point,
              // it proceeds straight to CheckoutConfirmationScreen.
              onPressed: () => context.push('/checkout'),
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}
