import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/providers/pokemon_provider.dart';
import 'package:pokedex/providers/type_filter_provider.dart';
import 'package:pokedex/screens/pokemon_detail_screen.dart';
import 'package:pokedex/widgets/pokedex_scaffold.dart';
import 'package:pokedex/widgets/pokemon_card.dart';
import 'package:pokedex/widgets/type_filter_bar.dart';
import 'package:pokedex/models/pokemon.dart';

class PokemonListScreen extends ConsumerWidget {
  const PokemonListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pokemonProvider);
    final notifier = ref.read(pokemonProvider.notifier);

    // A failed refresh while data is already on screen: keep the list and
    // tell the user with a SnackBar.
    ref.listen<PokemonState>(pokemonProvider, (previous, next) {
      if (next.hasError &&
          next.pokemon.isNotEmpty &&
          previous?.status != PokemonStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Refresh failed: ${next.errorMessage}')),
        );
      }
    });

    return PokedexScaffold(
      title: 'Pokédex',
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: 'Refresh',
          // Same fetchPokemon() method everywhere. No separate refresh method.
          onPressed: state.isLoading ? null : () => notifier.fetchPokemon(),
        ),
      ],
      body: _buildBody(context, ref, state),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, PokemonState state) {
    final notifier = ref.read(pokemonProvider.notifier);

    // Nothing loaded yet: loading / error / empty states.
    if (state.pokemon.isEmpty) {
      if (state.isLoading || state.status == PokemonStatus.initial) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state.hasError) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 12),
                Text(
                  'Something went wrong\n${state.errorMessage}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => notifier.fetchPokemon(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }

      // Success but the API returned nothing. Scrollable so pull-to-refresh works.
      return RefreshIndicator(
        onRefresh: () => notifier.fetchPokemon(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 200),
            Center(child: Text('No Pokémon found.')),
          ],
        ),
      );
    }

    // Data available: filter bar + (filtered) grid.
    final filtered = ref.watch(filteredPokemonProvider);
    final selectedType = ref.watch(typeFilterProvider);

    return Column(
      children: [
        const TypeFilterBar(),
        if (state.isLoading) const LinearProgressIndicator(),
        Expanded(
          child: RefreshIndicator(
            // Pull-to-refresh re-calls the same fetchPokemon().
            onRefresh: () => notifier.fetchPokemon(),
            child: filtered.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 120),
                      Center(
                        child: Text(
                          'No ${capitalize(selectedType ?? '')} Pokémon found.',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: TextButton(
                          onPressed: () =>
                              ref.read(typeFilterProvider.notifier).clearFilter(),
                          child: const Text('Clear filter'),
                        ),
                      ),
                    ],
                  )
                : GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 220,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final pokemon = filtered[index];
                      return PokemonCard(
                        pokemon: pokemon,
                        onTap: () {
                          ref
                              .read(selectedPokemonIdProvider.notifier)
                              .selectPokemon(pokemon);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PokemonDetailScreen(),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
