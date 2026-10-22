import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/providers/favorites_provider.dart';
import 'package:pokedex/providers/nickname_provider.dart';
import 'package:pokedex/providers/pokemon_provider.dart';
import 'package:pokedex/utils/type_colors.dart';
import 'package:pokedex/widgets/nickname_editor_dialog.dart';
import 'package:pokedex/widgets/pokedex_scaffold.dart';

class PokemonDetailScreen extends ConsumerWidget {
  const PokemonDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // All values come from Riverpod (app state).
    final pokemon = ref.watch(selectedPokemonProvider);

    if (pokemon == null) {
      return const PokedexScaffold(
        title: 'Pokédex',
        onDetailScreen: true,
        body: Center(child: Text('No Pokémon selected.')),
      );
    }

    final nickname = ref.watch(nicknameProvider)[pokemon.id];
    final isFavorite = ref.watch(favoritesProvider).contains(pokemon.id);

    return PokedexScaffold(
      title: nickname ?? pokemon.displayName,
      onDetailScreen: true,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  pokemon.displayId,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                Hero(
                  tag: 'pokemon-${pokemon.id}',
                  child: Image.network(
                    pokemon.imageUrl,
                    height: 280,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, progress) => progress == null
                        ? child
                        : const SizedBox(
                            height: 280,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                    errorBuilder: (context, error, stack) =>
                        const Icon(Icons.broken_image, size: 96),
                  ),
                ),
                const SizedBox(height: 16),
                if (nickname != null) ...[
                  Text(
                    nickname,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Original name: ${pokemon.displayName}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ] else
                  Text(
                    pokemon.displayName,
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.w700),
                  ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final type in pokemon.types)
                      Chip(
                        label: Text(
                          capitalize(type),
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: typeColor(type),
                        side: BorderSide.none,
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: () => ref
                          .read(favoritesProvider.notifier)
                          .toggleFavorite(pokemon.id),
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                      label: Text(isFavorite
                          ? 'Remove from favorites'
                          : 'Add to favorites'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => showNicknameEditor(context, pokemon),
                      icon: const Icon(Icons.edit),
                      label: Text(
                          nickname == null ? 'Add nickname' : 'Edit nickname'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
