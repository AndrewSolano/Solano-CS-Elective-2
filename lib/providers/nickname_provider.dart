import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Pokémon ID -> nickname. The original name is never touched.
class NicknameNotifier extends Notifier<Map<int, String>> {
  @override
  Map<int, String> build() => const {};

  /// Adds a nickname, or edits the existing one.
  /// A blank nickname is treated as removal.
  void setNickname(int pokemonId, String nickname) {
    final trimmed = nickname.trim();
    if (trimmed.isEmpty) {
      removeNickname(pokemonId);
      return;
    }
    state = {...state, pokemonId: trimmed};
  }

  void removeNickname(int pokemonId) {
    if (!state.containsKey(pokemonId)) return;
    state = Map.of(state)..remove(pokemonId);
  }
}

final nicknameProvider =
    NotifierProvider<NicknameNotifier, Map<int, String>>(NicknameNotifier.new);
