import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pokedex/providers/pokemon_provider.dart';
import 'package:pokedex/screens/pokemon_detail_screen.dart';
import 'package:pokedex/widgets/pokemon_card.dart';

class PokemonListScreen extends StatelessWidget {
  const PokemonListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PokemonProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: provider.isLoading ? null : provider.refresh,
          ),
        ],
      ),
      body: _buildBody(context, provider),
    );
  }

  Widget _buildBody(BuildContext context, PokemonProvider provider) {
    // Loading state
    if (provider.isLoading || provider.status == PokemonStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }

    // Error state
    if (provider.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                'Something went wrong\n${provider.errorMessage}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: provider.refresh,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Empty state
    if (provider.isEmpty) {
      return const Center(child: Text('No Pokémon found.'));
    }

    // Success state
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: provider.pokemon.length,
      itemBuilder: (context, index) {
        final pokemon = provider.pokemon[index];
        return PokemonCard(
          pokemon: pokemon,
          onTap: () {
            context.read<PokemonProvider>().selectPokemon(pokemon);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PokemonDetailScreen()),
            );
          },
        );
      },
    );
  }
}
