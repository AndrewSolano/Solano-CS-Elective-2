import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/models/pokemon.dart';

enum PokemonStatus { initial, loading, success, error }

/// Immutable snapshot of everything the list screen needs.
/// Riverpod rebuilds listeners whenever a NEW instance is assigned to `state`.
class PokemonState {
  final PokemonStatus status;
  final List<Pokemon> pokemon;
  final String errorMessage;

  const PokemonState({
    this.status = PokemonStatus.initial,
    this.pokemon = const [],
    this.errorMessage = '',
  });

  PokemonState copyWith({
    PokemonStatus? status,
    List<Pokemon>? pokemon,
    String? errorMessage,
  }) =>
      PokemonState(
        status: status ?? this.status,
        pokemon: pokemon ?? this.pokemon,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  bool get isLoading => status == PokemonStatus.loading;
  bool get hasError => status == PokemonStatus.error;
  bool get isEmpty => status == PokemonStatus.success && pokemon.isEmpty;
}

class PokemonNotifier extends Notifier<PokemonState> {
  static const String _baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  @override
  PokemonState build() {
    // Initial load. Deferred so `state` exists before fetchPokemon touches it.
    Future.microtask(fetchPokemon);
    return const PokemonState();
  }

  /// The ONE fetch method. The initial load, the refresh button,
  /// pull-to-refresh and the Retry button all call this same method.
  Future<void> fetchPokemon({int limit = 30}) async {
    state = state.copyWith(status: PokemonStatus.loading, errorMessage: '');

    try {
      final response = await http.get(Uri.parse('$_baseUrl?limit=$limit'));

      if (response.statusCode != 200) {
        throw Exception('Failed to load Pokémon (${response.statusCode})');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>;

      final basics = results
          .map((e) => Pokemon.fromJson(e as Map<String, dynamic>))
          .toList();

      // Fetch every Pokémon's types in parallel so the type filter can use
      // real API data.
      final withTypes = await Future.wait(basics.map(_loadTypes));

      state = state.copyWith(
        status: PokemonStatus.success,
        pokemon: withTypes,
      );
    } catch (e) {
      state = state.copyWith(
        status: PokemonStatus.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Helper for fetchPokemon. If one Pokémon's detail call fails we keep it
  /// in the list (without types) instead of failing the whole list.
  Future<Pokemon> _loadTypes(Pokemon p) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/${p.id}'));
      if (response.statusCode != 200) return p;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final types = (data['types'] as List<dynamic>).map((t) {
        final typeInfo = (t as Map<String, dynamic>)['type'];
        return (typeInfo as Map<String, dynamic>)['name'] as String;
      }).toList();

      return p.copyWith(types: types);
    } catch (_) {
      return p;
    }
  }
}

final pokemonProvider =
    NotifierProvider<PokemonNotifier, PokemonState>(PokemonNotifier.new);

// ---- Selected Pokémon (for the detail page) --------------------------------

/// Stores only the ID, so the detail page always shows the latest data
/// from the list (e.g. after a refresh).
class SelectedPokemonIdNotifier extends Notifier<int?> {
  @override
  int? build() => null;

  void selectPokemon(Pokemon pokemon) => state = pokemon.id;
}

final selectedPokemonIdProvider =
    NotifierProvider<SelectedPokemonIdNotifier, int?>(
        SelectedPokemonIdNotifier.new);

/// Derived provider: the full Pokemon object for the selected ID.
final selectedPokemonProvider = Provider<Pokemon?>((ref) {
  final id = ref.watch(selectedPokemonIdProvider);
  if (id == null) return null;
  final list = ref.watch(pokemonProvider.select((s) => s.pokemon));
  for (final p in list) {
    if (p.id == id) return p;
  }
  return null;
});
