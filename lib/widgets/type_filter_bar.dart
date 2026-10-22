import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/providers/type_filter_provider.dart';

/// Chip selector built from the types that exist in the loaded data.
/// "All" (or tapping the selected chip again) clears the filter.
class TypeFilterBar extends ConsumerWidget {
  const TypeFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final types = ref.watch(availableTypesProvider);
    final selected = ref.watch(typeFilterProvider);
    final notifier = ref.read(typeFilterProvider.notifier);

    if (types.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 52,
      child: Row(
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: selected == null,
                  onSelected: (_) => notifier.clearFilter(),
                ),
                for (final type in types) ...[
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: Text(capitalize(type)),
                    selected: selected == type,
                    onSelected: (isOn) =>
                        isOn ? notifier.selectType(type) : notifier.clearFilter(),
                  ),
                ],
              ],
            ),
          ),
          if (selected != null)
            IconButton(
              tooltip: 'Clear filter',
              icon: const Icon(Icons.filter_alt_off),
              onPressed: notifier.clearFilter,
            ),
        ],
      ),
    );
  }
}
