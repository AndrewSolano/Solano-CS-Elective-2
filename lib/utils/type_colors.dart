import 'package:flutter/material.dart';

Color typeColor(String type) {
  switch (type) {
    case 'fire':
      return Colors.deepOrange;
    case 'water':
      return Colors.blue;
    case 'grass':
      return Colors.green;
    case 'electric':
      return Colors.amber.shade700;
    case 'poison':
      return Colors.purple;
    case 'bug':
      return Colors.lightGreen.shade700;
    case 'flying':
      return Colors.indigo.shade300;
    case 'ground':
      return Colors.brown;
    case 'fairy':
      return Colors.pink.shade300;
    case 'psychic':
      return Colors.pinkAccent;
    case 'fighting':
      return Colors.red.shade800;
    case 'rock':
      return Colors.brown.shade400;
    case 'ghost':
      return Colors.deepPurple;
    case 'ice':
      return Colors.cyan;
    case 'dragon':
      return Colors.indigoAccent;
    case 'steel':
      return Colors.blueGrey;
    case 'dark':
      return Colors.grey.shade800;
    default:
      return Colors.grey;
  }
}
