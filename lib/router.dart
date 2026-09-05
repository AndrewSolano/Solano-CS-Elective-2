import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_confirmation_screen.dart';
import 'main.dart' show cartModel;

// Navigation 2.0 setup using the go_router package.
// Instead of pushing/popping routes manually (Navigation 1.0), we declare
// all the possible routes ("paths") for the app in one place here.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      // ':id' is a path parameter, e.g. /product/p1
      path: '/product/:id',
      name: 'productDetail',
      builder: (context, state) {
        final productId = state.pathParameters['id']!;
        return ProductDetailScreen(productId: productId);
      },
    ),
    GoRoute(
      path: '/cart',
      name: 'cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/checkout',
      name: 'checkout',
      // Requirement: Checkout Confirmation is "reachable only after at
      // least one item is in the cart". go_router's `redirect` runs
      // before the page is built, every time this route is navigated to
      // (including deep links or a browser refresh on web) — so if the
      // cart is empty at that moment, we send the user back to the Cart
      // screen instead of showing an empty confirmation.
      redirect: (context, state) {
        if (cartModel.isEmpty) return '/cart';
        return null; // null = proceed to CheckoutConfirmationScreen as normal
      },
      builder: (context, state) => const CheckoutConfirmationScreen(),
    ),
  ],
);
