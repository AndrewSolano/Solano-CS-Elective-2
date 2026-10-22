import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/providers/favorites_provider.dart';
import 'package:pokedex/providers/nickname_provider.dart';
import 'package:pokedex/providers/pokemon_provider.dart';
import 'package:pokedex/screens/pokemon_detail_screen.dart';

/// Collapsible panel shown under the AppBar on every screen.
/// Opened/closed with the heart button in the AppBar.
class FavoritesPanel extends ConsumerWidget {
  /// When the panel is shown on the detail screen, tapping a favorite just
  /// switches the selected Pokémon instead of pushing another screen.
  final bool onDetailScreen;

  const FavoritesPanel({super.key, this.onDetailScreen = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expanded = ref.watch(favoritesPanelExpandedProvider);
    final favorites = ref.watch(favoritePokemonProvider);
    final nicknames = ref.watch(nicknameProvider);
    final colors = Theme.of(context).colorScheme;

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: expanded
          ? Container(
              width: double.infinity,
              color: colors.surfaceContainerHighest,
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Favorites (${favorites.length})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (favorites.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'No favorites yet. Tap the heart on a Pokémon to add one.',
                      ),
                    )
                  else
                    SizedBox(
                      height: 104,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: favorites.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final pokemon = favorites[index];
                          final label =
                              nicknames[pokemon.id] ?? pokemon.displayName;
                          return SizedBox(
                            width: 84,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      ref
                                          .read(selectedPokemonIdProvider
                                              .notifier)
                                          .selectPokemon(pokemon);
                                      if (!onDetailScreen) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const PokemonDetailScreen(),
                                          ),
                                        );
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Image.network(
                                            pokemon.imageUrl,
                                            fit: BoxFit.contain,
                                            errorBuilder: (_, _, _) =>
                                                const Icon(Icons.broken_image),
                                          ),
                                        ),
                                        Text(
                                          label,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () => ref
                                        .read(favoritesProvider.notifier)
                                        .removeFavorite(pokemon.id),
                                    child: const Icon(Icons.favorite,
                                        color: Colors.red, size: 20),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            )
          : const SizedBox(width: double.infinity),
    );
  }
}
