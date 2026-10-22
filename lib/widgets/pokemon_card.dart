import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/providers/favorites_provider.dart';
import 'package:pokedex/providers/nickname_provider.dart';
import 'package:pokedex/widgets/nickname_editor_dialog.dart';

class PokemonCard extends ConsumerWidget {
  final Pokemon pokemon;
  final VoidCallback onTap;

  const PokemonCard({super.key, required this.pokemon, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // `select` => this card only rebuilds when ITS nickname / favorite
    // status changes, not when any other Pokémon's does.
    final nickname = ref.watch(nicknameProvider.select((m) => m[pokemon.id]));
    final isFavorite =
        ref.watch(favoritesProvider.select((s) => s.contains(pokemon.id)));

    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        onLongPress: () => showNicknameEditor(context, pokemon),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip:
                        isFavorite ? 'Remove from favorites' : 'Add to favorites',
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    iconSize: 24,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () => ref
                        .read(favoritesProvider.notifier)
                        .toggleFavorite(pokemon.id),
                  ),
                  const Spacer(),
                  Text(
                    pokemon.displayId,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Hero(
                  tag: 'pokemon-${pokemon.id}',
                  child: Image.network(
                    pokemon.imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, progress) =>
                        progress == null
                            ? child
                            : const Center(child: CircularProgressIndicator()),
                    errorBuilder: (context, error, stack) =>
                        const Icon(Icons.broken_image, size: 48),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Nickname (if set) is the headline; the original name stays visible.
              if (nickname != null) ...[
                Text(
                  nickname,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  pokemon.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ] else
                Text(
                  pokemon.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              if (pokemon.types.isNotEmpty)
                Text(
                  pokemon.typesLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
