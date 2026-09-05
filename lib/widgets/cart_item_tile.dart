import 'package:flutter/material.dart';
import '../main.dart' show cartModel;
import '../models/cart.dart';

// StatelessWidget justification:
// This tile never manages its own state. Tapping + or - calls cartModel
// (the shared ChangeNotifier from cart.dart) directly, which then calls
// notifyListeners(). CartScreen listens to cartModel and rebuilds its
// whole list when that happens — so this tile is simply re-created with
// fresh data each time, exactly like ProductCard is on the Home screen.
class CartItemTile extends StatelessWidget {
  final CartItem item;

  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 72,
                height: 72,
                child: Image.network(
                  item.product.imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.image_not_supported_outlined,
                    color: scheme.primary.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '\$${item.product.price.toStringAsFixed(2)} each',
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                  ),
                  const SizedBox(height: 8),
                  // --- Quantity control ---------------------------------
                  // This is the "Stateful quantity control" the Cart
                  // screen requires — the state itself lives in the
                  // shared cartModel rather than in this widget, so the
                  // change is reflected everywhere at once (e.g. Home's
                  // cart badge) instead of just inside this one tile.
                  Row(
                    children: [
                      _QtyButton(
                        icon: Icons.remove,
                        onPressed: () => cartModel.decrementQuantity(item.product.id),
                      ),
                      SizedBox(
                        width: 32,
                        child: Text(
                          '${item.quantity}',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      _QtyButton(
                        icon: Icons.add,
                        onPressed: () => cartModel.incrementQuantity(item.product.id),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${item.subtotal.toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Remove from cart',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => cartModel.removeItem(item.product.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Small shared button so the +/- controls look identical and the tile's
// build method above stays readable.
class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _QtyButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 30,
      child: IconButton(
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        icon: Icon(icon, size: 16),
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
