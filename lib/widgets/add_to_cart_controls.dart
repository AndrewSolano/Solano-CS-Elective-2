import 'package:flutter/material.dart';
import '../main.dart' show cartModel;
import '../models/product.dart';
import '../router.dart' show appRouter;

// StatefulWidget justification:
// This widget owns a `_quantity` number that the user changes by tapping
// + / - BEFORE adding the product to the cart. That number belongs to
// this widget alone — no other screen needs to know "the user is
// currently thinking about buying 3 of these" — so it's local UI state
// via setState(), not something that needs to live in the shared
// CartModel. Once "Add to Cart" is tapped, the *chosen* quantity is
// handed off to cartModel.addItem(...), which is where the app-wide cart
// state (shared with the Cart and Checkout screens) takes over.
class AddToCartControls extends StatefulWidget {
  final Product product;

  const AddToCartControls({super.key, required this.product});

  @override
  State<AddToCartControls> createState() => _AddToCartControlsState();
}

class _AddToCartControlsState extends State<AddToCartControls> {
  int _quantity = 1;

  void _increment() => setState(() => _quantity++);

  void _decrement() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  void _addToCart() {
    cartModel.addItem(widget.product, _quantity);

    final messenger = ScaffoldMessenger.of(context);
    // Clear any snackbar still showing from a previous "Add to Cart" tap,
    // so they can't stack up and look like the message "won't go away".
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        // A custom Row instead of a plain Text: this puts a manual close
        // (X) button on the far LEFT, before the message. Tapping it
        // calls hideCurrentSnackBar() to dismiss immediately — useful
        // because Flutter pauses the auto-dismiss timer while the mouse
        // is hovering over the snackbar (an accessibility behavior on
        // web/desktop), so relying on the 3-second timer alone isn't
        // always enough.
        content: Row(
          children: [
            InkWell(
              onTap: () => messenger.hideCurrentSnackBar(),
              borderRadius: BorderRadius.circular(20),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text('Added $_quantity × ${widget.product.name} to cart')),
          ],
        ),
        // Auto-dismisses after 3 seconds if the user doesn't tap the action
        // or manually close it (see the note above about hover pausing this).
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'VIEW CART',
          // Navigate through the global `appRouter` instance instead of
          // this widget's BuildContext. If the user has already left this
          // screen (e.g. tapped back to Home) by the time they tap "VIEW
          // CART", this widget's context is "defunct" and context.push(...)
          // would silently fail to navigate. appRouter.push(...) doesn't
          // depend on any particular screen's context, so it always works.
          onPressed: () => appRouter.push('/cart'),
        ),
      ),
    );

    // Reset back to 1 so a second "Add to Cart" tap doesn't silently
    // reuse whatever quantity was left over from before.
    setState(() => _quantity = 1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // --- Quantity stepper ---------------------------------------
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.dividerColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: _decrement,
                icon: const Icon(Icons.remove),
                tooltip: 'Decrease quantity',
              ),
              SizedBox(
                width: 28,
                child: Text(
                  '$_quantity',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              IconButton(
                onPressed: _increment,
                icon: const Icon(Icons.add),
                tooltip: 'Increase quantity',
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // --- Add to Cart button ---------------------------------------
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _addToCart,
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Add to Cart'),
          ),
        ),
      ],
    );
  }
}
