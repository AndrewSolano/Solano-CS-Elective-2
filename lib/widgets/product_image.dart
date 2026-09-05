import 'package:flutter/material.dart';

// StatelessWidget justification:
// Given a url + category, this widget always renders the same way for
// those inputs. It doesn't manage any state of its own — Image.network's
// loadingBuilder/errorBuilder handle the "still loading" / "failed to
// load" cases for us without needing setState() here.
class ProductImage extends StatelessWidget {
  final String imageUrl;
  final String category;
  final double? height;
  final BoxFit fit;

  const ProductImage({
    super.key,
    required this.imageUrl,
    required this.category,
    this.height,
    this.fit = BoxFit.contain,
  });

  IconData get _categoryIcon {
    switch (category) {
      case 'Phone':
        return Icons.smartphone;
      case 'Laptop':
        return Icons.laptop_mac;
      case 'Tablet':
        return Icons.tablet_mac;
      default:
        return Icons.headphones;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // A neutral, theme-driven surface color (light gray in light mode,
    // dark gray in dark mode) — comes from the ColorScheme generated in
    // theme.dart, not a hardcoded hex value.
    final Color background = scheme.surfaceContainerHighest;

    Widget placeholder({bool isError = false}) => Center(
          child: Icon(
            isError ? Icons.broken_image_outlined : _categoryIcon,
            size: (height ?? 120) * 0.3,
            color: scheme.primary.withValues(alpha: 0.6),
          ),
        );

    return Container(
      height: height,
      width: double.infinity,
      color: background,
      // Padding keeps the product from touching the edges when it's
      // shown in full ("contain") — the Product Detail screen uses this.
      // The Home grid instead asks for BoxFit.cover (no padding), which
      // fills the card edge-to-edge with no gray gaps.
      padding: fit == BoxFit.contain ? const EdgeInsets.all(16) : EdgeInsets.zero,
      child: Image.network(
        imageUrl,
        fit: fit,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return placeholder();
        },
        errorBuilder: (context, error, stackTrace) => placeholder(isError: true),
      ),
    );
  }
}
