import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/providers/favorites_provider.dart';
import 'package:pokedex/providers/nickname_provider.dart';
import 'package:pokedex/providers/pokemon_provider.dart';
import 'package:pokedex/providers/type_filter_provider.dart';

/// Fake notifier so tests never hit the network.
class _FakePokemonNotifier extends PokemonNotifier {
  @override
  PokemonState build() => const PokemonState(
        status: PokemonStatus.success,
        pokemon: [
          Pokemon(id: 1, name: 'bulbasaur', imageUrl: '', types: ['grass', 'poison']),
          Pokemon(id: 4, name: 'charmander', imageUrl: '', types: ['fire']),
          Pokemon(id: 7, name: 'squirtle', imageUrl: '', types: ['water']),
        ],
      );
}

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [pokemonProvider.overrideWith(_FakePokemonNotifier.new)],
    );
  });

  tearDown(() => container.dispose());

  test('nickname can be set, edited and removed', () {
    final n = container.read(nicknameProvider.notifier);
    n.setNickname(1, 'Bulby');
    expect(container.read(nicknameProvider)[1], 'Bulby');
    n.setNickname(1, 'Bulba');
    expect(container.read(nicknameProvider)[1], 'Bulba');
    n.removeNickname(1);
    expect(container.read(nicknameProvider).containsKey(1), false);
  });

  test('toggleFavorite adds then removes', () {
    final f = container.read(favoritesProvider.notifier);
    f.toggleFavorite(4);
    expect(container.read(favoritePokemonProvider).map((p) => p.id), [4]);
    f.toggleFavorite(4);
    expect(container.read(favoritePokemonProvider), isEmpty);
  });

  test('type filter filters and clears', () {
    final t = container.read(typeFilterProvider.notifier);
    t.selectType('fire');
    expect(container.read(filteredPokemonProvider).map((p) => p.id), [4]);
    t.clearFilter();
    expect(container.read(filteredPokemonProvider).length, 3);
    expect(container.read(availableTypesProvider),
        ['fire', 'grass', 'poison', 'water']);
  });
}
