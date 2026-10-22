import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/screens/pokemon_list_screen.dart';

void main() {
  // ProviderScope is where all Riverpod provider state lives.
  runApp(const ProviderScope(child: PokedexApp()));
}

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.red, useMaterial3: true),
      home: const PokemonListScreen(),
    );
  }
}
