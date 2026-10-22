import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/providers/pokemon_provider.dart';

/// Set of favorite Pokémon IDs (insertion order is kept).
class FavoritesNotifier extends Notifier<Set<int>> {
  @override
  Set<int> build() => <int>{};

  bool isFavorite(int pokemonId) => state.contains(pokemonId);

  void toggleFavorite(int pokemonId) {
    final updated = Set<int>.of(state);
    if (!updated.add(pokemonId)) {
      updated.remove(pokemonId);
    }
    state = updated; // new Set instance -> listeners rebuild
  }

  void removeFavorite(int pokemonId) {
    if (!state.contains(pokemonId)) return;
    state = Set<int>.of(state)..remove(pokemonId);
  }
}

final favoritesProvider =
    NotifierProvider<FavoritesNotifier, Set<int>>(FavoritesNotifier.new);

/// Derived provider: the actual Pokemon objects marked as favorites.
/// Recomputes automatically when favorites OR the Pokémon list change.
final favoritePokemonProvider = Provider<List<Pokemon>>((ref) {
  final ids = ref.watch(favoritesProvider);
  final all = ref.watch(pokemonProvider.select((s) => s.pokemon));
  final byId = {for (final p in all) p.id: p};
  return [
    for (final id in ids)
      if (byId[id] != null) byId[id]!,
  ];
});

/// Expanded/collapsed state of the favorites panel. Kept in app state so it
/// stays the same on every screen.
class FavoritesPanelNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

final favoritesPanelExpandedProvider =
    NotifierProvider<FavoritesPanelNotifier, bool>(FavoritesPanelNotifier.new);
