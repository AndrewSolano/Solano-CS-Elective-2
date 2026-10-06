class Pokemon {
  final int id;
  final String name;
  final String imageUrl;

  Pokemon({required this.id, required this.name, required this.imageUrl});

  /// The list endpoint only returns `name` and `url`; the ID is parsed from
  /// the URL and used to build the image URL (one API call only).
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

  String get displayName => name[0].toUpperCase() + name.substring(1);
  String get displayId => '#${id.toString().padLeft(3, '0')}';
}
