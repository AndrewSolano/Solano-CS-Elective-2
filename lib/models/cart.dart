import 'package:flutter/foundation.dart';
import 'product.dart';

// One line item in the cart: a Product plus how many the user wants.
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get subtotal => product.price * quantity;
}

// CartModel is a ChangeNotifier — conceptually the same idea as
// themeNotifier (a ValueNotifier) in main.dart: a single, app-wide piece
// of state that lives OUTSIDE any widget, so every screen that cares
// about the cart (Home's badge, the Cart screen, Checkout) reads the
// SAME data instead of each keeping its own copy that could drift out
// of sync. A ChangeNotifier is used here instead of a ValueNotifier
// because the cart is a whole list of items with quantities, not a
// single value.
//
// Whenever a method below changes the cart, it calls notifyListeners()
// — any widget wrapped in an AnimatedBuilder(animation: cartModel, ...)
// automatically rebuilds with the new data. This is what makes the
// quantity +/- buttons on the Cart screen "stateful": the interaction
// changes shared state, and every listening widget reacts immediately.
class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  // Read-only view — screens must go through the methods below (which
  // call notifyListeners()) instead of mutating the list directly.
  List<CartItem> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  // Total number of individual units in the cart (used for the AppBar badge).
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get total => _items.fold(0.0, (sum, item) => sum + item.subtotal);

  // Adds [quantity] of [product]. If it's already in the cart, this bumps
  // the existing quantity instead of creating a duplicate row.
  void addItem(Product product, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void incrementQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  // Decrementing to 0 removes the line item entirely rather than showing
  // a "0 x Product" row.
  void decrementQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index < 0) return;
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  // Called after the user leaves the Checkout Confirmation screen so the
  // next visit to Home/Cart starts fresh.
  void clear() {
    _items.clear();
    notifyListeners();
  }
}
