import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/providers/favorites_provider.dart';
import 'package:pokedex/widgets/favorites_panel.dart';

/// Scaffold shared by every screen so the favorites button (AppBar) and the
/// favorites panel (under the AppBar) are available throughout the app.
class PokedexScaffold extends ConsumerWidget {
  final String title;
  final List<Widget> actions;
  final Widget body;
  final bool onDetailScreen;

  const PokedexScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions = const [],
    this.onDetailScreen = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expanded = ref.watch(favoritesPanelExpandedProvider);
    final count = ref.watch(favoritesProvider.select((s) => s.length));

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          ...actions,
          IconButton(
            tooltip: expanded ? 'Hide favorites' : 'Show favorites',
            icon: Badge(
              isLabelVisible: count > 0,
              label: Text('$count'),
              child: Icon(expanded ? Icons.favorite : Icons.favorite_border),
            ),
            onPressed: () =>
                ref.read(favoritesPanelExpandedProvider.notifier).toggle(),
          ),
        ],
      ),
      body: Column(
        children: [
          FavoritesPanel(onDetailScreen: onDetailScreen),
          Expanded(child: body),
        ],
      ),
    );
  }
}
