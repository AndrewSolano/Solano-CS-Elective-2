import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../main.dart' show cartModel;

// StatelessWidget justification:
// This screen just reads cartModel.items ONCE when it's built (to render
// the order summary) and displays it — it doesn't need to keep listening
// for further changes the way CartScreen does, because nothing on this
// screen changes the cart's contents. The one action available
// ("Continue Shopping") clears the cart and navigates away, it doesn't
// update anything in place on this screen.
class CheckoutConfirmationScreen extends StatelessWidget {
  const CheckoutConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final items = cartModel.items;
    final total = cartModel.total;

    return Scaffold(
      appBar: AppBar(title: const Text('Order Confirmation'), automaticallyImplyLeading: false),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Icon(Icons.check_circle, color: scheme.primary, size: 72),
            const SizedBox(height: 12),
            Text(
              'Thank you for your order!',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Your order has been placed successfully.',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            Text('Order Summary', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  for (final item in items)
                    ListTile(
                      title: Text(item.product.name),
                      subtitle: Text('Qty: ${item.quantity} × \$${item.product.price.toStringAsFixed(2)}'),
                      trailing: Text(
                        '\$${item.subtotal.toStringAsFixed(2)}',
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                  const Divider(height: 1),
                  ListTile(
                    title: Text('Total', style: theme.textTheme.titleMedium),
                    trailing: Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () {
                // The order is "placed" — empty the cart and head back to
                // the catalog. Using go() (not push()) replaces the whole
                // navigation stack, so the back button won't return the
                // user to this now-stale confirmation screen.
                cartModel.clear();
                context.go('/');
              },
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      ),
    );
  }
}
