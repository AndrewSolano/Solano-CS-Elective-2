# Pokédex (Midterm: Riverpod)

Flutter Pokédex using **flutter_riverpod** for all app state.

## Features
- Pokémon list fetched asynchronously (loading / error / empty / success UI), pull-to-refresh and refresh button
- Nicknames (add / edit / remove), original name always kept
- Favorites with heart on every card and a collapsible panel on every screen
- Filter by Pokémon type (chips) with a clear option

## State (lib/providers)
| Provider | Type | Responsibility |
|---|---|---|
| `pokemonProvider` | `Notifier<PokemonState>` | `fetchPokemon()` and list status |
| `selectedPokemonIdProvider` | `Notifier<int?>` | which Pokémon the detail page shows |
| `nicknameProvider` | `Notifier<Map<int,String>>` | `setNickname`, `removeNickname` |
| `favoritesProvider` | `Notifier<Set<int>>` | `toggleFavorite`, `removeFavorite` |
| `favoritesPanelExpandedProvider` | `Notifier<bool>` | panel expand/collapse |
| `typeFilterProvider` | `Notifier<String?>` | `selectType`, `clearFilter` |
| `filteredPokemonProvider`, `availableTypesProvider`, `favoritePokemonProvider`, `selectedPokemonProvider` | `Provider` (derived) | computed from the above |
