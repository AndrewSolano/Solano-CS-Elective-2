String capitalize(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

class Pokemon {
  final int id;
  final String name;
  final String imageUrl;

  /// Actual type data from the API (e.g. ['grass', 'poison']).
  /// The list endpoint doesn't include types, so they are filled in
  /// from the per-Pokémon endpoint during fetchPokemon().
  final List<String> types;

  const Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.types = const [],
  });

  /// The list endpoint only returns `name` and `url`; the ID is parsed from
  /// the URL and used to build the image URL.
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final url = json['url'] as String;
    final segments =
        Uri.parse(url).pathSegments.where((s) => s.isNotEmpty).toList();
    final id = int.parse(segments.last);

    return Pokemon(
      id: id,
      name: json['name'] as String,
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
    );
  }

  Pokemon copyWith({List<String>? types}) => Pokemon(
        id: id,
        name: name,
        imageUrl: imageUrl,
        types: types ?? this.types,
      );

  String get displayName => capitalize(name);
  String get displayId => '#${id.toString().padLeft(3, '0')}';
  String get typesLabel => types.map(capitalize).join(' · ');
}
