import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/providers/nickname_provider.dart';

/// Opens the nickname editor for [pokemon].
Future<void> showNicknameEditor(BuildContext context, Pokemon pokemon) {
  return showDialog<void>(
    context: context,
    builder: (_) => NicknameEditorDialog(pokemon: pokemon),
  );
}

class NicknameEditorDialog extends ConsumerStatefulWidget {
  final Pokemon pokemon;

  const NicknameEditorDialog({super.key, required this.pokemon});

  @override
  ConsumerState<NicknameEditorDialog> createState() =>
      _NicknameEditorDialogState();
}

class _NicknameEditorDialogState extends ConsumerState<NicknameEditorDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Pre-fill with the existing nickname (if any) so it can be edited.
    final existing = ref.read(nicknameProvider)[widget.pokemon.id] ?? '';
    _controller = TextEditingController(text: existing);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    if (_controller.text.trim().isEmpty) return;
    ref
        .read(nicknameProvider.notifier)
        .setNickname(widget.pokemon.id, _controller.text);
    Navigator.of(context).pop();
  }

  void _remove() {
    ref.read(nicknameProvider.notifier).removeNickname(widget.pokemon.id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final hasNickname =
        ref.watch(nicknameProvider).containsKey(widget.pokemon.id);

    return AlertDialog(
      title: Text(hasNickname ? 'Edit nickname' : 'Add nickname'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: 20,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _save(),
        decoration: InputDecoration(
          labelText: 'Nickname',
          hintText: widget.pokemon.displayName,
          helperText: 'Original name: ${widget.pokemon.displayName}',
        ),
      ),
      actions: [
        if (hasNickname)
          TextButton(
            onPressed: _remove,
            child: const Text('Remove'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        // Save is disabled while the field is blank.
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (context, value, _) => FilledButton(
            onPressed: value.text.trim().isEmpty ? null : _save,
            child: const Text('Save'),
          ),
        ),
      ],
    );
  }
}
