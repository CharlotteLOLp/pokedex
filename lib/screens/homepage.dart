import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart';
import 'package:poke_dex/models/pokemon.dart';
import 'package:poke_dex/utilities/custom_extensions.dart';
import 'package:poke_dex/utilities/pkm_type_colors.dart';
import 'package:poke_dex/widgets/pkm_type_chip.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pokemons = <Pokemon>[];

  final scrollController = ScrollController();

  var isFetching = false;

  @override
  void initState() {
    super.initState();

    fetchPokemons(start: 1);
    scrollController.addListener(onScroll);
  }

  onScroll() {
    final current = scrollController.position.pixels;
    final bottom = scrollController.position.maxScrollExtent;
    final atbottom = current == bottom;

    if (atbottom) {
      if (isFetching) return;
      fetchPokemons(start: pokemons.length + 1);
      scrollController.jumpTo(current + 100);
    }
  }

  fetchPokemons({required int start, int count = 25}) async {
    setState(() {
      isFetching = true;
    });

    final end = min(start + count, 1017);
    for (var i = start; i < end; i++) {
      final link = 'https://pokeapi.co/api/v2/pokemon/$i';
      final uri = Uri.parse(link);
      final response = await get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final pkm = Pokemon.fromJson(json);
        setState(() {
          pokemons.add(pkm);
        });
      }
    }
    setState(() {
      isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokedex'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: GridView.builder(
        controller: scrollController,
        itemCount: pokemons.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 4 / 3,
        ),
        itemBuilder: (context, index) {
          final pkm = pokemons[index];
          return PokemonCard(pokemon: pkm).animate().flipH().fade();
        },
      ),
    );
  }
}

class PokemonCard extends StatelessWidget {
  const PokemonCard({
    super.key,
    required this.pokemon,
  });

  final Pokemon pokemon;

  get style => null;

  @override
  Widget build(BuildContext context) {
    final mainType = pokemon.types.first.name;
    final mainColor = pkmTypeColors[mainType]!;

    return Card(
      color: Color(mainColor),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/pkm_detail', arguments: pokemon);
        },
        child: Stack(
          children: [
            Positioned(
              right: 4,
              bottom: 4,
              child: Hero(
                tag: pokemon.defaultImage,
                child: Image.network(
                  'https://cdn-icons-png.flaticon.com/512/1346/1346966.png',
                  width: 150,
                  height: 150,
                ),
              ),
            ),
            Positioned(
              right: 4,
              bottom: 4,
              child: Hero(
                tag: pokemon.defaultImage,
                child: Image.network(
                  pokemon.defaultImage,
                  width: 175,
                  height: 175,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pokemon.name.capitalize(),
                    style: const TextStyle(fontSize: 20),
                  ),
                  for (final type in pokemon.types) PokemonTypeChip(type: type)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
