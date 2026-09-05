import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../main.dart' show cartModel;

// StatelessWidget justification:
// Same reasoning as everywhere else this pattern is used in the app: the
// widget itself holds no state. It wraps its icon in an AnimatedBuilder
// listening to cartModel (a ChangeNotifier), so the badge count updates
// immediately no matter which screen this button is placed on.
class CartIconButton extends StatelessWidget {
  const CartIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: cartModel,
      builder: (context, _) {
        final count = cartModel.itemCount;
        return IconButton(
          tooltip: 'View Cart',
          onPressed: () => context.push('/cart'),
          icon: Badge(
            label: Text('$count'),
            isLabelVisible: count > 0,
            child: const Icon(Icons.shopping_cart_outlined),
          ),
        );
      },
    );
  }
}
