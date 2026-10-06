import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pokedex/providers/pokemon_provider.dart';

class PokemonDetailScreen extends StatelessWidget {
  const PokemonDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // All values come from the Provider (app state).
    final pokemon = context.watch<PokemonProvider>().selectedPokemon;

    if (pokemon == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('No Pokémon selected.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(pokemon.displayName)),
      body: Center(
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
              Text(
                pokemon.displayName,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
