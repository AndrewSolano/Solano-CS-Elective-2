import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/models/pokemon.dart';

enum PokemonStatus { initial, loading, success, error }

class PokemonProvider extends ChangeNotifier {
  static const String _baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  PokemonStatus _status = PokemonStatus.initial;
  List<Pokemon> _pokemon = [];
  String _errorMessage = '';
  Pokemon? _selectedPokemon;

  PokemonStatus get status => _status;
  List<Pokemon> get pokemon => _pokemon;
  String get errorMessage => _errorMessage;
  Pokemon? get selectedPokemon => _selectedPokemon;

  bool get isLoading => _status == PokemonStatus.loading;
  bool get hasError => _status == PokemonStatus.error;
  bool get isEmpty => _status == PokemonStatus.success && _pokemon.isEmpty;

  /// API call lives here, in the Provider. Also used for refresh.
  Future<void> fetchPokemon({int limit = 30}) async {
    _status = PokemonStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('$_baseUrl?limit=$limit'));

      if (response.statusCode != 200) {
        throw Exception('Failed to load Pokémon (${response.statusCode})');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>;

      _pokemon = results
          .map((e) => Pokemon.fromJson(e as Map<String, dynamic>))
          .toList();
      _status = PokemonStatus.success;
    } catch (e) {
      _errorMessage = e.toString();
      _status = PokemonStatus.error;
    }
    notifyListeners();
  }

  /// Re-triggers the API call (refresh button / retry).
  Future<void> refresh() => fetchPokemon();

  /// Stores which Pokémon was tapped so the detail page reads it from state.
  void selectPokemon(Pokemon pokemon) {
    _selectedPokemon = pokemon;
    notifyListeners();
  }
}
