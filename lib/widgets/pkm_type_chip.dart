import 'package:flutter/material.dart';
import 'package:poke_dex/models/pokemon.dart';
import 'package:poke_dex/utilities/custom_extensions.dart';
import 'package:poke_dex/utilities/pkm_type_colors.dart';

class PokemonTypeChip extends StatelessWidget {
  const PokemonTypeChip({
    super.key,
    required this.type,
  });

  final Type type;
  @override
  Widget build(BuildContext context) {
    final color = pkmTypeColors[type.name]!;
    return Chip(
      backgroundColor: Color(color),
      label: Text(type.name.capitalize()),
    );
  }
}
