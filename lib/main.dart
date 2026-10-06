import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pokedex/providers/pokemon_provider.dart';
import 'package:pokedex/screens/pokemon_list_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PokemonProvider()..fetchPokemon(),
      child: const PokedexApp(),
    ),
  );
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
