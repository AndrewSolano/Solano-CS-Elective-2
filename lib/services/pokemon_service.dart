import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedex/models/pokemon.dart';

class PokemonService {
  static const String _baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  /// A Future is used because this is a one-time request that returns
  /// a single response and then completes.
  Future<List<Pokemon>> fetchPokemon({int limit = 30}) async {
    final response = await http.get(Uri.parse('$_baseUrl?limit=$limit'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load Pokémon (${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>;

    return results
        .map((e) => Pokemon.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
