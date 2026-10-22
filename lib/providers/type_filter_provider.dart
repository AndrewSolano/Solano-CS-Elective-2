import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/providers/pokemon_provider.dart';

/// The selected type, or null when no filter is applied.
class TypeFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void selectType(String type) => state = type;

  void clearFilter() => state = null;
}

final typeFilterProvider =
    NotifierProvider<TypeFilterNotifier, String?>(TypeFilterNotifier.new);

/// Derived provider: every type that actually exists in the loaded data.
final availableTypesProvider = Provider<List<String>>((ref) {
  final list = ref.watch(pokemonProvider.select((s) => s.pokemon));
  final types = <String>{for (final p in list) ...p.types};
  return types.toList()..sort();
});

/// Derived provider: the list the home screen actually displays.
final filteredPokemonProvider = Provider<List<Pokemon>>((ref) {
  final all = ref.watch(pokemonProvider.select((s) => s.pokemon));
  final type = ref.watch(typeFilterProvider);
  if (type == null) return all;
  return all.where((p) => p.types.contains(type)).toList();
});
